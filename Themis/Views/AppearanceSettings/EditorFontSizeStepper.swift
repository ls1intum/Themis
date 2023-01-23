import Foundation
import SwiftUI
import UIKit

// Custom stepper to adjust font size with input field
struct EditorFontSizeStepperView: View {
    @Binding var fontSize: CGFloat
    @Binding var showStepper: Bool

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
            Image(systemName: "textformat.size")
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showStepper.toggle()
                    }
                }
                .foregroundStyle(showStepper ? .yellow : .gray)

            if showStepper {
                Button(action: decrementFontSize) {
                    Label("", systemImage: "minus")
                }.backgroundStyle(Color.gray)
                
                TextField("", value: $fontSize, formatter: NumberFormatter())
                    .onSubmit {
                        ensureLargeEnoughFontSize()
                    }
                    .foregroundColor(.white)
                    .keyboardType(.numberPad)
                    .fixedSize()
                
                Button(action: incrementFontSize) {
                    Label("", systemImage: "plus")
                }.backgroundStyle(Color.gray)
            }
        }
    }
}
