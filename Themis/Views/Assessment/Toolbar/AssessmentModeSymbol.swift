//
//  AssessmentModeSymbol.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 07.05.23.
//

import SwiftUI

struct AssessmentModeSymbol: View {
    var exerciseTitle: String?
    var readOnly: Bool
    
    var body: some View {
        HStack(alignment: .center) {
            Text(exerciseTitle ?? "")
                .bold()
                .font(.title)
            Image(systemName: readOnly ? "eyeglasses" : "pencil.and.outline")
                .font(.title3)
        }
        .foregroundColor(.white)
    }
}

struct AssessmentModeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentModeSymbol(readOnly: false)
    }
}
