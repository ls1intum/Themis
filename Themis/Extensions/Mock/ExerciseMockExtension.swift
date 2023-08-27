//
//  ExerciseMockExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 24.05.23.
//
// swiftlint:disable all

import Foundation
import SharedModels

extension Exercise {
    /// A mock text exercise
    static var mockText: Exercise {
        let exerciseData = Data("""
        {
            "type": "text",
            "id": 6314,
            "title": "Essay About Your Dream Spaceship",
            "maxPoints": 100.0,
            "bonusPoints": 0.0,
            "assessmentType": "SEMI_AUTOMATIC",
            "mode": "INDIVIDUAL",
            "allowComplaintsForAutomaticAssessments": false,
            "allowManualFeedbackRequests": false,
            "includedInOverallScore": "INCLUDED_COMPLETELY",
            "problemStatement": "Write an essay titled ",
            "gradingInstructions": "Here are some instructions",
            "presentationScoreEnabled": false,
            "secondCorrectionEnabled": false,
            "course": {
                "id": 3342,
                "title": "NASA Space Course",
                "shortName": "ios2223cit",
                "studentGroupName": "artemis-ios2223cit-students",
                "teachingAssistantGroupName": "artemis-ios2223cit-tutors",
                "editorGroupName": "artemis-ios2223cit-editors",
                "instructorGroupName": "artemis-ios2223cit-instructors",
                "testCourse": true,
                "onlineCourse": false,
                "courseInformationSharingConfiguration": "COMMUNICATION_AND_MESSAGING",
                "maxComplaints": 3,
                "maxTeamComplaints": 3,
                "maxComplaintTimeDays": 7,
                "maxRequestMoreFeedbackTimeDays": 7,
                "maxComplaintTextLimit": 2000,
                "maxComplaintResponseTextLimit": 2000,
                "registrationEnabled": true,
                "registrationConfirmationMessage": "Hi",
                "presentationScore": 0,
                "accuracyOfScores": 1,
                "requestMoreFeedbackEnabled": true,
                "complaintsEnabled": true
            },
            "gradingCriteria": [
                {
                    "id": 14,
                    "structuredGradingInstructions": [
                        {
                            "id": 28,
                            "credits": 5.0,
                            "gradingScale": "Creativity",
                            "instructionDescription": "The student used has high creativity",
                            "feedback": "Very creative essay!",
                            "usageCount": 1
                        },
                        {
                            "id": 29,
                            "credits": -90.0,
                            "gradingScale": "ChatGPT",
                            "instructionDescription": "The student used ChatGPT or a similar tool",
                            "feedback": "You should write the content yourself. AI tools are not allowed!",
                            "usageCount": 1
                        }
                    ],
                    "title": "Content"
                }
            ],
            "tutorParticipations": [
                {
                    "status": "NOT_PARTICIPATED"
                }
            ],
            "exampleSolution": "My dream spaceship would be a sleek and innovative vessel built for exploration and discovery. It would be powered by a fusion engine, enabling faster-than-light travel and efficient use of resources. The ship would be able to accommodate a crew of up to 10 people and would have state-of-the-art living quarters and amenities, including artificial gravity and a hydroponic garden for sustainable food production. The ship would be equipped with advanced scientific instruments and a powerful telescope for observing distant galaxies. I dream of using this spaceship to explore the vast unknowns of the universe and make groundbreaking discoveries that will change our understanding of the cosmos",
            "type": "text",
            "automaticAssessmentEnabled": true,
            "exerciseType": "TEXT",
            "studentAssignedTeamIdComputed": false,
            "gradingInstructionFeedbackUsed": false,
            "exampleSolutionPublished": true,
            "teamMode": false,
            "visibleToStudents": true
        }
        """.utf8)
        
        return try! JSONDecoder().decode(Exercise.self, from: exerciseData)
    }
}
// swiftlint:enable all
