//
//  ToolbarFileTreeToggleButton.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI

struct ToolbarFileTreeToggleButton: View {
    @ObservedObject var paneVM: PaneViewModel
        
    var body: some View {
        Button {
            paneVM.showLeftPane.toggle()
            
            paneVM.leftPaneAsPlaceholder = false
            
            if paneVM.dragWidthLeft < paneVM.minLeftSnapWidth {
                paneVM.dragWidthLeft = paneVM.minLeftSnapWidth
            } else if paneVM.dragWidthLeft > 0.4 * UIScreen.main.bounds.size.width {
                paneVM.dragWidthLeft = 0.4 * UIScreen.main.bounds.size.width
            }
        } label: {
            Image(systemName: "sidebar.left")
                .font(.system(size: 23))
        }
    }
}

struct FileTreeToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarFileTreeToggleButton(paneVM: PaneViewModel())
    }
}
