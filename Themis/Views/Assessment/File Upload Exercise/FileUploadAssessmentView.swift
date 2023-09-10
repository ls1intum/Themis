//
//  FileUploadAssessmentView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 10.09.23.
//

import SwiftUI
import SharedModels

struct FileUploadAssessmentView: View {
    @ObservedObject var assessmentVM: AssessmentViewModel
    @ObservedObject var assessmentResult: AssessmentResult
    @StateObject private var paneVM = PaneViewModel(mode: .rightOnly)
    
    // TODO: handle this case
    private let didStartNextAssessment = NotificationCenter.default.publisher(for: NSNotification.Name.nextAssessmentStarted)
    
    var body: some View {
        HStack(spacing: 0) {
            PDFRenderer()
            
            Group {
                RightGripView(paneVM: paneVM)
                
                correctionWithPlaceholder
                    .frame(width: paneVM.dragWidthRight)
            }
            .animation(.default, value: paneVM.showRightPane)
        }
        .task {
            await assessmentVM.initSubmission()
        }
//        .errorAlert(error: $umlRendererVM.error, onDismiss: { presentationMode.wrappedValue.dismiss() })
    }
    
    private var correctionWithPlaceholder: some View {
        VStack {
            CorrectionSidebarView(
                assessmentResult: $assessmentVM.assessmentResult,
                assessmentVM: assessmentVM
            )
        }
    }
}

struct FileUploadAssessmentView_Previews: PreviewProvider {
    @StateObject private static var assessmentVM = MockAssessmentViewModel(exercise: Exercise.mockFileUpload, readOnly: false)
    
    static var previews: some View {
        FileUploadAssessmentView(assessmentVM: assessmentVM,
                                 assessmentResult: assessmentVM.assessmentResult)
        .previewInterfaceOrientation(.landscapeRight)
    }
}
