import Foundation
import SwiftUI
import UIKit
import CodeEditor

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
            Button(action: decrementFontSize) {
                Image(systemName: "minus")
            }
            .backgroundStyle(Color.gray)
            
            TextField("", value: $fontSize, formatter: NumberFormatter())
                .onSubmit {
                    ensureLargeEnoughFontSize()
                }
                .keyboardType(.numberPad)
                .fixedSize()
                .frame(width: 30)
            
            Button(action: incrementFontSize) {
                Image(systemName: "plus")
            }.backgroundStyle(Color.gray)
        }
        .padding(20)
    }
}

struct FontSizeStepperView_Previews: PreviewProvider {
    @State static var fontSize: CGFloat = CodeEditor.defaultFontSize
    
    static var previews: some View {
        EditorFontSizeStepperView(fontSize: $fontSize)
            .background(.primary)
    }
}
