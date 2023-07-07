//
//  ModelingAssessmentView.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 05.07.23.
//

import SwiftUI

import SharedModels

struct ModelingAssessmentView: View {
    var body: some View {
        UMLRenderer(modelString: (Submission.mockModeling.baseSubmission as? ModelingSubmission)?.model ?? "nil")
            .task {
//                assessmentVM.participationId = participationId
//                await assessmentVM.initSubmission()
            }
    }
}

struct ModelingAssessmentView_Previews: PreviewProvider {
    static var previews: some View {
        ModelingAssessmentView()
    }
}
