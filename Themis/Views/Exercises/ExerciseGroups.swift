//
//  ExerciseGroups.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 18.05.23.
//

import SwiftUI
import DesignLibrary
import SharedModels

/// Generates 2 sections: one for exercises, another for exam exercises
struct ExerciseGroups: View {
    @ObservedObject var courseVM: CourseViewModel
    
    var type: ExerciseFormType
    
    var relevantExercises: [Exercise] {
        type == .inAssessment ? courseVM.assessableExercises : courseVM.viewOnlyExercises
    }
    
    var relevantExams: [Exam] {
        type == .inAssessment ? courseVM.assessableExams : courseVM.viewOnlyExams
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: type.iconName)
                    .font(.system(size: 18, weight: .bold))
                
                Text(type.title)
                    .font(.system(size: 19, weight: .bold))
            }
            .foregroundColor(Color.Artemis.artemisBlue)
            .textCase(.uppercase)
            .padding([.leading, .top])
            
            VStack {
                ExerciseSection(exercises: relevantExercises)
                ExamSection(exams: relevantExams, courseID: courseVM.shownCourseID ?? -1)
            }
            .padding([.bottom, .horizontal], 20)
        }
        .background(Color(UIColor.tertiarySystemGroupedBackground))
        .cornerRadius(12)
        .isHidden(!courseVM.loading && relevantExams.isEmpty && relevantExercises.isEmpty,
                  remove: true)
    }
}

enum ExerciseFormType {
    case inAssessment, viewOnly
    
    var title: String {
        self == .inAssessment ? "Currently in assessment" : "View only"
    }
    
    var iconName: String {
        self == .inAssessment ? "pencil.and.outline" : "eyeglasses"
    }
}

struct ExerciseGroups_Previews: PreviewProvider {
    static var courseVM = CourseViewModel()
    
    static var previews: some View {
        ScrollView {
            ExerciseGroups(courseVM: courseVM, type: .inAssessment)
                .padding(.bottom)
            ExerciseGroups(courseVM: courseVM, type: .viewOnly)
        }
        .onAppear {
            courseVM.assessableExercises = Course.mock.exercises ?? []
            courseVM.viewOnlyExercises = Course.mock.exercises ?? []
        }
        .previewInterfaceOrientation(.landscapeRight)
        .padding(40)
    }
}
