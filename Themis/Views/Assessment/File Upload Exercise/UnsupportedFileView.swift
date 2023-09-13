//
//  UnsupportedFileView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 13.09.23.
//

import SwiftUI

struct UnsupportedFileView: View {
    var fileExtension: String?
    private let backgroundColor = Color(UIColor.systemGray5)
    
    private var errorMsg: String {
        if let fileExtension {
            return ".\(fileExtension) files can't be viewed in Themis"
        } else {
            return "This file can't be viewed in Themis"
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "doc.fill")
                .font(.system(size: 80))
                .padding(.bottom)
                .overlay {
                    Image(systemName: "xmark")
                        .font(.system(size: 30, weight: .bold))
                        .padding(.top)
                        .foregroundColor(backgroundColor)
                }
            
            Text(errorMsg)
                .textCase(.uppercase)
                .font(.system(size: 17, weight: .medium))
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.secondary)
        .background(backgroundColor)
    }
}

struct UnsupportedFileView_Previews: PreviewProvider {
    static var previews: some View {
        UnsupportedFileView(fileExtension: ".docx")
    }
}
