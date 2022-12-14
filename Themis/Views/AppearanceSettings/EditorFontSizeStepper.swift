import Foundation
import SwiftUI
import UIKit

// Custom stepper to adjust font size with input field
struct EditorFontSizeStepperView: View {

    @Binding var fontSize: CGFloat

    func ensureLargeEnoughFontSize() {
        if fontSize < 8 {
            fontSize = 8
        }
    }

    func incrementFontSize() {
        fontSize += 1
    }

    func decrementFontSize() {
        fontSize -= 1
        ensureLargeEnoughFontSize()
    }

    var body: some View {
        HStack {
            Text("Font size").bold()
            Spacer()
            Button(action: decrementFontSize) {
                Label("", systemImage: "minus")
            }.backgroundStyle(Color.gray)
            TextField("", value: $fontSize, formatter: NumberFormatter())
                .onSubmit {
                    ensureLargeEnoughFontSize()
                }
                .keyboardType(.numberPad)
                .fixedSize()
                .padding(5)
            Button(action: incrementFontSize) {
                Label("", systemImage: "plus")
            }.backgroundStyle(Color.gray)
        }.padding(15)
    }
}
