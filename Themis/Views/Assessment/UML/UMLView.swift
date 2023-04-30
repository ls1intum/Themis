//
//  UMLView.swift
//  Themis
//
//  Created by Evan Christopher on 10.12.22.
//
import Foundation
import SwiftUI
import CachedAsyncImage

struct UMLView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var umlVM: UMLViewModel
    @State var viewOffset: CGSize = .zero
    @State private var currentTranslation: CGSize = .zero
    
    var body: some View {
        ZStack {
            backgroundColor
            umlImage
        }
        .overlay(
            closeButton,
            alignment: .topTrailing
        )
    }
    
    @ViewBuilder
    private var umlImage: some View {
        CachedAsyncImage(url: URL(string: umlVM.imageURL ?? ""), urlCache: .imageCache) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .offset(x: viewOffset.width + currentTranslation.width, y: viewOffset.height + currentTranslation.height)
                .scaleEffect(umlVM.scale)
                .gesture(
                    // zoom in or out
                    MagnificationGesture()
                        .onChanged { value in
                            umlVM.scale = value.magnitude
                        }
                        .simultaneously(with: TapGesture(count: 2)
                            .onEnded({
                                withAnimation(.spring()) { umlVM.scale = umlVM.scale > 1 ? 1 : 2 } // double tap to zoom in (2x scale)
                            })
                        )
                        .simultaneously(with: DragGesture()
                            .onChanged { value in
                                withAnimation(.default) {
                                    currentTranslation = value.translation
                                }
                            }
                            .onEnded { value in
                                withAnimation(.default) {
                                    self.viewOffset.width += value.translation.width
                                    self.viewOffset.height += value.translation.height
                                    self.currentTranslation = .zero
                                }
                            }
                        )
                )
        } placeholder: {
            ProgressView()
        }.onDisappear {
            umlVM.scale = 1
        }
    }
    
    @ViewBuilder
    private var backgroundColor: some View {
        if colorScheme == .light {
            Color.gray.ignoresSafeArea().opacity(0.6)
        } else {
            Color.black.ignoresSafeArea().opacity(0.9)
        }
    }
    
    @ViewBuilder
    private var closeButton: some View {
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
        })
        .padding(5)
    }
}

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512 * 1000 * 1000, diskCapacity: 10 * 1000 * 1000 * 1000)
}
