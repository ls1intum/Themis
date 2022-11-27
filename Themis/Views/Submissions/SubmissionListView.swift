//
//  SubmissionsListView.swift
//  Themis
//
//  Created by Paul Schwind on 24.11.22.
//

import SwiftUI

struct SubmissionListView: View {

    @StateObject var submissionListVM = SubmissionListViewModel()
    @StateObject var vm = AssessmentViewModel()

    var exerciseId: Int

    var body: some View {
        NavigationStack {
            Button {
                Task {
                    await vm.initRandomSubmission(exerciseId: 5284)
                }
            } label: {
                Text("Assess random submission")
            }
            .navigationDestination(isPresented: $vm.showSubmission) {
                AssessmentView(exerciseId: 5284)
                           .environmentObject(vm)
            }
        }
        .navigationTitle("Your Submissions")
        .task {
            await submissionListVM.fetchTutorSubmissions(exerciseId: exerciseId)
        }
    }
}

struct SubmissionListView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatedPreview {
            SubmissionListView(exerciseId: 5284)
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
