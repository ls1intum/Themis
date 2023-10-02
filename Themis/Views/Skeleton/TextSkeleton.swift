//
//  TextSkeleton.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 16.08.23.
//

import SwiftUI

struct TextSkeleton: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text(verbatim: .placeholder(lengthRange: 20...30))
                .font(.system(size: 35))
            
            generateLines()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .showsSkeleton(if: true)
    }
    
    @ViewBuilder
    private func generateLines(_ count: Int = 20) -> some View {
        ForEach(0..<count, id: \.self) { _ in
            Rectangle()
                .foregroundColor(Color(UIColor.systemGray3))
                .frame(height: 14)
        }
    }
}

struct TextSkeleton_Previews: PreviewProvider {
    static var previews: some View {
        TextSkeleton()
            .showsSkeleton(if: true)
    }
}
