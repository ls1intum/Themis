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
    
    var body: some View {
        Button {
            Task {
                assessmentVM.readOnly ? presentationMode.dismiss() : showCancelDialog.toggle()
            }
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                Text("Cancel")
            }
            .foregroundColor(.white)
        }
        .confirmationDialog("Cancel Assessment", isPresented: $showCancelDialog) {
            Button("Save") {
                Task {
                    await assessmentVM.saveAssessment()
                    presentationMode.dismiss()
                }
            }
            
            Button("Delete", role: .destructive) {
                Task {
                    await assessmentVM.cancelAssessment()
                    presentationMode.dismiss()
                }
            }
        } message: {
            Text("""
                 Either discard the assessment \
                 and release the lock (recommended) \
                 or keep the lock and save the assessment without submitting it.
                 """)
        }
    }
}

 struct CancelButton_Previews: PreviewProvider {
     @Environment(\.presentationMode) private static var presentationMode
     
     static var previews: some View {
         ToolbarCancelButton(assessmentVM: AssessmentViewModel(exercise: Exercise.mockText, readOnly: false), presentationMode: presentationMode)
     }
 }
