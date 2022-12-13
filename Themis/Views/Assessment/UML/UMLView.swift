//
//  UMLView.swift
//  Themis
//
//  Created by Evan Christopher on 10.12.22.
//

import Foundation
import SwiftUI

struct UMLView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var umlVM: UMLViewModel
    @State var viewOffset: CGSize = .zero

    var body: some View {
        ZStack {
            if colorScheme == .light {
                Color.gray.ignoresSafeArea().opacity(0.6)
            } else {
                Color.black.ignoresSafeArea().opacity(0.9)
            }

            AsyncImage(url: URL(string: umlVM.imageURL ?? "")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(viewOffset)
                    .scaleEffect(umlVM.scale > 1 ? umlVM.scale : 1)
                    .gesture(
                        // zoom in or out
                        MagnificationGesture()
                            .onChanged({ (value)  in
                                umlVM.scale = value
                            })
                            .onEnded({ (value) in
                                withAnimation(.easeInOut) {
                                    umlVM.scale = value
                                }
                            })
                            .simultaneously(with: TapGesture(count: 2)
                                .onEnded({
                                    withAnimation(.spring()) { umlVM.scale = umlVM.scale > 1 ? 1 : 2 } // double tap to zoom in (2x scale)
                                })
                            )
                            .simultaneously(with: DragGesture()
                                .onChanged({ (value) in
                                    withAnimation(.easeInOut) {
                                        viewOffset = value.translation
                                    }
                                })
                            )
                    )
            } placeholder: {
                ProgressView()
            }
        }
        .overlay(
            Button(action: {
                withAnimation(.easeInOut) {
                    umlVM.showUMLFullScreen.toggle()
                }
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.7))
                    .clipShape(Circle())
            }).padding(5),
            alignment: .topTrailing
        )
    }
}
