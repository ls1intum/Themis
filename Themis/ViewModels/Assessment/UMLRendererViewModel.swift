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

class UMLRendererViewModel: ExerciseRendererViewModel {
    @Published var umlModel: UMLModel?
    @Published var selectedElement: SelectableUMLItem?
    @Published var highlights: [UMLHighlight] = [] {
        didSet {
            undoManager.registerUndo(withTarget: self) { target in
                target.highlights = oldValue
            }
        }
    }
    
    /// Contains UML elements that do not have a parent. Such elements are a good starting point when we need to determine which element the user tapped on.
    private var orphanElements = [UMLElement]()
    
    private lazy var symbolSize: Double = {
        (fontSize * 2.0).rounded()
    }()
    
    /// Sets this VM up based on the given submission
    @MainActor
    func setup(basedOn submission: BaseSubmission? = nil, _ assessmentResult: AssessmentResult) {
        guard let modelingSubmission = submission as? ModelingSubmission,
              let modelData = modelingSubmission.model?.data(using: .utf8) else {
            return
        }
        
        do {
            umlModel = try JSONDecoder().decode(UMLModel.self, from: modelData)
            determineChildren()
            orphanElements = umlModel?.elements?.filter({ $0.owner == nil }) ?? []
        } catch {
            log.error("Could not parse UML string: \(error)")
        }
        
        let feedbacks = assessmentResult.inlineFeedback
        setupHighlights(basedOn: feedbacks)
    }
    
    func render(_ context: inout GraphicsContext, size: CGSize) {
        guard let model = umlModel else {
            return
        }
        
        let canvasBounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        var renderer: any UMLDiagramRenderer
        
        switch model.type {
        case .classDiagram:
            renderer = UMLClassDiagramRenderer(context: context, canvasBounds: canvasBounds)
        default:
            renderer = UMLClassDiagramRenderer(context: context, canvasBounds: canvasBounds)
            log.error("Attempted to draw an unknown diagram type")
        }
        
        renderer.render(umlModel: model)
    }
    
    @MainActor
    func selectItem(at point: CGPoint) {
        selectedElement = getSelectableItem(at: point)
        
        if let selectedElement {
            log.verbose("Selected UML element: \(selectedElement.name ?? "no name")")
            
            if let matchingHighlight = highlights.first(where: { $0.rect == selectedElement.boundsAsCGRect }) { // Edit Feedback
                self.selectedFeedbackForEditingId = matchingHighlight.assessmentFeedbackId
                self.showEditFeedback = true
            } else if !pencilModeDisabled { // Add Fedback
                self.showAddFeedback = true
            }
        }
    }
    
    private func getSelectableItem(at point: CGPoint) -> SelectableUMLItem? {
        // Look for relationships
        if let foundRelationship = umlModel?.relationships?.first(where: { $0.boundsContains(point: point) }) {
            return foundRelationship
        }
        
        // Look for elements
        for element in orphanElements {
            if element.boundsContains(point: point) {
                return element.getChild(at: point) ?? element
            }
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
    
    // MARK: - Highlight-Related Functions
    @MainActor
    private func setupHighlights(basedOn feedbacks: [AssessmentFeedback], shouldWipeUndo: Bool = true) {
        guard umlModel?.elements != nil else {
            log.error("Could not find elements in the model when attempting to setup highlights")
            return
        }
        
        for assessmentFeedback in feedbacks {
            guard let referencedItemId = assessmentFeedback.baseFeedback.reference?.components(separatedBy: ":")[1],
                  let referencedItem = findSelectableItem(byId: referencedItemId),
                  let elementRect = referencedItem.boundsAsCGRect else {
                log.error("Could not create a highlight for the following referenced feedback: \(assessmentFeedback)")
                continue
            }
            
            let highlightPlacement = type(of: referencedItem) == UMLElement.self ? UMLHighlightPlacement.topRight : .center
            let newHighlight = UMLHighlight(assessmentFeedbackId: assessmentFeedback.id,
                                            symbol: UMLBadgeSymbol.symbol(forCredits: assessmentFeedback.baseFeedback.credits ?? 0.0),
                                            rect: elementRect,
                                            placement: highlightPlacement)
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
        Image(systemName: UMLBadgeSymbol.checkmark.systemName)
            .bold()
            .symbolRenderingMode(.palette)
            .foregroundStyle(UMLBadgeSymbol.checkmark.color, .secondary.opacity(0.3))
            .tag(UMLBadgeSymbol.checkmark)
        
        // Negative referenced feedback
        Image(systemName: UMLBadgeSymbol.cross.systemName)
            .bold()
            .symbolRenderingMode(.palette)
            .foregroundStyle(UMLBadgeSymbol.cross.color, .secondary.opacity(0.3))
            .tag(UMLBadgeSymbol.cross)
        
        // Neutral referenced feedback
        Image(systemName: UMLBadgeSymbol.exclamation.systemName)
            .bold()
            .symbolRenderingMode(.palette)
            .foregroundStyle(UMLBadgeSymbol.exclamation.color, .secondary.opacity(0.3))
            .tag(UMLBadgeSymbol.exclamation)
    }
    
    func renderHighlights(_ context: inout GraphicsContext, size: CGSize) {
        // Highlight selected element if there is one
        if !pencilModeDisabled,
           let selectedElement,
           let elementRect = selectedElement.boundsAsCGRect {
            let highlightRect = elementRect.insetBy(dx: -1, dy: -1) // slightly larger than elementRect
            context.stroke(Path(highlightRect),
                           with: .color(Color.themisSecondary.opacity(0.5)),
                           style: .init(lineWidth: 5)
            )
        }
        
        // Highlight all elements associated with a feedback
        for highlight in highlights {
            let badgeSymbol = highlight.symbol
            let badgeCircleSideLength = symbolSize
            
            let badgeCircleX: CGFloat
            let badgeCircleY: CGFloat
            
            // Determine badge coordinates
            switch highlight.placement {
            case .topRight:
                badgeCircleX = highlight.rect.maxX - badgeCircleSideLength / 2
                badgeCircleY = highlight.rect.minY - badgeCircleSideLength / 2
            case .center:
                badgeCircleX = highlight.rect.midX - badgeCircleSideLength / 2
                badgeCircleY = highlight.rect.midY - badgeCircleSideLength / 2
            }
            
            guard let resolvedBadgeSymbol = context.resolveSymbol(id: badgeSymbol) else {
                log.warning("Could not resolve the highlight badge for: \(highlight)")
                continue
            }
            
            context.draw(resolvedBadgeSymbol, in: CGRect(x: badgeCircleX,
                                                         y: badgeCircleY,
                                                         width: badgeCircleSideLength,
                                                         height: badgeCircleSideLength))
        }
    }
    
    @MainActor
    private func createHighlight(for feedback: AssessmentFeedback) {
        guard let umlItem = (feedback.detail as? ModelingFeedbackDetail)?.umlItem else {
            return
        }
        setupHighlights(basedOn: [feedback], shouldWipeUndo: false)
        undoManager.endUndoGrouping() // undo group with addFeedback in AssessmentResult
    }
    
    @MainActor
    private func updateHighlight(for feedback: AssessmentFeedback) {
        guard let oldHighlightIndex = highlights.firstIndex(where: { $0.assessmentFeedbackId == feedback.id }) else {
            return
        }
        
        let oldHighlight = highlights[oldHighlightIndex]
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
}

struct UMLHighlight {
    var assessmentFeedbackId: UUID
    var symbol: UMLBadgeSymbol
    var rect: CGRect
    var placement: UMLHighlightPlacement
}

enum UMLHighlightPlacement {
    case topRight, center
}
