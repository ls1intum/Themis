//
//  RightGripView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI

struct RightGripView: View {
    @ObservedObject var paneVM: PaneViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .opacity(0)
                .frame(width: paneVM.dragWidthRight > 0 ? 20 : 70, height: paneVM.dragWidthRight > 0 ? 50 : 120)
                .contentShape(Rectangle())
                .onTapGesture {
                    paneVM.handleRightGripTap()
                }
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            paneVM.handleRightGripDrag(gesture)
                        }
                        .onEnded { gesture in
                            paneVM.handleRightGripDragEnd(gesture)
                        }
                )
                .zIndex(1)
            
            if paneVM.dragWidthRight > 0 {
                Color.themisPrimary
                    .frame(maxWidth: 7, maxHeight: .infinity)
                    .ignoresSafeArea()
                
                Image(systemName: "minus")
                    .resizable()
                    .frame(width: 50, height: 3)
                    .foregroundColor(.gray)
                    .rotationEffect(.degrees(90))
            } else {
                rightLabel
            }
        }
        .frame(width: 7)
    }
    
    var rightLabel: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.themisPrimary)
                .frame(width: 70, height: 120)
            VStack {
                Image(systemName: "chevron.up")
                Text("Correction")
                Spacer()
            }
            .foregroundColor(.white)
            .frame(width: 120, height: 70)
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            .rotationEffect(.degrees(270))
        }
    }
}

struct RightGripView_Previews: PreviewProvider {
    static var previews: some View {
        RightGripView(paneVM: PaneViewModel())
    }
}
