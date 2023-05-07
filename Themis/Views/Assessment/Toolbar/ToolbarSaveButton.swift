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
                if let pId = assessmentVM.participation?.id {
                    await assessmentVM.sendAssessment(participationId: pId, submit: false)
                }
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
