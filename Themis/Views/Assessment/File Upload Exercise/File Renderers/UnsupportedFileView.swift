//
//  UnsupportedFileView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 13.09.23.
//

import SwiftUI
import Common

struct UnsupportedFileView: View, FileRenderer {
    var url: URL
    var fileExtension: FileUploadExerciseFileExtension?
    
    @StateObject private var unsupportedFileVM = UnsupportedFileViewModel()
    
    private let backgroundColor = Color(UIColor.systemGray5)
    
    private var errorMsg: String {
        if let fileExtension {
            return ".\(fileExtension.rawValue) files can't be viewed in Themis"
        } else {
            return "This file can't be viewed in Themis"
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            FileErrorIcon()
            
            Text(errorMsg)
                .textCase(.uppercase)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.secondary)
            
            if let localUrl = unsupportedFileVM.localFileUrl {
                shareLink(localUrl)
            } else {
                downloadButton
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .animation(.default, value: unsupportedFileVM.localFileUrl)
    }
    
    @ViewBuilder
    private var downloadButton: some View {
        Button {
            unsupportedFileVM.download(from: url)
        } label: {
            HStack {
                Text("Download")
                    .textCase(.uppercase)
                    .padding(.horizontal)
                
                if unsupportedFileVM.isDownloading {
                    ProgressView()
                }
            }
        }
        .disabled(!unsupportedFileVM.allowsDownloading)
        .buttonStyle(ThemisButtonStyle(color: Color.themisSecondary))
        .transition(.scale.combined(with: .move(edge: .bottom)))
    }
    
    @ViewBuilder
    private func shareLink(_ localUrl: URL) -> some View {
        ShareLink(Text("Export"), item: localUrl)
            .imageScale(.large)
            .font(.system(size: 20))
            .padding()
            .transition(.scale.combined(with: .move(edge: .top)))
    }
}

struct UnsupportedFileView_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_unwrapping
        UnsupportedFileView(url: URL(string: "https://file-examples.com/wp-content/storage/2017/02/file-sample_100kB.doc")!,
                            fileExtension: .png)
    }
}
