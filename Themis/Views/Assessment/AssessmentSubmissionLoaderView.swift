//
//  AssessmentSubmissionLoaderView.swift
//  Themis
//
//  Created by Tom Rudnick on 29.11.22.
//

import SwiftUI

struct AssessmentSubmissionLoaderView: View {
    @StateObject var vm = AssessmentViewModel(readOnly: false)
    @StateObject var cvm = CodeEditorViewModel()
    @StateObject var umlVM = UMLViewModel()

    var exerciseID: Int
    var submissionID: Int
    let exerciseTitle: String
    let templateParticipationId: Int

    var body: some View {
        AssessmentView(exerciseId: exerciseID, exerciseTitle: exerciseTitle, templateParticipationId: templateParticipationId)
            .environmentObject(vm)
            .environmentObject(cvm)
            .environmentObject(umlVM)
            .task {
                await vm.getSubmission(id: submissionID)
                if let pId = vm.submission?.participation.id {
                    await cvm.initFileTree(participationId: pId)
                }
            }
    }

struct AssessmentSubmissionLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentSubmissionLoaderView(exerciseID: 5, submissionID: 5, exerciseTitle: "Example Exercise", templateParticipationId: 123123)
    }
}
