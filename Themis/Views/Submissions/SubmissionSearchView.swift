//
//  SubmissionSearchView.swift
//  Themis
//
//  Created by Andreas Cselovszky on 04.12.22.
//

import SwiftUI
import SharedModels

struct SubmissionSearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var submissionSearchVM = SubmissionSearchViewModel()
    @State var search: String = ""

    let exercise: Exercise

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(submissionSearchVM.filterSubmissions(search: search).mock(if: submissionSearchVM.isLoading,
                                                                                  mockElementCountRange: 3...5),
                        id: \.baseSubmission.id) { submission in
                    SingleSubmissionCellView(exercise: exercise, submission: submission)
                }
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal) {
                searchBar.isHidden(submissionSearchVM.isLoading)
            }
        }
        .showsSkeleton(if: submissionSearchVM.isLoading)
        .task {
            await submissionSearchVM.fetchSubmissions(exercise: exercise)
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
    @EnvironmentObject var courseVM: CourseViewModel
    @State var showAssessmentView = false

    let exercise: Exercise
    let submission: Submission

    var body: some View {
        HStack {
            Group {
                if let student = submission.getParticipation(as: StudentParticipation.self)?.student {
                    Text(student.name)
                    Text(student.login)
                }
                linkToRepo
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                showAssessmentView = true
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
        .navigationDestination(isPresented: $showAssessmentView) {
            AssessmentView(
                exercise: exercise,
                submissionId: submission.baseSubmission.id,
                participationId: submission.getParticipation()?.id,
                readOnly: true
            )
            .environmentObject(courseVM)
        }
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
