import SwiftUI

struct AppearanceSettingsView: View {
    @Binding var fontSize: CGFloat

    var body: some View {
        VStack {
            EditorFontSizeStepperView(fontSize: $fontSize)
            Spacer()
        }
    }
}
