//
//  UMLRendererViewModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 05.07.23.
//

import Foundation
import SharedModels
import Common
import SwiftUI
import ApollonShared

class UMLRendererViewModel: ExerciseRendererViewModel {
    @Published var umlModel: UMLModel?
    @Published var selectedElement: SelectableUMLItem?
    @Published var error: Error?
    @Published var currentDragLocation = CGPoint.zero
    @Published var offset = CGPoint(x: 15, y: 15)
    
    /// Intended to get user's attention to a particular UML item temporarily
    @Published var temporaryHighlight: UMLHighlight? {
        willSet {
            if newValue != nil {
                temporaryHighlightRemovalTask?.cancel()
                
                temporaryHighlightRemovalTask = Task { [weak self] in
                    try await Task.sleep(nanoseconds: 400_000_000)
                    try Task.checkCancellation()
                    await MainActor.run(body: { [weak self] in
                        self?.temporaryHighlight = nil
                    })
                }
            }
        }
    }
    
    @Published var highlights: [UMLHighlight] = [] {
        didSet {
            undoManager.registerUndo(withTarget: self) { target in
                target.highlights = oldValue
            }
        }
    }
    
    var diagramSize: CGSize {
        umlModel?.size?.asCGSize ?? CGSize()
    }
    
    /// Contains UML elements that do not have a parent. Such elements are a good starting point when we need to determine which element the user tapped on.
    private var orphanElements = [UMLElement]()
    
    /// A Task that sets the value of `temporaryHighlight` to nil after some time
    private var temporaryHighlightRemovalTask: Task<(), Error>?
    
    private var symbolSize = 30.0
    
    /// Sets this VM up based on the given submission
    @MainActor
    func setup(basedOn submission: BaseSubmission? = nil, _ assessmentResult: AssessmentResult) {
        guard let modelingSubmission = submission as? ModelingSubmission,
              let modelData = modelingSubmission.model?.data(using: .utf8) else {
            log.error("Could not get model data from submission")
            setError(.couldNotParseDiagram)
            return
        }
        self.umlModel = nil
        self.selectedElement = nil
        self.highlights = []
        self.orphanElements = []
        
        do {
            umlModel = try JSONDecoder().decode(UMLModel.self, from: modelData)
            guard let type = umlModel?.type, !UMLDiagramType.isDiagramTypeUnsupported(diagramType: type) else {
                log.error("This diagram type is not yet supported")
                setError(.diagramNotSupported)
                return
            }
            determineChildren()
            orphanElements = umlModel?.elements?.filter({ $0.owner == nil }) ?? []
        } catch {
            log.error("Could not parse UML string: \(error)")
            setError(.couldNotParseDiagram)
        }
        
        let feedbacks = assessmentResult.inlineFeedback + assessmentResult.automaticFeedback
        
        setupHighlights(basedOn: feedbacks)
    }
    
    /// Sets this VM up based on the given UML Model string
    @MainActor
    func setup(basedOn umlModelString: String) {
        guard let modelData = umlModelString.data(using: .utf8) else {
            log.error("Invalid UML model string")
            setError(.couldNotParseDiagram)
            return
        }
        self.umlModel = nil
        self.selectedElement = nil
        self.highlights = []
        self.orphanElements = []
        
        do {
            umlModel = try JSONDecoder().decode(UMLModel.self, from: modelData)
            guard let type = umlModel?.type, !UMLDiagramType.isDiagramTypeUnsupported(diagramType: type) else {
                log.error("This diagram type is not yet supported")
                setError(.diagramNotSupported)
                return
            }
            determineChildren()
            orphanElements = umlModel?.elements?.filter({ $0.owner == nil }) ?? []
        } catch {
            log.error("Could not parse UML string: \(error)")
            setError(.couldNotParseDiagram)
        }
        
        undoManager.removeAllActions()
    }
    
    @MainActor
    func render(_ context: inout GraphicsContext, size: CGSize) {
        guard let model = umlModel,
              let modelType = model.type,
              !diagramTypeUnsupported else {
            return
        }
        let umlContext = UMLGraphicsContext(context)
        let canvasBounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let renderer = UMLDiagramRendererFactory.renderer(for: modelType,
                                                          context: umlContext,
                                                          canvasBounds: canvasBounds,
                                                          fontSize: fontSize)
        
        if let renderer {
            renderer.render(umlModel: model)
        } else {
            log.error("Attempted to draw an unknown diagram type")
            diagramTypeUnsupported = true
            setError(.diagramNotSupported)
        }
    }
    
    private func setError(_ error: UserFacingError) {
        if self.error == nil {
            Task { @MainActor [weak self] in
                self?.error = error
            }
        }
    }
    
