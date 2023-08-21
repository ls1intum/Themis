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
            "model": "{\\"version\\":\\"2.0.0\\",\\"type\\":\\"ClassDiagram\\",\\"size\\":{\\"width\\":800,\\"height\\":640},\\"interactive\\":{\\"elements\\":[],\\"relationships\\":[]},\\"elements\\":[{\\"id\\":\\"4e396dad-876e-49dc-8942-701b9d72c4d1\\",\\"name\\":\\"Package A\\",\\"type\\":\\"Package\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":0,\\"y\\":0,\\"width\\":510,\\"height\\":370}},{\\"id\\":\\"b1a7ca0c-cbee-4c54-93dd-7c19bcbbbd0b\\",\\"name\\":\\"Class A\\",\\"type\\":\\"Class\\",\\"owner\\":\\"4e396dad-876e-49dc-8942-701b9d72c4d1\\",\\"bounds\\":{\\"x\\":40,\\"y\\":240,\\"width\\":160,\\"height\\":90},\\"attributes\\":[\\"03f693a6-ef0d-464f-b206-297ac8b470c8\\"],\\"methods\\":[\\"f4445082-0989-4247-80e5-fdaf21c3c29a\\"]},{\\"id\\":\\"03f693a6-ef0d-464f-b206-297ac8b470c8\\",\\"name\\":\\"+ attribute: Type\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"b1a7ca0c-cbee-4c54-93dd-7c19bcbbbd0b\\",\\"bounds\\":{\\"x\\":40.5,\\"y\\":270.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"f4445082-0989-4247-80e5-fdaf21c3c29a\\",\\"name\\":\\"+ method()\\",\\"type\\":\\"ClassMethod\\",\\"owner\\":\\"b1a7ca0c-cbee-4c54-93dd-7c19bcbbbd0b\\",\\"bounds\\":{\\"x\\":40.5,\\"y\\":300.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"120ddaa1-32eb-4259-ba2b-3051ede02f93\\",\\"name\\":\\"Abstract\\",\\"type\\":\\"AbstractClass\\",\\"owner\\":\\"4e396dad-876e-49dc-8942-701b9d72c4d1\\",\\"bounds\\":{\\"x\\":160,\\"y\\":40,\\"width\\":160,\\"height\\":100},\\"attributes\\":[\\"70aa3de1-8ad7-4524-8548-e388d948d55d\\"],\\"methods\\":[\\"3756d9ba-65e2-4cc3-bb33-956818a54c7d\\"]},{\\"id\\":\\"70aa3de1-8ad7-4524-8548-e388d948d55d\\",\\"name\\":\\"+ attribute: Type\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"120ddaa1-32eb-4259-ba2b-3051ede02f93\\",\\"bounds\\":{\\"x\\":160.5,\\"y\\":80.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"3756d9ba-65e2-4cc3-bb33-956818a54c7d\\",\\"name\\":\\"+ method()\\",\\"type\\":\\"ClassMethod\\",\\"owner\\":\\"120ddaa1-32eb-4259-ba2b-3051ede02f93\\",\\"bounds\\":{\\"x\\":160.5,\\"y\\":110.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"080a7e3c-393f-42e6-9c52-07953ade700f\\",\\"name\\":\\"Class B\\",\\"type\\":\\"Class\\",\\"owner\\":\\"4e396dad-876e-49dc-8942-701b9d72c4d1\\",\\"bounds\\":{\\"x\\":300,\\"y\\":200,\\"width\\":180,\\"height\\":90},\\"attributes\\":[\\"fbe6859a-467d-4c4d-a87a-3793888c25a5\\"],\\"methods\\":[\\"6fd18626-b829-4763-af92-82c2e15502e6\\"]},{\\"id\\":\\"fbe6859a-467d-4c4d-a87a-3793888c25a5\\",\\"name\\":\\"+ attribute: Type\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"080a7e3c-393f-42e6-9c52-07953ade700f\\",\\"bounds\\":{\\"x\\":300.5,\\"y\\":230.5,\\"width\\":179,\\"height\\":30}},{\\"id\\":\\"6fd18626-b829-4763-af92-82c2e15502e6\\",\\"name\\":\\"+ someLongMethodName()\\",\\"type\\":\\"ClassMethod\\",\\"owner\\":\\"080a7e3c-393f-42e6-9c52-07953ade700f\\",\\"bounds\\":{\\"x\\":300.5,\\"y\\":260.5,\\"width\\":179,\\"height\\":30}},{\\"id\\":\\"4204afae-97c8-4578-9fa8-df8102da102d\\",\\"name\\":\\"Package B\\",\\"type\\":\\"Package\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":0,\\"y\\":410,\\"width\\":420,\\"height\\":180}},{\\"id\\":\\"75976308-0f4a-4060-8ecc-01aba55de686\\",\\"name\\":\\"Interface\\",\\"type\\":\\"Interface\\",\\"owner\\":\\"4204afae-97c8-4578-9fa8-df8102da102d\\",\\"bounds\\":{\\"x\\":20,\\"y\\":460,\\"width\\":160,\\"height\\":100},\\"attributes\\":[\\"1634477b-7bfa-46d8-92fb-c68ccc2ea167\\"],\\"methods\\":[\\"33c1715f-f452-46c7-a019-ca03d43ddffa\\"]},{\\"id\\":\\"1634477b-7bfa-46d8-92fb-c68ccc2ea167\\",\\"name\\":\\"+ attribute: Type\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"75976308-0f4a-4060-8ecc-01aba55de686\\",\\"bounds\\":{\\"x\\":20.5,\\"y\\":500.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"33c1715f-f452-46c7-a019-ca03d43ddffa\\",\\"name\\":\\"+ method()\\",\\"type\\":\\"ClassMethod\\",\\"owner\\":\\"75976308-0f4a-4060-8ecc-01aba55de686\\",\\"bounds\\":{\\"x\\":20.5,\\"y\\":530.5,\\"width\\":159,\\"height\\":30}},{\\"id\\":\\"21c0b51f-ec18-4eee-860b-1c2ed7778a80\\",\\"name\\":\\"Enumeration\\",\\"type\\":\\"Enumeration\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":580,\\"y\\":70,\\"width\\":180,\\"height\\":160},\\"attributes\\":[\\"dfa5b703-14c1-48f1-88f2-1769695701a1\\",\\"8d168f89-5a4f-43d5-8ffb-f8f532441464\\",\\"340ce0ee-8636-4a80-8d42-95aadbd67bc2\\",\\"c40077bb-17ad-4983-9c42-a302be94d806\\"],\\"methods\\":[]},{\\"id\\":\\"dfa5b703-14c1-48f1-88f2-1769695701a1\\",\\"name\\":\\"Case 1\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"21c0b51f-ec18-4eee-860b-1c2ed7778a80\\",\\"bounds\\":{\\"x\\":580.5,\\"y\\":110.5,\\"width\\":179,\\"height\\":30}},{\\"id\\":\\"8d168f89-5a4f-43d5-8ffb-f8f532441464\\",\\"name\\":\\"Case 2\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"21c0b51f-ec18-4eee-860b-1c2ed7778a80\\",\\"bounds\\":{\\"x\\":580.5,\\"y\\":140.5,\\"width\\":179,\\"height\\":30}},{\\"id\\":\\"340ce0ee-8636-4a80-8d42-95aadbd67bc2\\",\\"name\\":\\"Case 3\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"21c0b51f-ec18-4eee-860b-1c2ed7778a80\\",\\"bounds\\":{\\"x\\":580.5,\\"y\\":170.5,\\"width\\":179,\\"height\\":30}},{\\"id\\":\\"c40077bb-17ad-4983-9c42-a302be94d806\\",\\"name\\":\\"Some Very Long Case Name\\",\\"type\\":\\"ClassAttribute\\",\\"owner\\":\\"21c0b51f-ec18-4eee-860b-1c2ed7778a80\\",\\"bounds\\":{\\"x\\":580.5,\\"y\\":200.5,\\"width\\":179,\\"height\\":30}}],\\"relationships\\":[{\\"id\\":\\"f15904a4-dd83-4afc-9dbd-ee450e34eb32\\",\\"name\\":\\"\\",\\"type\\":\\"ClassComposition\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":126.8828125,\\"y\\":140,\\"width\\":62.625,\\"height\\":106.5},\\"path\\":[{\\"x\\":53.1171875,\\"y\\":100},{\\"x\\":53.1171875,\\"y\\":0}],\\"source\\":{\\"direction\\":\\"Up\\",\\"element\\":\\"b1a7ca0c-cbee-4c54-93dd-7c19bcbbbd0b\\",\\"multiplicity\\":\\"*\\",\\"role\\":\\"RoleA\\"},\\"target\\":{\\"direction\\":\\"Bottomleft\\",\\"element\\":\\"120ddaa1-32eb-4259-ba2b-3051ede02f93\\",\\"multiplicity\\":\\"*\\",\\"role\\":\\"RoleAbs\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"e1c61de9-cf0e-4ed3-a2c8-db5a10c46555\\",\\"name\\":\\"\\",\\"type\\":\\"ClassDependency\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":186.8828125,\\"y\\":140,\\"width\\":215.234375,\\"height\\":66.5},\\"path\\":[{\\"x\\":203.1171875,\\"y\\":60},{\\"x\\":203.1171875,\\"y\\":20},{\\"x\\":53.1171875,\\"y\\":40},{\\"x\\":53.1171875,\\"y\\":0}],\\"source\\":{\\"direction\\":\\"Up\\",\\"element\\":\\"080a7e3c-393f-42e6-9c52-07953ade700f\\",\\"multiplicity\\":\\"1\\",\\"role\\":\\"RoleB\\"},\\"target\\":{\\"direction\\":\\"Down\\",\\"element\\":\\"120ddaa1-32eb-4259-ba2b-3051ede02f93\\",\\"multiplicity\\":\\"*\\",\\"role\\":\\"RoleAbs\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"a5a20b97-6d0f-4b07-a581-10bd3e610ee5\\",\\"name\\":\\"\\",\\"type\\":\\"ClassAggregation\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":200,\\"y\\":255,\\"width\\":100,\\"height\\":45.5},\\"path\\":[{\\"x\\":100,\\"y\\":10},{\\"x\\":0,\\"y\\":10}],\\"source\\":{\\"direction\\":\\"Left\\",\\"element\\":\\"080a7e3c-393f-42e6-9c52-07953ade700f\\",\\"multiplicity\\":\\"1\\",\\"role\\":\\"RoleB\\"},\\"target\\":{\\"direction\\":\\"Right\\",\\"element\\":\\"b1a7ca0c-cbee-4c54-93dd-7c19bcbbbd0b\\",\\"multiplicity\\":\\"1\\",\\"role\\":\\"RoleA\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"58311460-5395-4c7d-854f-8607937c46ec\\",\\"name\\":\\"\\",\\"type\\":\\"ClassInheritance\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":64.703125,\\"y\\":330,\\"width\\":57.4140625,\\"height\\":130},\\"path\\":[{\\"x\\":45.296875,\\"y\\":0},{\\"x\\":45.296875,\\"y\\":130}],\\"source\\":{\\"direction\\":\\"Down\\",\\"element\\":\\"b1a7ca0c-cbee-4c54-93dd-7c19bcbbbd0b\\",\\"multiplicity\\":\\"*\\",\\"role\\":\\"RoleA\\"},\\"target\\":{\\"direction\\":\\"Up\\",\\"element\\":\\"75976308-0f4a-4060-8ecc-01aba55de686\\",\\"multiplicity\\":\\"1\\",\\"role\\":\\"RoleInt\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"dafb24a4-b073-4680-87f1-cb3f0b478169\\",\\"name\\":\\"\\",\\"type\\":\\"ClassRealization\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":180,\\"y\\":290,\\"width\\":219.5078125,\\"height\\":255.5},\\"path\\":[{\\"x\\":210,\\"y\\":0},{\\"x\\":210,\\"y\\":220},{\\"x\\":0,\\"y\\":220}],\\"source\\":{\\"direction\\":\\"Down\\",\\"element\\":\\"080a7e3c-393f-42e6-9c52-07953ade700f\\",\\"multiplicity\\":\\"*\\",\\"role\\":\\"RoleB\\"},\\"target\\":{\\"direction\\":\\"Right\\",\\"element\\":\\"75976308-0f4a-4060-8ecc-01aba55de686\\",\\"multiplicity\\":\\"1\\",\\"role\\":\\"RoleInt\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"c2709004-524c-4ae2-8f64-b95eecef610b\\",\\"name\\":\\"\\",\\"type\\":\\"ClassUnidirectional\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":665,\\"y\\":30,\\"width\\":55,\\"height\\":40},\\"path\\":[{\\"x\\":50,\\"y\\":40},{\\"x\\":50,\\"y\\":0},{\\"x\\":5,\\"y\\":0},{\\"x\\":5,\\"y\\":40}],\\"source\\":{\\"direction\\":\\"Topright\\",\\"element\\":\\"21c0b51f-ec18-4eee-860b-1c2ed7778a80\\",\\"multiplicity\\":\\"\\",\\"role\\":\\"\\"},\\"target\\":{\\"direction\\":\\"Up\\",\\"element\\":\\"21c0b51f-ec18-4eee-860b-1c2ed7778a80\\",\\"multiplicity\\":\\"\\",\\"role\\":\\"\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"5998f312-1283-4264-916a-971a33b53eb2\\",\\"name\\":\\"\\",\\"type\\":\\"ClassBidirectional\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":480,\\"y\\":140,\\"width\\":100,\\"height\\":140.5},\\"path\\":[{\\"x\\":0,\\"y\\":105},{\\"x\\":50,\\"y\\":105},{\\"x\\":50,\\"y\\":10},{\\"x\\":100,\\"y\\":10}],\\"source\\":{\\"direction\\":\\"Right\\",\\"element\\":\\"080a7e3c-393f-42e6-9c52-07953ade700f\\",\\"multiplicity\\":\\"1\\",\\"role\\":\\"RoleB\\"},\\"target\\":{\\"direction\\":\\"Left\\",\\"element\\":\\"21c0b51f-ec18-4eee-860b-1c2ed7778a80\\",\\"multiplicity\\":\\"1\\",\\"role\\":\\"RoleEn\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"d4287d90-edb2-4791-96b8-b2fe497a6ce8\\",\\"name\\":\\"\\",\\"type\\":\\"ClassComposition\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":80.77280807495117,\\"y\\":80,\\"width\\":79.22719192504883,\\"height\\":160},\\"path\\":[{\\"x\\":79.22719192504883,\\"y\\":10},{\\"x\\":39.22719192504883,\\"y\\":10},{\\"x\\":39.22719192504883,\\"y\\":160}],\\"source\\":{\\"direction\\":\\"Left\\",\\"element\\":\\"120ddaa1-32eb-4259-ba2b-3051ede02f93\\",\\"multiplicity\\":\\"*\\",\\"role\\":\\"RoleAbs\\"},\\"target\\":{\\"direction\\":\\"Up\\",\\"element\\":\\"b1a7ca0c-cbee-4c54-93dd-7c19bcbbbd0b\\",\\"multiplicity\\":\\"*\\",\\"role\\":\\"RoleA\\"},\\"isManuallyLayouted\\":false},{\\"id\\":\\"cc300af5-3911-4f4d-b2b1-f24b4bc6e583\\",\\"name\\":\\"\\",\\"type\\":\\"ClassAggregation\\",\\"owner\\":null,\\"bounds\\":{\\"x\\":320,\\"y\\":95,\\"width\\":260,\\"height\\":45.5},\\"path\\":[{\\"x\\":0,\\"y\\":10},{\\"x\\":260,\\"y\\":10}],\\"source\\":{\\"direction\\":\\"Right\\",\\"element\\":\\"120ddaa1-32eb-4259-ba2b-3051ede02f93\\",\\"multiplicity\\":\\"1\\",\\"role\\":\\"RoleAbs\\"},\\"target\\":{\\"direction\\":\\"Upleft\\",\\"element\\":\\"21c0b51f-ec18-4eee-860b-1c2ed7778a80\\",\\"multiplicity\\":\\"1\\",\\"role\\":\\"RoleEn\\"},\\"isManuallyLayouted\\":false}],\\"assessments\\":[]}",
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
        let submissionData = Data("""
        {
            "submissionExerciseType": "text",
            "id": 34463,
            "submitted": true,
            "type": "MANUAL",
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
        
        return try! JSONDecoder().decode(Submission.self, from: submissionData)
    }
}
