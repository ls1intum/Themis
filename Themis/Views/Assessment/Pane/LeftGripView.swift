//
//  LeftGripView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI

struct LeftGripView: View {
    @ObservedObject var paneVM: PaneViewModel
    
    var body: some View {
        ZStack {
            Color.themisPrimary
                .frame(maxWidth: 7, maxHeight: .infinity)
            
            Rectangle()
                .opacity(0)
                .frame(width: 20, height: 50)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            paneVM.handleLeftGripDrag(gesture)
                        }
                        .onEnded { gesture in
                            paneVM.handleLeftGripDragEnd(gesture)
                        }
                )
            
            Image(systemName: "minus")
                .resizable()
                .frame(width: 50, height: 3)
                .foregroundColor(.gray)
                .rotationEffect(.degrees(90))
        }
        .frame(width: 7)
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct LeftGripView_Previews: PreviewProvider {
    static var previews: some View {
        LeftGripView(paneVM: PaneViewModel())
    }
}
