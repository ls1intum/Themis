//
//  TextExerciseRenderer.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 30.05.23.
//

import SwiftUI
import CodeEditor
import SharedModels

struct TextExerciseRenderer: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var textExerciseRendererVM: TextExerciseRendererViewModel
    
    private let scrollUtils = ScrollUtils(range: nil, offsets: [:])
    
    private var editorFlags: CodeEditor.Flags {
        var flags: CodeEditor.Flags = [.selectable]
//        if !readOnly { flags.insert(.feedbackMode) }
        return flags
    }
    
    private var theme: CodeEditor.ThemeName {
        colorScheme == .dark ? CodeEditor.ThemeName(rawValue: "a11y-dark") : CodeEditor.ThemeName(rawValue: "color-brewer")
    }
    
    private var font: UIFont {
        UIFont.preferredFont(forTextStyle: .body).withSize(textExerciseRendererVM.fontSize)
    }
    
    var body: some View {
        VStack {
            textArea
            
            HStack {
                countLabel(title: "Words", textExerciseRendererVM.wordCount)
                countLabel(title: "Characters", textExerciseRendererVM.charCount)
            }
        }
        .background(Color.themisBackground)
    }
    
    private var textArea: some View {
        UXCodeTextViewRepresentable(
            editorBindings: EditorBindings(
                source: $textExerciseRendererVM.content ?? "Loading...",
                font: font,
                fontSize: $textExerciseRendererVM.fontSize,
                themeName: theme,
                flags: editorFlags,
                highlightedRanges: textExerciseRendererVM.inlineHighlights,
                dragSelection: .constant(nil),
                showAddFeedback: .constant(false),
                showEditFeedback: .constant(false),
                selectedSection: .constant(nil),
                feedbackForSelectionId: .constant(""),
                pencilOnly: $textExerciseRendererVM.pencilMode,
                scrollUtils: scrollUtils,
                diffLines: [],
                isNewFile: false,
                showsLineNumbers: false,
                feedbackSuggestions: [],
                selectedFeedbackSuggestionId: .constant("")
            )
        )
        .padding()
//        .onChange(of: dragSelection) { newValue in
//            if let newValue {
//                onOpenFeedback(newValue)
//            }
//        }
//        .onChange(of: cvm.showAddFeedback) { newValue in
//            if !newValue {
//                dragSelection = nil
//            }
//        }
    }
    
    private func countLabel(title: String, _ count: Int) -> some View {
        Text("\(title): \(count)")
            .padding(.vertical, 5)
            .padding(.horizontal, 8)
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .background {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.Artemis.artemisBlue)
            }
    }
}

struct TextExerciseRenderer_Previews: PreviewProvider {
    @State static var textVM = TextExerciseRendererViewModel()
    
    static var previews: some View {
        TextExerciseRenderer(textExerciseRendererVM: textVM)
            .previewInterfaceOrientation(.landscapeRight)
            .onAppear {
//                textVM.setup(basedOn: Submission.mockText.baseSubmission.participation)
            }
    }
}
