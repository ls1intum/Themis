//
//  ImageFileRenderer.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 16.09.23.
//

import SwiftUI

struct ImageFileRenderer: View, FileRenderer {
    var url: URL
    
    var body: some View {
        if let imageData = try? Data(contentsOf: url),
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            couldNotOpenView
        }
    }
    
    private var couldNotOpenView: some View {
        VStack {
            Spacer()
            
            Image(systemName: "xmark")
                .font(.system(size: 80))
                .padding(.bottom)
            
            Text("Could not open file")
                .textCase(.uppercase)
                .font(.system(size: 17, weight: .medium))
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.secondary)
        .background(Color(UIColor.systemGray5))
    }
}

struct ImageFileRenderer_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_unwrapping
        ImageFileRenderer(url: URL(string: "https://static01.nyt.com/images/2018/02/05/us/05xpThe-Simpsons/00xpThe-Simpsons-superJumbo.jpg")!)
    }
}
