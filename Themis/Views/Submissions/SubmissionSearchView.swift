//
//  SubmissionSearchView.swift
//  Themis
//
//  Created by Andreas Cselovszky on 04.12.22.
//

import SwiftUI
import SharedModels

struct SubmissionSearchView: View {
    @EnvironmentObject var courseVM: CourseViewModel
    @Environment(\.presentationMode) var presentationMode
    @StateObject var submissionSearchVM = SubmissionSearchViewModel()
    @StateObject var assessmentVM = AssessmentViewModel(readOnly: true)
    @State var search: String = ""

    let exercise: Exercise

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(submissionSearchVM.filterSubmissions(search: search), id: \.baseSubmission.id) { submission in
                    SingleSubmissionCellView(avm: assessmentVM, submission: submission)
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
            await submissionSearchVM.fetchSubmissions(exerciseId: exercise.id)
        }
        .navigationDestination(isPresented: $assessmentVM.showSubmission) {
            AssessmentView(
                assessmentVM: assessmentVM,
                assessmentResult: assessmentVM.assessmentResult,
                exercise: exercise
            )
            .environmentObject(courseVM)
        }
        .errorAlert(error: $submissionSearchVM.error)
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
                if let student = submission.getParticipation(as: ProgrammingExerciseStudentParticipation.self)?.student {
                    Text(student.name)
                    Text(student.login)
                }
                linkToRepo
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                Task {
                    if let participationId = submission.getParticipation()?.id {
                        await avm.getSubmission(id: participationId)
                    }
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
    
    @ViewBuilder
    private var linkToRepo: some View {
        if let programmingParticipation = submission.getParticipation(as: ProgrammingExerciseStudentParticipation.self),
           let repoUrl = URL(string: programmingParticipation.repositoryUrl ?? "") {
            Link("Repository", destination: repoUrl)
        }
    }
}

struct SubmissionSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SubmissionSearchView(exercise: Exercise.programming(exercise: .init(id: 1)))
    }
}
