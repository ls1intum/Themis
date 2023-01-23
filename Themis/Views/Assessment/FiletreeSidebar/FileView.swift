//
//  FileView.swift
//  Themis
//
//  Created by Tom Rudnick on 23.01.23.
//

import SwiftUI

struct FileView: View {
    var file: Node
    var body: some View {
        HStack {
            iconView(file: file)
            Text(file.name)
        }
    }
    
    @ViewBuilder
    func iconView(file: Node) -> some View {
        Group {
            if let language = file.language(), let image = image(for: language, style: .original) {
                image
                    .resizable()
                    .frame(width: 20, height: 20)
            } else {
                Spacer()
                    .frame(width: 30)
            }
        }
    }
    
    func image(for language: Language, style: Style) -> Image? {
        let imageName = "\(language.rawValue)-\(style.rawValue)"
        if let image = UIImage(named: imageName){
            return Image(uiImage: image)
        }
        let alternativeStyle = style == .plain ? Style.original : .plain
        let alternativeImageName = "\(language.rawValue)-\(alternativeStyle.rawValue)"
        if let image = UIImage(named: alternativeImageName) {
            return Image(uiImage: image)
        }
        return nil
    }
}


