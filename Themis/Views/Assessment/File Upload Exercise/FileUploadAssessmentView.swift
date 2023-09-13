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
    @StateObject private var fileRendererVM = FileRendererViewModel()
    @StateObject private var paneVM = PaneViewModel(mode: .rightOnly)
    
    // TODO: handle this case
    private let didStartNextAssessment = NotificationCenter.default.publisher(for: NSNotification.Name.nextAssessmentStarted)
    
    var body: some View {
        HStack(spacing: 0) {
            if !fileRendererVM.isSetupComplete || fileRendererVM.isLoading {
                VStack { // TODO: replace with a skeleton once the skeleton PR is merged
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                fileRenderer
            }
            
            Group {
                RightGripView(paneVM: paneVM)
                
                correctionWithPlaceholder
                    .frame(width: paneVM.dragWidthRight)
            }
            .animation(.default, value: paneVM.showRightPane)
        }
        .task {
            await assessmentVM.initSubmission()
            await fileRendererVM.setup(basedOn: assessmentVM.submission)
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
    
    @ViewBuilder
    private var fileRenderer: some View {
        if let localFileUrl = fileRendererVM.localFileURL, fileRendererVM.canDirectlyRenderFile {
            FileRendererFactory.renderer(for: localFileUrl)
        } else {
            UnsupportedFileView(fileExtension: fileRendererVM.localFileURL?.pathExtension)
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
