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
    static var mockFileUpload: Exercise {
        let exerciseData = Data("""
        {
            "type": "file-upload",
            "id": 6736,
            "title": "Upload a PDF",
            "maxPoints": 70.0,
            "bonusPoints": 0.0,
            "releaseDate": "2023-07-20T14:03:00+02:00",
            "startDate": "2023-07-20T14:03:00+02:00",
            "dueDate": "2023-07-20T14:07:00+02:00",
            "assessmentDueDate": "2023-10-31T13:07:00+01:00",
            "mode": "INDIVIDUAL",
            "allowComplaintsForAutomaticAssessments": false,
            "allowManualFeedbackRequests": false,
            "includedInOverallScore": "INCLUDED_COMPLETELY",
            "problemStatement": "Upload any pdf file.",
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
                "startDate": "2022-10-01T00:00:00+02:00",
                "endDate": "2024-09-13T18:22:00+02:00",
                "testCourse": true,
                "onlineCourse": false,
                "courseInformationSharingConfiguration": "COMMUNICATION_AND_MESSAGING",
                "maxComplaints": 3,
                "maxTeamComplaints": 3,
                "maxComplaintTimeDays": 7,
                "maxRequestMoreFeedbackTimeDays": 7,
                "maxComplaintTextLimit": 2000,
                "maxComplaintResponseTextLimit": 2000,
                "enrollmentEnabled": true,
                "enrollmentConfirmationMessage": "Hi",
                "unenrollmentEnabled": false,
                "accuracyOfScores": 1,
                "learningPathsEnabled": false,
                "requestMoreFeedbackEnabled": true,
                "complaintsEnabled": true
            },
            "gradingCriteria": [
                {
                    "id": 25,
                    "structuredGradingInstructions": [
                        {
                            "id": 49,
                            "credits": -10.0,
                            "gradingScale": "Quality",
                            "instructionDescription": "The file quality is low and hard to read",
                            "feedback": "Please upload pdf with better quality",
                            "usageCount": 1
                        }
                    ]
                }
            ],
            "exampleSolution": "This is an example solution.",
            "filePattern": "pdf",
            "type": "file-upload",
            "exerciseType": "FILE_UPLOAD",
            "studentAssignedTeamIdComputed": false,
            "gradingInstructionFeedbackUsed": false,
            "teamMode": false,
            "visibleToStudents": true
        }
        """.utf8)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .customISO8601
        
        return try! decoder.decode(Exercise.self, from: exerciseData)
    }
    
    /// A mock text exercise
    static var mockText: Exercise {
        let randomId = Int.random(in: 1...9999)
        let exerciseData = Data("""
        {
            "type": "text",
            "id": \(randomId),
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
