import SwiftUI
import SwiftUIReorderableForEach


// used to show opened tabs on top of CodeView
struct TabsView: View {
    @ObservedObject var cvm: CodeEditorViewModel
    @State private var allowReordering = true

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollReader in
                HStack(spacing: 0) {
                    Divider()
                    
                    // ForEach(cvm.openFiles, id: \.path) { file in
                    ReorderableForEach($cvm.openFiles, allowReordering: $allowReordering) { file, _ in
                        ZStack {
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundColor(file.path == cvm.selectedFile?.path ? Color(UIColor.systemGray5) : Color(UIColor.systemBackground))

                            HStack(spacing: 0) {
                                Text(file.name)
                                    .bold(cvm.selectedFile?.path == file.path)
                                    .padding(.leading, 10)
                                    .padding(.trailing, file.path == cvm.selectedFile?.path ? 0 : 10)
                                if file.path == cvm.selectedFile?.path {
                                    Button(action: {
                                        cvm.closeFile(file: file)
                                    }, label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                            .buttonStyle(.borderless)
                                    })
                                    .padding(.leading, 7)
                                    .padding(.trailing, 10)
                                }
                                Divider()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .id(file)
                            .onTapGesture {
                                withAnimation {
                                    cvm.selectedFile = file
                                }
                            }
                        }
                    }
                }
                .frame(height: 30)
                .onChange(of: cvm.selectedFile, perform: { file in
                    scrollReader.scrollTo(file, anchor: nil)
                })
            }
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    private static var cvm = CodeEditorViewModel()

    static var previews: some View {
        TabsView(cvm: cvm)
    }
}
