//
//  PlantUMLConverter.swift
//  feedback2go
//
//  Created by Andreas Cselovszky on 14.11.22.
//

import Foundation

struct GetPNGfromPlantUML {
    let plantuml: String
    let darkMode: Bool
    var request: Request {
        Request(method: .get, path: "/api/plantuml/png?plantuml=\(plantuml)&useDarkTheme=\(darkMode)")
    }
}

struct GetSVGfromPlantUML {
    let plantuml: String
    let darkMode: Bool
    var request: Request {
        Request(method: .get, path: "/api/plantuml/svg?plantuml=\(plantuml)&useDarkTheme=\(darkMode)")
    }
}
