import SwiftUI

struct AppearanceSettingsView: View {
    @ObservedObject var vm: CodeEditorViewModel
    @Binding var showSettings: Bool

    var body: some View {
        VStack {
            EditorFontSizeStepperView(vm: vm)
            Spacer()
        }
    }
}
