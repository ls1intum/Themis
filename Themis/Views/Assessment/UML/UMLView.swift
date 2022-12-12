//
//  ImageView.swift
//  Themis
//
//  Created by Evan Christopher on 10.12.22.
//

import Foundation
import SwiftUI

struct UMLView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var umlVM: UMLViewModel
    @GestureState var draggingOffset: CGSize = .zero

    var body: some View {
        ZStack {
            if colorScheme == .light {
                Color.white.ignoresSafeArea().opacity(umlVM.bgOpacity)
            } else {
                Color.black.ignoresSafeArea().opacity(umlVM.bgOpacity)
            }

            AsyncImage(url: URL(string: umlVM.imageURL ?? "")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(y: umlVM.viewOffset.height)
                    .opacity(umlVM.bgOpacity)
                    .scaleEffect(umlVM.scale > 1 ? umlVM.scale : 1)
                    .gesture(
                        // zoom in or out
                        MagnificationGesture().onChanged({ (value)  in
                            umlVM.scale = value
                        }).onEnded({ (_) in
                            withAnimation(.spring()) {
                                umlVM.scale = 1
                            }
                        })
                        .simultaneously(with: TapGesture(count: 2).onEnded({
                            withAnimation {
                                // double tap to zoom in (2x scale)
                                umlVM.scale = umlVM.scale > 1 ? 1 : 2
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
                    .background(Color.white.opacity(0.3))
                    .clipShape(Circle())
            }).padding(5),
            alignment: .topTrailing
        )
        .gesture(DragGesture().updating($draggingOffset, body: { (value, outValue, _ ) in
            outValue = value.translation
            umlVM.onChange(value: draggingOffset)
        }).onEnded(umlVM.onEnd(value:)))
    }
}
