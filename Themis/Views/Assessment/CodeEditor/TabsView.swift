import SwiftUI
import SwiftUIReorderableForEach


/// Used to show opened tabs on top of CodeView
struct TabsView: View {
    @ObservedObject var cvm: CodeEditorViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollReader in
                HStack(spacing: 0) {
                    Divider()
                    ReorderableForEach($cvm.openFiles, allowReordering: .constant(true)) { file, _ in
                        ZStack {
                            backgroundRectangle(for: file)

                            HStack(spacing: 0) {
                                nameLabel(for: file)
                                
                                if cvm.isOpen(file: file) {
                                    closeButton(for: file)
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
                .onChange(of: cvm.selectedFile) { _, file in
                    scrollReader.scrollTo(file, anchor: nil)
                }
            }
        }
    }
    
    private func backgroundRectangle(for file: Node) -> some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(file.path == cvm.selectedFile?.path ? Color(UIColor.systemGray5) : Color(UIColor.systemBackground))
    }
    
    private func closeButton(for file: Node) -> some View {
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
    
    private func nameLabel(for file: Node) -> some View {
        Text(file.name)
            .bold(cvm.selectedFile?.path == file.path)
            .padding(.leading, 10)
            .padding(.trailing, file.path == cvm.selectedFile?.path ? 0 : 10)
    }
}

struct TabsView_Previews: PreviewProvider {
    private static var cvm = CodeEditorViewModel()

    static var previews: some View {
        TabsView(cvm: cvm)
    }
}
