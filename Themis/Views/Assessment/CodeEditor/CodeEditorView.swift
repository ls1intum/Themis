import SwiftUI

struct CodeEditorView: View {
    @ObservedObject var model: AssessmentViewModel
    @Binding var showFileTree: Bool

    var body: some View {
        VStack {
            if model.selectedFile != nil {
                VStack {
                    HStack {
                        Spacer()
                            .frame(width: showFileTree ? 0 : 40)
                        TabsView(model: model)
                    }
                    CodeView(model: model)
                }
            } else {
                Text("Select a file")
            }
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
    }
}
