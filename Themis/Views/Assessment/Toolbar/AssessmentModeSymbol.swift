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
    var correctionRound: CorrectionRound
    
    var body: some View {
        HStack(alignment: .center) {
            Text(exerciseTitle ?? "")
                .bold()
                .font(.title)
                .frame(maxWidth: 180)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                
            Image(systemName: readOnly ? "eyeglasses" : "pencil.and.outline")
                .font(.title3)
            
            Text((!readOnly && correctionRound == .second) ? "(Round 2)" : "")
                .bold()
                .font(.title3)
        }
        .foregroundColor(.white)
    }
}

struct AssessmentModeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentModeSymbol(exerciseTitle: "Essay About Your Dream Spaceship", readOnly: false, correctionRound: .second)
            .padding()
            .background(.black)
    }
}
