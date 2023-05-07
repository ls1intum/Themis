//
//  ToolbarSaveButton.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI

struct ToolbarSaveButton: View {
    @ObservedObject var assessmentVM: AssessmentViewModel
    
    var body: some View {
        Button {
            Task {
                await assessmentVM.sendAssessment(submit: false)
            }
        } label: {
            Text("Save")
                .foregroundColor(.white)
        }
        .buttonStyle(ThemisButtonStyle(iconImageName: "saveIcon"))
    }
}

struct ToolbarSaveButton_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarSaveButton(assessmentVM: AssessmentViewModel(readOnly: false))
    }
}
