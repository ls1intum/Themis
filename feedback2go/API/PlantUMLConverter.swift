//
//  PlantUMLConverter.swift
//  feedback2go
//
//  Created by Andreas Cselovszky on 14.11.22.
//

import Foundation
import SwiftUI

/// gets the plantuml as a png
struct GetPNGfromPlantUML: APIRequest {
    @Environment(\.colorScheme) var colorScheme
    let plantuml: String
    var request: Request {
        Request(method: .get, path: "/api/plantuml/png", params: [URLQueryItem(name: "plantuml", value: plantuml), URLQueryItem(name: "useDarkTheme", value: "\(colorScheme == .dark)")])
    }
}

/// get the plantuml as a svg
struct GetSVGfromPlantUML: APIRequest {
    @Environment(\.colorScheme) var colorScheme
    let plantuml: String
    var request: Request {
        Request(method: .get, path: "/api/plantuml/svg", params: [URLQueryItem(name: "plantuml", value: plantuml), URLQueryItem(name: "useDarkTheme", value: "\(colorScheme == .dark)")])
    }
}
