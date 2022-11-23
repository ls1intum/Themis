import Foundation
import SwiftUI
import UIKit

// Custom stepper to adjust font size with input field
struct EditorFontSizeStepperView: View {
    @ObservedObject var model = AssessmentViewModel.mock

    var body: some View {
        HStack {
            Text("Font size").bold()
            Spacer()
            Button(action: model.decrementFontSize) {
                Label("", systemImage: "minus")
            }.backgroundStyle(Color.gray)
            TextField("", value: $model.editorFontSize, formatter: NumberFormatter())
                .onSubmit {
                    if model.editorFontSize < 8 {
                        model.editorFontSize = 8
                    }
                }
                .keyboardType(.numberPad)
                .fixedSize()
                .padding(5)
            Button(action: model.incrementFontSize) {
                Label("", systemImage: "plus")
            }.backgroundStyle(Color.gray)
        }.padding(15)
    }
}
