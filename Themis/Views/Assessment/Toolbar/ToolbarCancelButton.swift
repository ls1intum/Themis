//
//  ToolbarCancelButton.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI
import SharedModels

struct ToolbarCancelButton: View {
    @ObservedObject var assessmentVM: AssessmentViewModel
    @Binding var presentationMode: PresentationMode
    @State private var showCancelDialog = false
    
    /// Indicates that the user is viewing a submission that was previously assessed and submitted.
    /// In this case, they can override the assessment, but can not cancel it.
    private var submissionIsAssessed: Bool {
        assessmentVM.submission?.isAssessed == true
    }
    
    private var saveButtonLabel: String {
        submissionIsAssessed ? "Override" : "Save"
    }
    
    private var saveButtonRole: ButtonRole? {
        submissionIsAssessed ? ButtonRole.destructive : nil
    }
    
    private var deleteButtonLabel: String {
        submissionIsAssessed ? "Discard" : "Delete"
    }
    
    private var deleteButtonRole: ButtonRole? {
        submissionIsAssessed ? nil : ButtonRole.destructive
    }
    
    private var message: String {
        if submissionIsAssessed {
            """
            Either discard your recent changes \
            or override the existing assessment.
            """
        } else {
            """
            Either discard the assessment \
            and release the lock (recommended) \
            or keep the lock and save the assessment without submitting it.
            """
        }
    }
    
    var body: some View {
        Button {
            assessmentVM.readOnly ? presentationMode.dismiss() : showCancelDialog.toggle()
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                Text("Cancel")
            }
            .foregroundColor(.white)
        }
        .confirmationDialog("Cancel Assessment", isPresented: $showCancelDialog) {
            Button(saveButtonLabel, role: saveButtonRole) {
                Task {
                    await assessmentVM.saveAssessment()
                    presentationMode.dismiss()
                }
            }
            
            Button(deleteButtonLabel, role: deleteButtonRole) {
                Task {
                    if !submissionIsAssessed {
                        await assessmentVM.cancelAssessment()
                    }
                    presentationMode.dismiss()
                }
            }
        } message: {
            Text(message)
        }
    }
}

 struct CancelButton_Previews: PreviewProvider {
     @Environment(\.presentationMode) private static var presentationMode
     
     static var previews: some View {
         ToolbarCancelButton(assessmentVM: AssessmentViewModel(exercise: Exercise.mockText, readOnly: false), presentationMode: presentationMode)
     }
 }
