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
    @Published var selectedElement: UMLElement?
    @Published var highlights: [UMLHighlight] = []

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
    
    private func setupHighlights(basedOn feedbacks: [AssessmentFeedback]) {
        guard let elements = umlModel?.elements else {
            log.error("Could not find elements in the model when attempting to setup highlights")
            return
        }
        
//        let relationships = umlModel?.relationships
        
        for assessmentFeedback in feedbacks {
            guard let referencedElementId = assessmentFeedback.baseFeedback.reference?.components(separatedBy: ":")[1],
                  let referencedElement = elements.first(where: { $0.id == referencedElementId }),
                  let xCoordinate = referencedElement.bounds?.x,
                  let yCoordinate = referencedElement.bounds?.y,
                  let width = referencedElement.bounds?.width,
                  let height = referencedElement.bounds?.height else {
                log.error("Could not create a highlight for the following referenced feedback: \(assessmentFeedback)")
                continue
            }
            
            let elementRect = CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)
            let newHighlight = UMLHighlight(assessmentFeedbackId: assessmentFeedback.id,
                                            symbol: UMLBadgeSymbol.symbol(forCredits: assessmentFeedback.baseFeedback.credits ?? 0.0),
                                            rect: elementRect)
            highlights.append(newHighlight)
        }
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
        if let selectedElement,
           let xCoordinate = selectedElement.bounds?.x,
           let yCoordinate = selectedElement.bounds?.y,
           let width = selectedElement.bounds?.width,
           let height = selectedElement.bounds?.height {
            let elementRect = CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)
            context.fill(Path(elementRect), with: .color(Color.yellow.opacity(0.5)))
        }
        
        // Highlight all elements associated with a feedback
        for highlight in highlights {
            let badgeCircleSideLength = symbolSize
            let badgeCircleX = highlight.rect.maxX - badgeCircleSideLength / 2
            let badgeCircleY = highlight.rect.minY - badgeCircleSideLength / 2
            let badgeSymbol = highlight.symbol
            
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
    
    func selectElement(at point: CGPoint) {
        selectedElement = getElement(at: point)
        
        if let selectedElement {
            log.verbose("Selected UML element: \(selectedElement.name ?? "no name")")
//            self.selectedFeedbackForEditingId = associatedFeedbackId
        }
    }
    
    private func getElement(at point: CGPoint) -> UMLElement? {
        for element in orphanElements {
            if element.boundsContains(point: point) {
                return element.getChild(at: point) ?? element
            }
        }
        
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
}

extension UMLRendererViewModel: FeedbackDelegate {}

struct UMLHighlight {
    var assessmentFeedbackId: UUID
    var symbol: UMLBadgeSymbol
    var rect: CGRect
}
