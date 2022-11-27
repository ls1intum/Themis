import Foundation
import SwiftUI
import UIKit

// Custom stepper to adjust font size with input field
struct EditorFontSizeStepperView: View {

    @ObservedObject var vm: CodeEditorViewModel

    var body: some View {
        HStack {
            Text("Font size").bold()
            Spacer()
            Button(action: vm.decrementFontSize) {
                Label("", systemImage: "minus")
            }.backgroundStyle(Color.gray)
            TextField("", value: $vm.editorFontSize, formatter: NumberFormatter())
                .onSubmit {
                    if vm.editorFontSize < 8 {
                        vm.editorFontSize = 8
                    }
                }
                .keyboardType(.numberPad)
                .fixedSize()
                .padding(5)
            Button(action: vm.incrementFontSize) {
                Label("", systemImage: "plus")
            }.backgroundStyle(Color.gray)
        }.padding(15)
    }
}
