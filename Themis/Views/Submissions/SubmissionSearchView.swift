//
//  SubmissionSearchView.swift
//  Themis
//
//  Created by Andreas Cselovszky on 04.12.22.
//

import SwiftUI

struct SubmissionSearchView: View {
    @StateObject var vm = SubmissionSearchViewModel()
    @StateObject var avm = AssessmentViewModel(readOnly: true)
    @StateObject var cvm = CodeEditorViewModel()
    @State var search: String = ""

    let exercise: Exercise

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.filterSubmissions(search: search)) { submission in
                    SingleSubmissionCellView(avm: avm, submission: submission)
                }
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal) {
                searchBar
            }
        }
        .task {
            await vm.fetchSubmissions(exerciseId: exercise.id)
        }
        .navigationDestination(isPresented: $avm.showSubmission) {
            AssessmentView(
                vm: avm,
                cvm: cvm,
                exerciseId: exercise.id,
                exerciseTitle: exercise.title ?? "",
                templateParticipationId: exercise.templateParticipation?.id ?? 0
            )
        }
    }
}

extension SubmissionSearchView {
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .foregroundColor(Color(.label))
                .frame(width: 20, height: 20)
            TextField("Search for a submission", text: $search)
                .submitLabel(.search)
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}

private struct SingleSubmissionCellView: View {
    @ObservedObject var avm: AssessmentViewModel

    let submission: Submission

    var body: some View {
        HStack {
            Group {
                Text(submission.participation.student.name)
                Text(submission.participation.student.login)
                Link("Repository", destination: URL(string: submission.participation.repositoryUrl)!)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                Task {
                    await avm.getSubmission(id: submission.participation.id)
                }
            } label: {
                HStack {
                    Text("View")
                    Image(systemName: "chevron.right")
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color(.systemGray6))
        )
    }
}

struct SubmissionSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SubmissionSearchView(exercise: Exercise())
    }
}
