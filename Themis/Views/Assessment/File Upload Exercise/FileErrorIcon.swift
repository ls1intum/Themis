//
//  FileErrorIcon.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 02.10.23.
//

import SwiftUI

/// Used for indicating file-related problems
struct FileErrorIcon: View {
    var backgroundColor = Color(UIColor.systemGray5)
    
    var body: some View {
        Image(systemName: "doc.fill")
            .font(.system(size: 80))
            .padding(.bottom)
            .overlay {
                Image(systemName: "xmark")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top)
                    .foregroundColor(backgroundColor)
            }
            .foregroundColor(.secondary)
    }
}

#Preview {
    FileErrorIcon()
}
