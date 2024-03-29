//
//  SubmissionMockExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 24.05.23.
//
// swiftlint:disable all

import Foundation
import SharedModels

extension Submission {
    /// A mock modeling exercise submission
    static var mockModeling: Submission {
        let submissionData = Data("""
        {
            "submissionExerciseType": "modeling",
            "id": 36293,
            "submitted": true,
            "type": "MANUAL",
            "participation": {
                "type": "student",
                "id": 26851,
                "initializationState": "FINISHED",
                "initializationDate": "2023-06-30T15:22:23.353+02:00",
                "testRun": false,
                "exercise": {
                    "type": "modeling",
                    "id": 6707,
                    "title": "Spaceship UML",
                    "maxPoints": 98.0,
                    "bonusPoints": 0.0,
                    "assessmentType": "SEMI_AUTOMATIC",
                    "releaseDate": "2023-06-30T09:38:00+02:00",
                    "startDate": "2023-06-30T10:38:00+02:00",
                    "dueDate": "2023-07-03T15:25:00+02:00",
                    "assessmentDueDate": "2023-07-31T09:38:00+02:00",
                    "mode": "INDIVIDUAL",
                    "allowComplaintsForAutomaticAssessments": false,
                    "allowManualFeedbackRequests": false,
                    "includedInOverallScore": "INCLUDED_COMPLETELY",
                    "problemStatement": "Design a UML class diagram and sequence diagram for a space exploration system that manages spaceships and their missions. Consider the following",
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
                        "presentationScore": 0,
                        "accuracyOfScores": 1,
                        "requestMoreFeedbackEnabled": true,
                        "complaintsEnabled": true
                    },
                    "gradingCriteria": [
                        {
                            "id": 21,
                            "structuredGradingInstructions": [
                                {
                                    "id": 43,
                                    "credits": -5.0,
                                    "gradingScale": "Relations",
                                    "instructionDescription": "Incorrect relation type",
                                    "feedback": "You did not use the correct relation type here!",
                                    "usageCount": 0
                                }
                            ]
                        },
                        {
                            "id": 22,
                            "structuredGradingInstructions": [
                                {
                                    "id": 44,
                                    "credits": -1.0,
                                    "gradingScale": "Naming",
                                    "instructionDescription": "Bad naming",
                                    "feedback": "The element could be named in a better way",
                                    "usageCount": 0
                                }
                            ]
                        }
                    ],
                    "diagramType": "ClassDiagram",
                    "exampleSolutionModel":"{\\"version\\":\\"2.0.0\\",\\"type\\":\\"ClassDiagram\\",\\"size\\":{\\"width\\":900,\\"height\\":560},\\"interactive\\":{\\"elements\\":[],\\"relationships\\":[]},\\"elements\\":[{\\"id\\":\\"65897e59-4e21-4282-bc2c-38cbc581f710\\",\\"name\\":\\"Package\\",\\"type\\":\\"Package\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":0,\\"y\\":0,\\"width\\":590,\\"height\\":510}},{\\"id\\":\\"5e257a57-fda4-417c-ae45-7ee839d35947\\",\\"name\\":\\"Class A\\",\\"type\\":\\"Class\\",\\"owner\\":\\"65897e59-4e21-4282-bc2c-38cbc581f710\\",\\"bounds\\":{\\"x\\":30,\\"y\\":250,\\"width\\":160,\\"height\\":90},\\"attributes\\":[\\"edb6fd04-c120-48fc-851b-610cdfd5ffa4\\"],\\"methods\\":[\\"eb35f61b-4c8a-406f-9b40-2b47fd53b451\\"]},{\\"id\\":\\"edb6fd04-c120-48fc-851b-610cdfd5ffa4\\",\\"name\\":\\"+ attribute: Type\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"5e257a57-fda4-417c-ae45-7ee839d35947\\",\\"bounds\\":{\\"x\\":30.5,\\"y\\":280.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"eb35f61b-4c8a-406f-9b40-2b47fd53b451\\",\\"name\\":\\"+ method()\\",\\"type\\":\\"ClassMethod\\",\\"owner\\":\\"5e257a57-fda4-417c-ae45-7ee839d35947\\",\\"bounds\\":{\\"x\\":30.5,\\"y\\":310.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"cfccf9cd-cf98-44bb-a9a0-f0128a0127dd\\",\\"name\\":\\"Interface\\",\\"type\\":\\"Interface\\",\\"owner\\":\\"65897e59-4e21-4282-bc2c-38cbc581f710\\",\\"bounds\\":{\\"x\\":210,\\"y\\":60,\\"width\\":160,\\"height\\":100},\\"attributes\\":[\\"db5c509d-8091-484c-853b-95db2ccf13d0\\"],\\"methods\\":[\\"8bebc3e5-bdc8-429e-ab59-c0e2757caa65\\"]},{\\"id\\":\\"db5c509d-8091-484c-853b-95db2ccf13d0\\",\\"name\\":\\"+ attribute: Type\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"cfccf9cd-cf98-44bb-a9a0-f0128a0127dd\\",\\"bounds\\":{\\"x\\":210.5,\\"y\\":100.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"8bebc3e5-bdc8-429e-ab59-c0e2757caa65\\",\\"name\\":\\"+ method()\\",\\"type\\":\\"ClassMethod\\",\\"owner\\":\\"cfccf9cd-cf98-44bb-a9a0-f0128a0127dd\\",\\"bounds\\":{\\"x\\":210.5,\\"y\\":130.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"29f0c84a-95f0-46c6-8f15-9f9cdbf20bd0\\",\\"name\\":\\"Class\\",\\"type\\":\\"Class\\",\\"owner\\":\\"65897e59-4e21-4282-bc2c-38cbc581f710\\",\\"bounds\\":{\\"x\\":30,\\"y\\":390,\\"width\\":160,\\"height\\":90},\\"attributes\\":[\\"7bad3ed1-66c2-43cc-9c67-0be62d60af72\\"],\\"methods\\":[\\"a7b1e144-0a73-4a8e-99ff-1f2d5509b8a2\\"]},{\\"id\\":\\"7bad3ed1-66c2-43cc-9c67-0be62d60af72\\",\\"name\\":\\"+ attribute: Type\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"29f0c84a-95f0-46c6-8f15-9f9cdbf20bd0\\",\\"bounds\\":{\\"x\\":30.5,\\"y\\":420.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"a7b1e144-0a73-4a8e-99ff-1f2d5509b8a2\\",\\"name\\":\\"+ method()\\",\\"type\\":\\"ClassMethod\\",\\"owner\\":\\"29f0c84a-95f0-46c6-8f15-9f9cdbf20bd0\\",\\"bounds\\":{\\"x\\":30.5,\\"y\\":450.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"6bd05bb3-ba79-4ddd-8f5c-31b4543733d7\\",\\"name\\":\\"Class\\",\\"type\\":\\"Class\\",\\"owner\\":\\"65897e59-4e21-4282-bc2c-38cbc581f710\\",\\"bounds\\":{\\"x\\":400,\\"y\\":260,\\"width\\":160,\\"height\\":90},\\"attributes\\":[\\"50b082d4-6bb7-4fd4-bdfc-2732c813bb46\\"],\\"methods\\":[\\"18243fb5-7319-446a-ab9a-1292c579b384\\"]},{\\"id\\":\\"50b082d4-6bb7-4fd4-bdfc-2732c813bb46\\",\\"name\\":\\"+ attribute: Type\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"6bd05bb3-ba79-4ddd-8f5c-31b4543733d7\\",\\"bounds\\":{\\"x\\":400.5,\\"y\\":290.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"18243fb5-7319-446a-ab9a-1292c579b384\\",\\"name\\":\\"+ method()\\",\\"type\\":\\"ClassMethod\\",\\"owner\\":\\"6bd05bb3-ba79-4ddd-8f5c-31b4543733d7\\",\\"bounds\\":{\\"x\\":400.5,\\"y\\":320.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"c6f1e55a-dcb1-4bab-84a5-8e86ba5afe2d\\",\\"name\\":\\"Abstract\\",\\"type\\":\\"AbstractClass\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":690,\\"y\\":90,\\"width\\":160,\\"height\\":100},\\"attributes\\":[\\"9f505ec6-0266-4b4d-9374-90608aca4b7c\\"],\\"methods\\":[\\"d6317ba1-4566-44a2-8671-47e204b8c375\\"]},{\\"id\\":\\"9f505ec6-0266-4b4d-9374-90608aca4b7c\\",\\"name\\":\\"+ attribute: Type\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"c6f1e55a-dcb1-4bab-84a5-8e86ba5afe2d\\",\\"bounds\\":{\\"x\\":690.5,\\"y\\":130.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"d6317ba1-4566-44a2-8671-47e204b8c375\\",\\"name\\":\\"+ method()\\",\\"type\\":\\"ClassMethod\\",\\"owner\\":\\"c6f1e55a-dcb1-4bab-84a5-8e86ba5afe2d\\",\\"bounds\\":{\\"x\\":690.5,\\"y\\":160.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"3c777fd6-2b31-4c23-b721-0046f9940c43\\",\\"name\\":\\"Enumeration\\",\\"type\\":\\"Enumeration\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":690,\\"y\\":270,\\"width\\":160,\\"height\\":130},\\"attributes\\":[\\"0fb931ee-1471-4b35-b5d1-69afebbe448f\\",\\"b7964bc2-732c-4874-b11d-74a3879f45f8\\",\\"b8660180-9651-4bbe-8c8e-7d8e251f50da\\"],\\"methods\\":[]},{\\"id\\":\\"0fb931ee-1471-4b35-b5d1-69afebbe448f\\",\\"name\\":\\"Case 1\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"3c777fd6-2b31-4c23-b721-0046f9940c43\\",\\"bounds\\":{\\"x\\":690.5,\\"y\\":310.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"b7964bc2-732c-4874-b11d-74a3879f45f8\\",\\"name\\":\\"Case 2\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"3c777fd6-2b31-4c23-b721-0046f9940c43\\",\\"bounds\\":{\\"x\\":690.5,\\"y\\":340.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"b8660180-9651-4bbe-8c8e-7d8e251f50da\\",\\"name\\":\\"Case 3\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"3c777fd6-2b31-4c23-b721-0046f9940c43\\",\\"bounds\\":{\\"x\\":690.5,\\"y\\":370.5,\\"width\\":159,\\"height\\":30}}],\\"relationships\\":[{\\"id\\":\\"6df1b5b4-5a3d-4e28-b10e-ffe1be44a5e3\\",\\"name\\":\\"\\",\\"type\\":\\"ClassRealization\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":105,\\"y\\":160,\\"width\\":190,\\"height\\":90},\\"path\\":[{\\"x\\":5,\\"y\\":90},{\\"x\\":5,\\"y\\":45},{\\"x\\":185,\\"y\\":45},{\\"x\\":185,\\"y\\":0}],\\"source\\":{\\"direction\\":\\"Up\\",\\"element\\":\\"5e257a57-fda4-417c-ae45-7ee839d35947\\",\\"multiplicity\\":\\"\\",\\"role\\":\\"\\"},\\"target\\":{\\"direction\\":\\"Down\\",\\"element\\":\\"cfccf9cd-cf98-44bb-a9a0-f0128a0127dd\\",\\"multiplicity\\":\\"\\",\\"role\\":\\"\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"25463711-1cd7-4334-aa37-aaf258077b65\\",\\"name\\":\\"\\",\\"type\\":\\"ClassRealization\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":285,\\"y\\":160,\\"width\\":200,\\"height\\":100},\\"path\\":[{\\"x\\":195,\\"y\\":100},{\\"x\\":195,\\"y\\":50},{\\"x\\":5,\\"y\\":50},{\\"x\\":5,\\"y\\":0}],\\"source\\":{\\"direction\\":\\"Up\\",\\"element\\":\\"6bd05bb3-ba79-4ddd-8f5c-31b4543733d7\\",\\"multiplicity\\":\\"\\",\\"role\\":\\"\\"},\\"target\\":{\\"direction\\":\\"Down\\",\\"element\\":\\"cfccf9cd-cf98-44bb-a9a0-f0128a0127dd\\",\\"multiplicity\\":\\"\\",\\"role\\":\\"\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"d0961df3-dd2d-4dca-8af3-a5e4ff6145dd\\",\\"name\\":\\"\\",\\"type\\":\\"ClassInheritance\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":105,\\"y\\":340,\\"width\\":10,\\"height\\":50},\\"path\\":[{\\"x\\":5,\\"y\\":50},{\\"x\\":5,\\"y\\":0}],\\"source\\":{\\"direction\\":\\"Up\\",\\"element\\":\\"29f0c84a-95f0-46c6-8f15-9f9cdbf20bd0\\",\\"multiplicity\\":\\"\\",\\"role\\":\\"\\"},\\"target\\":{\\"direction\\":\\"Down\\",\\"element\\":\\"5e257a57-fda4-417c-ae45-7ee839d35947\\",\\"multiplicity\\":\\"\\",\\"role\\":\\"\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"8ee577b8-6249-42ab-95df-c9b4b5a88fe1\\",\\"name\\":\\"\\",\\"type\\":\\"ClassBidirectional\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":560,\\"y\\":300,\\"width\\":130,\\"height\\":31},\\"path\\":[{\\"x\\":0,\\"y\\":10},{\\"x\\":130,\\"y\\":10}],\\"source\\":{\\"direction\\":\\"Right\\",\\"element\\":\\"6bd05bb3-ba79-4ddd-8f5c-31b4543733d7\\",\\"multiplicity\\":\\"\\",\\"role\\":\\"\\"},\\"target\\":{\\"direction\\":\\"Left\\",\\"element\\":\\"3c777fd6-2b31-4c23-b721-0046f9940c43\\",\\"multiplicity\\":\\"\\",\\"role\\":\\"\\"},\\"isManuallyLayouted\\":false}],\\"assessments\\":[]}",
                    "exampleSolutionExplanation": "Some solution here",
                    "type": "modeling",
                    "exerciseType": "MODELING",
                    "studentAssignedTeamIdComputed": false,
                    "gradingInstructionFeedbackUsed": false,
                    "exampleSolutionPublished": false,
                    "teamMode": false,
                    "visibleToStudents": true,
                    "sanitizedExerciseTitle": "Spaceship_UML"
                }
            },
            "submissionDate": "2023-06-30T15:22:57.952+02:00",
            "model": "{\\"version\\":\\"2.0.0\\",\\"type\\":\\"UseCaseDiagram\\",\\"size\\":{\\"width\\":620,\\"height\\":640},\\"interactive\\":{\\"elements\\":[],\\"relationships\\":[]},\\"elements\\":[{\\"id\\":\\"c0a92690-35ca-4ce8-ba57-5203dbe0c70f\\",\\"name\\":\\"System\\",\\"type\\":\\"UseCaseSystem\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":100,\\"y\\":0,\\"width\\":390,\\"height\\":440}},{\\"id\\":\\"3fa1779c-0f51-4a83-97f7-a92157a50921\\",\\"name\\":\\"UseCase A\\",\\"type\\":\\"UseCase\\",\\"owner\\":\\"c0a92690-35ca-4ce8-ba57-5203dbe0c70f\\",\\"bounds\\":{\\"x\\":130,\\"y\\":50,\\"width\\":160,\\"height\\":80}},{\\"id\\":\\"39a4c96d-e545-45a2-9e49-71283ba6d1a3\\",\\"name\\":\\"UseCase B\\",\\"type\\":\\"UseCase\\",\\"owner\\":\\"c0a92690-35ca-4ce8-ba57-5203dbe0c70f\\",\\"bounds\\":{\\"x\\":110,\\"y\\":210,\\"width\\":160,\\"height\\":80}},{\\"id\\":\\"a6df7306-d58b-43ff-9940-007f2e78c530\\",\\"name\\":\\"UseCase C\\",\\"type\\":\\"UseCase\\",\\"owner\\":\\"c0a92690-35ca-4ce8-ba57-5203dbe0c70f\\",\\"bounds\\":{\\"x\\":300,\\"y\\":290,\\"width\\":160,\\"height\\":80}},{\\"id\\":\\"19b0ceb9-48e6-4e7f-98fa-f81a2a153dd2\\",\\"name\\":\\"Actor B\\",\\"type\\":\\"UseCaseActor\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":510,\\"y\\":40,\\"width\\":60,\\"height\\":110}},{\\"id\\":\\"8feefd21-bddf-4020-8d0c-f43fb27a1517\\",\\"name\\":\\"Actor A\\",\\"type\\":\\"UseCaseActor\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":0,\\"y\\":30,\\"width\\":60,\\"height\\":110}}],\\"relationships\\":[{\\"id\\":\\"605a51d8-daa0-4c41-87f8-6910f4849f7f\\",\\"name\\":\\"asdasd\\",\\"type\\":\\"UseCaseAssociation\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":460,\\"y\\":95,\\"width\\":50,\\"height\\":215},\\"path\\":[{\\"x\\":50,\\"y\\":0},{\\"x\\":0,\\"y\\":215}],\\"source\\":{\\"direction\\":\\"Left\\",\\"element\\":\\"19b0ceb9-48e6-4e7f-98fa-f81a2a153dd2\\"},\\"target\\":{\\"direction\\":\\"Upright\\",\\"element\\":\\"a6df7306-d58b-43ff-9940-007f2e78c530\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"bdb31b64-74d4-4408-8bc2-b3f10106ef49\\",\\"name\\":\\"asdasdas\\",\\"type\\":\\"UseCaseAssociation\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":270,\\"y\\":95,\\"width\\":240,\\"height\\":135},\\"path\\":[{\\"x\\":240,\\"y\\":0},{\\"x\\":0,\\"y\\":135}],\\"source\\":{\\"direction\\":\\"Left\\",\\"element\\":\\"19b0ceb9-48e6-4e7f-98fa-f81a2a153dd2\\"},\\"target\\":{\\"direction\\":\\"Upright\\",\\"element\\":\\"39a4c96d-e545-45a2-9e49-71283ba6d1a3\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"b92f445e-7555-4559-bee4-012445b09f6f\\",\\"name\\":\\"asdasd\\",\\"type\\":\\"UseCaseAssociation\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":60,\\"y\\":85,\\"width\\":70,\\"height\\":5},\\"path\\":[{\\"x\\":0,\\"y\\":0},{\\"x\\":70,\\"y\\":5}],\\"source\\":{\\"direction\\":\\"Right\\",\\"element\\":\\"8feefd21-bddf-4020-8d0c-f43fb27a1517\\"},\\"target\\":{\\"direction\\":\\"Left\\",\\"element\\":\\"3fa1779c-0f51-4a83-97f7-a92157a50921\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"36becc5c-5411-446c-9260-5c411e64c51e\\",\\"name\\":\\"\\",\\"type\\":\\"UseCaseInclude\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":210,\\"y\\":130,\\"width\\":170,\\"height\\":160},\\"path\\":[{\\"x\\":170,\\"y\\":160},{\\"x\\":0,\\"y\\":0}],\\"source\\":{\\"direction\\":\\"Up\\",\\"element\\":\\"a6df7306-d58b-43ff-9940-007f2e78c530\\"},\\"target\\":{\\"direction\\":\\"Down\\",\\"element\\":\\"3fa1779c-0f51-4a83-97f7-a92157a50921\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"e6081572-5871-4796-a7cc-283e6bdbb13a\\",\\"name\\":\\"\\",\\"type\\":\\"UseCaseExtend\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":190,\\"y\\":290,\\"width\\":110,\\"height\\":20},\\"path\\":[{\\"x\\":0,\\"y\\":0},{\\"x\\":110,\\"y\\":20}],\\"source\\":{\\"direction\\":\\"Down\\",\\"element\\":\\"39a4c96d-e545-45a2-9e49-71283ba6d1a3\\"},\\"target\\":{\\"direction\\":\\"Upleft\\",\\"element\\":\\"a6df7306-d58b-43ff-9940-007f2e78c530\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"a21319b7-b97d-4da2-b086-71d332d2932a\\",\\"name\\":\\"text\\",\\"type\\":\\"UseCaseAssociation\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":290,\\"y\\":90,\\"width\\":220,\\"height\\":5},\\"path\\":[{\\"x\\":220,\\"y\\":5},{\\"x\\":0,\\"y\\":0}],\\"source\\":{\\"direction\\":\\"Left\\",\\"element\\":\\"19b0ceb9-48e6-4e7f-98fa-f81a2a153dd2\\"},\\"target\\":{\\"direction\\":\\"Right\\",\\"element\\":\\"3fa1779c-0f51-4a83-97f7-a92157a50921\\"},\\"isManuallyLayouted\\":false}],\\"assessments\\":[]}",
            "empty": false,
            "similarElements": [
                {
                    "elementId": null,
                    "numberOfOtherElements": 0
                }
            ],
            "submissionExerciseType": "modeling",
            "durationInMinutes": 0,
            "results": [
                {
                    "id": 35693,
                    "assessor": {
                        "id": 13,
                        "createdDate": "2021-05-03T10:40:06Z",
                        "login": "artemis_test_user_7",
                        "firstName": "ArTEMiS",
                        "lastName": "Test User 7",
                        "email": "krusche+testuser_7@in.tum.de",
                        "activated": true,
                        "langKey": "en",
                        "lastNotificationRead": "2023-05-31T11:03:54.26+02:00",
                        "name": "ArTEMiS Test User 7",
                        "internal": false,
                        "participantIdentifier": "artemis_test_user_7",
                        "deleted": false
                    },
                    "assessmentType": "MANUAL",
                    "testCaseCount": 0,
                    "passedTestCaseCount": 0,
                    "codeIssueCount": 0
                }
            ]
        }
        """.utf8)
    
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .customISO8601

        return try! decoder.decode(Submission.self, from: submissionData)
    }
    
