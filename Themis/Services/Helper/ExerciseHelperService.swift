//
//  ExerciseHelperService.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 05.07.23.
//
// swiftlint:disable type_name

import Foundation
import SharedModels
import APIClient

/// A service that contains requests for fetching supplementary data for exercises
struct ExerciseHelperService {
    struct GetProgrammingExerciseWithTemplateAndSolutionParticipations: APIRequest {
        typealias Response = Exercise

        var exerciseId: Int

        var method: HTTPMethod {
            .get
        }

        var resourceName: String {
            "api/programming-exercises/\(exerciseId)/with-template-and-solution-participation"
        }
    }
    
    /// Fetches the exercise with template and solution participations
    func getProgrammingExerciseWithTemplateAndSolutionParticipations(exerciseId: Int) async throws -> Exercise {
        try await APIClient().sendRequest(GetProgrammingExerciseWithTemplateAndSolutionParticipations(exerciseId: exerciseId)).get().0
    }
}
