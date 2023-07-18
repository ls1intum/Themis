//
//  UMLElementType.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 17.07.23.
//

import Foundation

enum UMLElementType: String, Decodable {
    case colorLegend = "ColorLegend"
    case flowchartTerminal = "FlowchartTerminal"
    case flowchartProcess = "FlowchartProcess"
    case flowchartDecision = "FlowchartDecision"
    case flowchartInputOutput = "FlowchartInputOutput"
    case flowchartFunctionCall = "FlowchartFunctionCall"
    case syntaxTreeTerminal = "SyntaxTreeTerminal"
    case syntaxTreeNonterminal = "SyntaxTreeNonterminal"
    case reachabilityGraphMarking = "ReachabilityGraphMarking"
    case petriNetPlace = "PetriNetPlace"
    case petriNetTransition = "PetriNetTransition"
    case deploymentNode = "DeploymentNode"
    case deploymentComponent = "DeploymentComponent"
    case deploymentArtifact = "DeploymentArtifact"
    case deploymentInterface = "DeploymentInterface"
    case component = "Component"
    case componentInterface = "ComponentInterface"
    case communicationLinkMessage = "CommunicationLinkMessage"
    case useCase = "UseCase"
    case useCaseActor = "UseCaseActor"
    case useCaseSystem = "UseCaseSystem"
    case activity = "Activity"
    case activityActionNode = "ActivityActionNode"
    case activityFinalNode = "ActivityFinalNode"
    case activityForkNode = "ActivityForkNode"
    case activityForkNodeHorizontal = "ActivityForkNodeHorizontal"
    case activityInitialNode = "ActivityInitialNode"
    case activityMergeNode = "ActivityMergeNode"
    case activityObjectNode = "ActivityObjectNode"
    case objectName = "ObjectName"
    case objectAttribute = "ObjectAttribute"
    case objectMethod = "ObjectMethod"
    case package = "Package"
    //swiftlint:disable:next identifier_name
    case Class = "Class"
    case abstractClass = "AbstractClass"
    case interface = "Interface"
    case enumeration = "Enumeration"
    case classAttribute = "ClassAttribute"
    case classMethod = "ClassMethod"
    
    /// The string that should be shown on the UML elements to indicate the type of the element
    var annotationTitle: String {
        switch self {
        case .interface:
            return "<<interface>>"
        case .enumeration:
            return "<<enumeration>>"
        case .abstractClass:
            return "<<abstract>>"
        default:
            return ""
        }
    }
}
