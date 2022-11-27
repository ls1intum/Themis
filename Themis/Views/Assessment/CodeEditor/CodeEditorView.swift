import SwiftUI

struct CodeEditorView: View {
    @EnvironmentObject var assessmentViewModel: AssessmentViewModel

    @ObservedObject var vm: CodeEditorViewModel
    @Binding var showFileTree: Bool

    var body: some View {
        VStack {
            if vm.selectedFile != nil {
                VStack {
                    HStack {
                        Spacer()
                            .frame(width: showFileTree ? 0 : 40)
                        TabsView(vm: vm)
                    }
                    CodeView(vm: vm)
                }
            } else {
                Text("Select a file")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}
