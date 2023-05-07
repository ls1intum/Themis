//
//  ToolbarCancelButton.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI

struct ToolbarCancelButton: View {
    @ObservedObject var assessmentVM: AssessmentViewModel
    @Binding var presentationMode: PresentationMode
    @State private var showCancelDialog = false
    
    private var nothingToSave: Bool {
        assessmentVM.readOnly || !UndoManager.shared.canUndo
    }
    
    var body: some View {
        Button {
            Task {
                nothingToSave ? presentationMode.dismiss() : showCancelDialog.toggle()
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
                    if let pId = assessmentVM.submission?.getParticipation()?.id {
                        await assessmentVM.sendAssessment(participationId: pId, submit: false)
                    }
                    presentationMode.dismiss()
                }
            }
            Button("Delete", role: .destructive) {
                Task {
                    if let id = assessmentVM.submission?.id {
                        await assessmentVM.cancelAssessment(submissionId: id)
                    }
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

// struct CancelButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CancelButton(assessmentVM: AssessmentViewModel(readOnly: false), presentationMode: .cons))
//    }
// }
