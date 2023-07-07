//
//  UMLModel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.07.23.
//
// TODO: Split this into several files
import Foundation
import SharedModels

struct UMLModel: Decodable {
    let version: String?
    let type: UMLDiagramType?
    let size: Size?
    let elements: [UMLElement]?
//    let relationships: [UMLRelationship]?
}

struct UMLElement: Decodable {
    let id: String?
    let name: String?
    let type: UMLElementType?
    let owner: String?
    let bounds: Boundary?
    let assessmentNote: String?
}

struct Size: Decodable {
    let width: Double
    let height: Double
}

struct Boundary: Decodable {
    // swiftlint:disable identifier_name
    let x: Double
    let y: Double
    let width: Double
    let height: Double
}

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
}