    @MainActor
    /// Sets the drag location to the specified point
    /// - Parameter point: when nil, the drag location is set in such a way that centers the diagram
    func setDragLocation(at point: CGPoint? = nil) {
        if let point {
            currentDragLocation = point
        } else {
            currentDragLocation = .init(x: diagramSize.height - 50, // 50 – default padding added by Apollon
                                        y: diagramSize.width - 50)
        }
    }
    
    @MainActor
    func selectItem(at point: CGPoint) {
        selectedElement = getSelectableItem(at: point)
        
        if let selectedElement {
            log.verbose("Selected UML element: \(selectedElement.name ?? "no name")")
            
            if let matchingHighlight = highlights.first(where: { $0.elementBounds == selectedElement.boundsAsCGRect }) { // Edit Feedback
                self.selectedFeedbackForEditingId = matchingHighlight.assessmentFeedbackId
                self.showEditFeedback = true
            } else if !pencilModeDisabled { // Add Fedback
                self.showAddFeedback = true
            }
        }
    }
    
    private func getSelectableItem(at point: CGPoint) -> SelectableUMLItem? {
        let point = CGPoint(x: point.x - offset.x,
                            y: point.y - offset.y)
        // Look for relationships
        if let foundRelationship = umlModel?.relationships?.first(where: { $0.boundsContains(point: point) }) {
            return foundRelationship
        }
        
        // Look for elements
        for element in orphanElements where element.boundsContains(point: point) {
            return element.getChild(at: point) ?? element
        }
        
        // No item found at given point :(
        return nil
    }
    
    /// Iterates over UML elements to determine their children
    private func determineChildren() {
        guard let elements = umlModel?.elements else {
            log.warning("Could not find elements in the model")
            return
        }
        var potentialChildren = elements.filter({ $0.owner != nil })
        
        for (elementIndex, element) in elements.enumerated().reversed() {
            for (index, potentialChild) in potentialChildren.enumerated().reversed() where potentialChild.owner == element.id {
                elements[elementIndex].addChild(potentialChild)
                potentialChildren.remove(at: index)
            }
        }
        
        umlModel?.elements = elements
    }
    
    /// Looks up for a selectable UML item (UMLElement or UMLRelationship) by the given id
    private func findSelectableItem(byId id: String) -> SelectableUMLItem? {
        var selectableItem: SelectableUMLItem?
        
        if let elements = umlModel?.elements,
           let foundElement = elements.first(where: { $0.id == id }) {
            selectableItem = foundElement
        } else if let relationships = umlModel?.relationships,
                  let foundRelationship = relationships.first(where: { $0.id == id }) {
            selectableItem = foundRelationship
        }
        
        return selectableItem
    }
    
    func generateFeedbackDetail() -> ModelingFeedbackDetail {
        ModelingFeedbackDetail(umlItem: selectedElement)
    }
}

// MARK: - Highlight-Related Functions
extension UMLRendererViewModel {
    @MainActor
    private func setupHighlights(basedOn feedbacks: [AssessmentFeedback], shouldWipeUndo: Bool = true) {
        guard umlModel?.elements != nil else {
            log.error("Could not find elements in the model when attempting to setup highlights")
            return
        }
        
        for assessmentFeedback in feedbacks {
            guard let referencedItemId = assessmentFeedback.baseFeedback.reference?.components(separatedBy: ":")[1],
                  let referencedItem = findSelectableItem(byId: referencedItemId),
                  let elementRect = referencedItem.boundsAsCGRect,
                  let temporaryHighlightPath = referencedItem.temporaryHighlightPath,
                  let badgeLocation = referencedItem.badgeLocation else {
                log.error("Could not create a highlight for the following referenced feedback: \(assessmentFeedback)")
                continue
            }
            
            let isSuggested = assessmentFeedback.baseFeedback.type?.isAutomatic ?? false
            let highlightPath = isSuggested ? referencedItem.suggestedHighlightPath ?? .init() : Path(elementRect)
            
            let newHighlight = UMLHighlight(assessmentFeedbackId: assessmentFeedback.id,
                                            symbol: UMLBadgeSymbol.symbol(forCredits: assessmentFeedback.baseFeedback.credits ?? 0.0),
                                            elementBounds: elementRect,
                                            path: highlightPath,
                                            badgeLocation: badgeLocation,
                                            temporaryHighlightPath: temporaryHighlightPath,
                                            isSuggested: isSuggested)
            highlights.append(newHighlight)
        }
        
        if shouldWipeUndo {
            undoManager.removeAllActions()
        }
    }
    
    @ViewBuilder
    /// Generates all possible symbol views that can be drawn on the canvas used for rendering highlights
    func generatePossibleSymbols() -> some View {
        // Positive referenced feedback
        Image(UMLBadgeSymbol.checkmark.imageName)
            .tag(UMLBadgeSymbol.checkmark)
        
        // Negative referenced feedback
        Image(UMLBadgeSymbol.cross.imageName)
            .tag(UMLBadgeSymbol.cross)
        
        // Neutral referenced feedback
        Image(UMLBadgeSymbol.exclamation.imageName)
            .tag(UMLBadgeSymbol.exclamation)
    }
    