    /// A mock text exercise submission
    static var mockText: Submission {
        let randomId = Int.random(in: 1...9999)
        let submissionData = Data("""
        {
            "submissionExerciseType": "text",
            "id": \(randomId),
            "submitted": true,
            "type": "MANUAL",
            "submissionDate": "2023-07-30T16:29:00+02:00",
            "participation": {
                "type": "student",
                "id": 25776,
                "initializationState": "FINISHED",
                "testRun": false,
                "exercise": {
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
                    "problemStatement": "Write an essay titled",
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
                    "exampleSolution": "My dream spaceship would be a sleek and innovative vessel built for exploration and discovery. It would be powered by a fusion engine, enabling faster-than-light travel and efficient use of resources. The ship would be able to accommodate a crew of up to 10 people and would have state-of-the-art living quarters and amenities, including artificial gravity and a hydroponic garden for sustainable food production. The ship would be equipped with advanced scientific instruments and a powerful telescope for observing distant galaxies. I dream of using this spaceship to explore the vast unknowns of the universe and make groundbreaking discoveries that will change our understanding of the cosmos",
                    "type": "text",
                    "automaticAssessmentEnabled": true,
                    "exerciseType": "TEXT",
                    "studentAssignedTeamIdComputed": false,
                    "gradingInstructionFeedbackUsed": false,
                    "exampleSolutionPublished": true,
                    "teamMode": false,
                    "visibleToStudents": true
                },
                "student": {
                    "id": 7,
                    "login": "artemis_test_user_2",
                    "firstName": "ArTEMiS",
                    "lastName": "Test User 2",
                    "email": "krusche+testuser_2@in.tum.de",
                    "activated": true,
                    "langKey": "en",
                    "name": "ArTEMiS Test User 2",
                    "internal": false,
                    "participantIdentifier": "artemis_test_user_2"
                },
                "participantIdentifier": "artemis_test_user_2",
                "participantName": "ArTEMiS Test User 2"
            },
            "text": "My dream spaceship is a marvel of engineering, powered by a fusion reactor and equipped with the latest technology for exploration. Its sleek design and state-of-the-art features make it the ultimate vessel for venturing into the unknown depths of space, where no one has gone before.",
            "language": "ENGLISH",
            "empty": false,
            "submissionExerciseType": "text",
            "durationInMinutes": 0
        }
        """.utf8)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try! decoder.decode(Submission.self, from: submissionData)
    }
}
