import SwiftUI

struct AppearanceSettingsView: View {
    @StateObject var model = AssessmentViewModel.mock
    @Binding var showSettings: Bool
    var body: some View {
        VStack {
            EditorFontSizeStepperView(model: model)
            Spacer()
        }
    }
}
struct AppearanceSettingsView_Previews: PreviewProvider {
    @State static var showSettings: Bool = true
    static var previews: some View {
        AppearanceSettingsView(showSettings: $showSettings)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
