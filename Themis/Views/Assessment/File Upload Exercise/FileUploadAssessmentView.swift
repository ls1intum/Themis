//
//  FileUploadAssessmentView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 10.09.23.
//

import SwiftUI
import SharedModels
import Common

struct FileUploadAssessmentView: View {
    @ObservedObject var assessmentVM: AssessmentViewModel
    @ObservedObject var assessmentResult: AssessmentResult
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var fileRendererVM = FileRendererViewModel()
    @StateObject private var paneVM = PaneViewModel(mode: .rightOnly)
    
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
        .onReceive(didStartNextAssessment, perform: { _ in
            guard assessmentVM.submission != nil else {
                log.warning("Received notification about a new assessment, but couldn't find a submission in the AssessmentViewModel")
                return
            }
            Task {
                await fileRendererVM.setup(basedOn: assessmentVM.submission)
            }
        })
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
        if let fileExtension = fileRendererVM.fileExtension {
            if let localFileUrl = fileRendererVM.localFileURL {
                FileRendererFactory.renderer(for: fileExtension, at: localFileUrl)
            } else if let remoteFileUrl = fileRendererVM.remoteFileURL {
                UnsupportedFileView(url: remoteFileUrl)
            }
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
