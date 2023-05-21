//
//  ExerciseGroups.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 18.05.23.
//

import SwiftUI
import DesignLibrary
import SharedModels

/// Generates 2 ExerciseSections: one for exercises, another for exam exercises
struct ExerciseGroups: View {
    var exercises: [Exercise]
    
    var type: ExerciseFormType
    
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
                ExerciseSections(exercises: exercises)
            }
            .padding([.bottom, .horizontal], 20)
        }
        .background(Color(UIColor.tertiarySystemGroupedBackground))
        .cornerRadius(12)
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
    static var previews: some View {
        ScrollView {
            ExerciseGroups(exercises: Course.mock.exercises ?? [], type: .inAssessment)
                .padding(.bottom)
            ExerciseGroups(exercises: Course.mock.exercises ?? [], type: .viewOnly)
        }
        .previewInterfaceOrientation(.landscapeRight)
        .padding(40)
    }
}
