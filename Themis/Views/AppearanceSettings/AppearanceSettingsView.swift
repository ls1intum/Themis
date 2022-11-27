import SwiftUI

struct AppearanceSettingsView: View {
    @ObservedObject var vm: AssessmentViewModel
    @Binding var showSettings: Bool

    var body: some View {
        VStack {
            EditorFontSizeStepperView(vm: vm)
            Spacer()
        }
    }
}

/*struct AppearanceSettingsView_Previews: PreviewProvider {
    @State static var showSettings: Bool = true
    static var previews: some View {
        AppearanceSettingsView(showSettings: $showSettings)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}*/
