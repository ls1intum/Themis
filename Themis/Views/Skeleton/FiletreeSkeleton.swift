//
//  FiletreeSkeleton.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 15.08.23.
//

import SwiftUI

/// A view intended to be used as a skeleton placeholder mocking the appearance of a file tree
struct FiletreeSkeleton: View {
    /// Used  repeatedly to decide whether a random filetree entry should be a file (indented) or a folder (non-indented)
    private var shouldGenerateFile: Bool {
        Int.random(in: 0...10) > 1
    }
    
    private let nameLengthRange = 8...25
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Filetree")
                .font(.title)
                .bold()
                .padding(.bottom)
                .unredacted()
            
            Text(verbatim: .placeholder(lengthRange: nameLengthRange))
            ForEach(0..<25, id: \.self) { _ in
                Text(verbatim: .placeholder(lengthRange: nameLengthRange))
                    .padding(.leading, shouldGenerateFile ? 18 : 0)
            }
            
            Spacer()
        }
        .padding(.leading)
        .padding(.top, 35)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FiletreeSkeleton_Previews: PreviewProvider {
    static var previews: some View {
        FiletreeSkeleton()
            .showsSkeleton(if: true)
    }
}
