//
//  UMLRelationshipType.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 17.07.23.
//

import Foundation

enum UMLRelationshipType: String, Decodable {
    case flowchartFlowline = "FlowchartFlowline"
    case syntaxTreeLink = "SyntaxTreeLink"
    case reachabilityGraphArc = "ReachabilityGraphArc"
    case petriNetArc = "PetriNetArc"
    case deploymentAssociation = "DeploymentAssociation"
    case deploymentInterfaceProvided = "DeploymentInterfaceProvided"
    case deploymentInterfaceRequired = "DeploymentInterfaceRequired"
    case deploymentDependency = "DeploymentDependency"
    case componentInterfaceProvided = "ComponentInterfaceProvided"
    case componentInterfaceRequired = "ComponentInterfaceRequired"
    case componentDependency = "ComponentDependency"
    case communicationLink = "CommunicationLink"
    case useCaseAssociation = "UseCaseAssociation"
    case useCaseGeneralization = "UseCaseGeneralization"
    case useCaseInclude = "UseCaseInclude"
    case useCaseExtend = "UseCaseExtend"
    case activityControlFlow = "ActivityControlFlow"
    case objectLink = "ObjectLink"
    case classBidirectional = "ClassBidirectional"
    case classUnidirectional = "ClassUnidirectional"
    case classInheritance = "ClassInheritance"
    case classRealization = "ClassRealization"
    case classDependency = "ClassDependency"
    case classAggregation = "ClassAggregation"
    case classComposition = "ClassComposition"
}
