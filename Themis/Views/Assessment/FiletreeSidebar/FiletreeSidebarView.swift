import SwiftUI
import SharedModels

struct FiletreeSidebarView: View {
    @ObservedObject var cvm: CodeEditorViewModel
    @ObservedObject var assessmentVM: AssessmentViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Filetree")
                .font(.title)
                .bold()
                .padding(.leading, 18)
            if !assessmentVM.loading {
                List {
                    OutlineGroup(cvm.fileTree, id: \.path, children: \.children) { tree in
                        if tree.type == .folder {
                            nodeFolderView(folder: tree)
                        } else {
                            nodeFileView(file: tree)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color("sidebarBackground"))
                }
                .listStyle(.inset)
                .background(Color("sidebarBackground"))
                .scrollContentBackground(.hidden)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 35)
        .background(Color("sidebarBackground"))
    }
    
    @ViewBuilder
    func nodeFolderView(folder: Node) -> some View {
        HStack {
            Image(systemName: "folder")
            Text(folder.name)
        }
    }
    
    @ViewBuilder
    func nodeFileView(file: Node) -> some View {
        Button {
            withAnimation {
                openFile(file)
            }
        } label: {
            FileView(file: file)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .bold(file === cvm.selectedFile)
        .background(file === cvm.selectedFile ? Color("selectedFileBackground") : Color("sidebarBackground"))
        .cornerRadius(10)
    }
    
    private func openFile(_ file: Node) {
        guard let participationId = assessmentVM.participation?.id,
              let templateParticipationId = assessmentVM.participation?.getExercise(as: ProgrammingExercise.self)?.templateParticipation?.id
        else {
            return
        }
        
        cvm.openFile(file: file,
                     participationId: participationId,
                     templateParticipationId: templateParticipationId
        )
    }
}
