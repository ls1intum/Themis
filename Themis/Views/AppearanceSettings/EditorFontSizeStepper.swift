import Foundation
import SwiftUI
import UIKit

// Custom stepper to adjust font size with input field
struct EditorFontSizeStepperView: View {

    @EnvironmentObject var cvm: CodeEditorViewModel

    var body: some View {
        HStack {
            Text("Font size").bold()
            Spacer()
            Button(action: cvm.decrementFontSize) {
                Label("", systemImage: "minus")
            }.backgroundStyle(Color.gray)
            TextField("", value: $cvm.editorFontSize, formatter: NumberFormatter())
                .onSubmit {
                    if cvm.editorFontSize < 8 {
                        cvm.editorFontSize = 8
                    }
                }
                .keyboardType(.numberPad)
                .fixedSize()
                .padding(5)
            Button(action: cvm.incrementFontSize) {
                Label("", systemImage: "plus")
            }.backgroundStyle(Color.gray)
        }.padding(15)
    }
}