    @MainActor
    func renderHighlights(_ context: inout GraphicsContext, size: CGSize) {
        var context = UMLGraphicsContext(context, offset: offset)
        
        // Highlight selected element if there is one
        if !pencilModeDisabled,
           let selectedElement,
           let highlightPath = selectedElement.highlightPath {
            if type(of: selectedElement) == UMLRelationship.self {
                context.fill(highlightPath,
                             with: .color(Color.selectedUMLItemColor))
            } else {
                context.stroke(highlightPath,
                               with: .color(Color.selectedUMLItemColor),
                               style: .init(lineWidth: 5)
                )
            }
        }
        
        // Highlight all elements associated with a feedback
        for highlight in highlights {
            let badgeSymbol = highlight.symbol
            let badgeCircleSideLength = symbolSize
            
            let badgeCircleX: CGFloat
            let badgeCircleY: CGFloat
            
            // Determine badge coordinates
            badgeCircleX = highlight.badgeLocation.x - badgeCircleSideLength / 2
            badgeCircleY = highlight.badgeLocation.y - badgeCircleSideLength / 2
            
            guard let resolvedBadgeSymbol = context.resolveSymbol(id: badgeSymbol) else {
                log.warning("Could not resolve the highlight badge for: \(highlight)")
                continue
            }
            
            let badgeRect = CGRect(x: badgeCircleX,
                                   y: badgeCircleY,
                                   width: badgeCircleSideLength,
                                   height: badgeCircleSideLength)
            
            let badgeCircle = Path(ellipseIn: badgeRect)
            
            context.fill(badgeCircle, with: .color(Color(UIColor.systemGray5).opacity(0.85)))
            context.draw(resolvedBadgeSymbol, in: badgeRect.insetBy(dx: 6, dy: 6))
            
            if highlight.isSuggested {
                context.fill(highlight.path, with: .color(Color.modelingSuggestedFeedback))
            }
        }
        
        renderTemporaryHighlightIfNeeded(&context, size: size)
    }
    
    @MainActor
    private func renderTemporaryHighlightIfNeeded(_ context: inout UMLGraphicsContext, size: CGSize) {
        guard let temporaryHighlight else {
            return
        }
        
        let highlightPath = temporaryHighlight.temporaryHighlightPath
        context.stroke(highlightPath, with: .color(Color.primary), style: .init(lineWidth: 3))
    }
    
    @MainActor
    private func createHighlight(for feedback: AssessmentFeedback) {
        setupHighlights(basedOn: [feedback], shouldWipeUndo: false)
        undoManager.endUndoGrouping() // undo group with addFeedback in AssessmentResult
    }
    
    @MainActor
    private func updateHighlight(for feedback: AssessmentFeedback) {
        guard let oldHighlightIndex = highlights.firstIndex(where: { $0.assessmentFeedbackId == feedback.id }) else {
            return
        }
        
        let newSymbol = UMLBadgeSymbol.symbol(forCredits: feedback.baseFeedback.credits ?? 0.0)
        
        highlights[oldHighlightIndex].symbol = newSymbol
    }
    
    @MainActor
    private func deleteHighlight(for feedback: AssessmentFeedback) {
        highlights.removeAll(where: { $0.assessmentFeedbackId == feedback.id })
        
        if feedback.scope == .inline {
            undoManager.endUndoGrouping() // undo group with deleteFeedback in AssessmentResult
        }
    }
    
    /// Creates a temporary highlight to get user's attention to a particular UML item
    @MainActor
    private func createTemporaryHighlight(for feedback: AssessmentFeedback) {
        guard let existingHighlight = highlights.first(where: { $0.assessmentFeedbackId == feedback.id }) else {
            return
        }
        
        temporaryHighlight = existingHighlight
        temporaryHighlight?.isTemporary = true
    }
}

extension UMLRendererViewModel: FeedbackDelegate {
    @MainActor
    func onFeedbackCreation(_ feedback: AssessmentFeedback) {
        createHighlight(for: feedback)
    }
    
    @MainActor
    func onFeedbackUpdate(_ feedback: AssessmentFeedback) {
        updateHighlight(for: feedback)
    }
    
    @MainActor
    func onFeedbackDeletion(_ feedback: AssessmentFeedback) {
        deleteHighlight(for: feedback)
    }
    
    @MainActor
    func onFeedbackCellTap(_ feedback: AssessmentFeedback, participationId: Int?, templateParticipationId: Int?) {
        createTemporaryHighlight(for: feedback)
    }
}

struct UMLHighlight {
    var assessmentFeedbackId: UUID
    var symbol: UMLBadgeSymbol
    var elementBounds: CGRect
    var path: Path
    var badgeLocation: CGPoint
    var temporaryHighlightPath: Path
    var isSuggested: Bool
    var isTemporary = false
}
