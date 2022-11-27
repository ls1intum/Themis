import SwiftUI

// used to show opened tabs on top of CodeView
struct TabsView: View {
    @ObservedObject var vm: AssessmentViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { scrollReader in
                HStack {
                    Divider()
                    ForEach(vm.openFiles, id: \.path) { file in
                        HStack {
                            Text(file.name)
                                .bold(vm.selectedFile?.path == file.path)
                            Button(action: {
                                vm.closeFile(file: file)
                            }, label: {
                                if file.path == vm.selectedFile?.path {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .buttonStyle(.borderless)
                                }
                            })
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 20)
                        .id(file)
                        .onTapGesture {
                            withAnimation {
                                vm.selectedFile = file
                            }
                        }
                        Divider()
                    }
                }
                .frame(height: 20)
                .onChange(of: vm.selectedFile, perform: { file in
                    scrollReader.scrollTo(file, anchor: nil)
                })
                .padding()
            }
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView(vm: AssessmentViewModel())
    }
}
