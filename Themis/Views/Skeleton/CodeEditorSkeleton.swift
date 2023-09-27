//
//  CodeEditorSkeleton.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 16.08.23.
//

import SwiftUI

struct CodeEditorSkeleton: View {
    private var randomIndent: CGFloat {
        let randomInt = Int.random(in: 0...10)
        
        if randomInt > 8 {
            return 64
        } else if randomInt > 4 {
            return 32
        } else {
            return 0
        }
    }
    
    private var randomColor: Color {
        [Color.purple, .cyan, .green, .gray].randomElement() ?? .gray
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            codeLine
            
            ForEach(0..<35, id: \.self) { _ in
                codeLine
                    .padding(.leading, randomIndent)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    @ViewBuilder
    private var codeLine: some View {
        HStack {
            ForEach(0..<Int.random(in: 1...4), id: \.self) { _ in
                Text(verbatim: .placeholder(lengthRange: 5...40))
                    .foregroundColor(randomColor)
            }
        }
    }
}

struct CodeEditorSkeleton_Previews: PreviewProvider {
    static var previews: some View {
        CodeEditorSkeleton()
            .showsSkeleton(if: true)
    }
}
