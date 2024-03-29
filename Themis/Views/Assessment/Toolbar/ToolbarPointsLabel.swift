//
//  ToolbarPointsLabel.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI
import SharedModels

struct ToolbarPointsLabel: View {
    @ObservedObject var assessmentResult: AssessmentResult
    var submission: BaseSubmission?
    
    var body: some View {
        Group {
            if let submission {
                if (submission as? ProgrammingSubmission)?.buildFailed == true {
                    Text("Build failed")
                        .foregroundColor(.red)
                } else {
                    Text(generatePointProgressInfo())
                        .foregroundColor(.white)
                }
            }
        }
        .fontWeight(.semibold)
        .background(Color.themisPrimary)
    }
    
    private func generatePointProgressInfo() -> String {
        """
        \(Double(round(10 * assessmentResult.points) / 10).formatted(FloatingPointFormatStyle()))/\
        \((assessmentResult.maxPoints).formatted(FloatingPointFormatStyle()))
        """
    }
}

// struct PointsLabel_Previews: PreviewProvider {
//    static var previews: some View {
//        PointsLabel(assessmentVM: AssessmentViewModel(readOnly: false))
//    }
// }
