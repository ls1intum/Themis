//
//  PlantUMLConverter.swift
//  Themis
//
//  Created by Andreas Cselovszky on 14.11.22.
//

import Foundation
import SwiftUI

extension ArtemisAPI {
    // TODO: Return Types
    /// gets the plantuml as a png
    static func getPNGFromPlantUML(plantuml: String) async throws -> Data {
        @Environment(\.colorScheme) var colorScheme
        let request = Request(method: .get, path: "/api/plantuml/png", params: [URLQueryItem(name: "plantuml", value: plantuml), URLQueryItem(name: "useDarkTheme", value: "\(colorScheme == .dark)")])
        return try await sendRequest(Data.self, request: request)
    }

    /// gets the plantuml as a svg
    static func getSVGFromPlantUML(plantuml: String) async throws -> Data {
        @Environment(\.colorScheme) var colorScheme
        let request = Request(method: .get, path: "/api/plantuml/svg", params: [URLQueryItem(name: "plantuml", value: plantuml), URLQueryItem(name: "useDarkTheme", value: "\(colorScheme == .dark)")])
        return try await sendRequest(Data.self, request: request)
    }
}
