import SwiftUI

struct AppearanceSettingsView: View {
    @Binding var showSettings: Bool

    var body: some View {
        VStack {
            EditorFontSizeStepperView()
            Spacer()
        }
    }
}
