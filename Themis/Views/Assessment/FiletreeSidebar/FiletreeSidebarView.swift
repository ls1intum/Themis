import SwiftUI
import SharedModels
import DesignLibrary

struct FiletreeSidebarView: View {
    @ObservedObject var cvm: CodeEditorViewModel
    @ObservedObject var assessmentVM: AssessmentViewModel
    @State private var repositorySelection = RepositoryType.student
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Filetree")
                .font(.title)
                .bold()
                .padding(.leading, 18)
            
            showWarningIfNeeded()
            
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
            
            Spacer()
            
            repositoryPicker
        }
        .onChange(of: repositorySelection) { handleRepositoryChange($1) }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 35)
        .background(Color("sidebarBackground"))
        .animation(.easeInOut(duration: 0.2), value: repositorySelection)
        .shows(FiletreeSkeleton(), if: assessmentVM.loading || cvm.isLoading)
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
        .bold(file == cvm.selectedFile)
        .background(file == cvm.selectedFile ? Color("selectedFileBackground") : Color("sidebarBackground"))
        .cornerRadius(10)
    }
    
    @ViewBuilder
    private func showWarningIfNeeded() -> some View {
        if repositorySelection != .student && !assessmentVM.readOnly {
            ArtemisHintBox(text: "Some functionality may be limited while viewing this repository")
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var repositoryPicker: some View {
        Menu {
            Picker(selection: $repositorySelection,
                   label: EmptyView(),
                   content: {
                ForEach(RepositoryType.allCases, id: \.self) { repoType in
                    Text("\(repoType.rawValue) Repository")
                        .tag(repoType)
                }
            })
            .pickerStyle(.automatic)
            .accentColor(.white)
        } label: {
            HStack(spacing: 5) {
                Text("\(repositorySelection.rawValue) Repository")
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 10, height: 7)
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .accentColor(.themisSecondary)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.themisSecondary, lineWidth: 1)
            }
            .padding(.horizontal)
        }
    }
    
    private func openFile(_ file: Node) {
        guard
            let programmingAssessmentVM = assessmentVM as? ProgrammingAssessmentViewModel,
            let participationId = programmingAssessmentVM.participationId(for: repositorySelection) else {
            return
        }
        
        let templateParticipationId = assessmentVM.participation?.getExercise(as: ProgrammingExercise.self)?.templateParticipation?.id
        
        cvm.openFile(file: file,
                     participationId: participationId,
                     templateParticipationId: templateParticipationId
        )
    }
    
    private func handleRepositoryChange(_ newRepositoryType: RepositoryType) {
        if let participationId = assessmentVM.participation?.getId(for: newRepositoryType) {
            Task {
                await cvm.initFileTree(participationId: participationId, repositoryType: newRepositoryType, shouldSetLoading: false)
                if newRepositoryType == .student {
                    await cvm.loadInlineHighlightsIfEmpty(assessmentResult: assessmentVM.assessmentResult,
                                                          participationId: participationId)
                } else {
                    assessmentVM.pencilModeDisabled = true
                }
            }
        }
    }
}

struct FiletreeSidebarView_Previews: PreviewProvider {
    private static var codeVM = CodeEditorViewModel()
    private static var assessmentVM = AssessmentViewModel(exercise: .mockText, readOnly: false)
    
    static var previews: some View {
        FiletreeSidebarView(cvm: codeVM,
                            assessmentVM: assessmentVM)
    }
}
