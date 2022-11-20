//
//  CorrectionGuidelinesView.swift
//  feedback2go
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI

struct CorrectionGuidelinesCellView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Correction Guidelines")
                    .font(.largeTitle)

                Text("Test")

                Spacer()
            }

            Spacer()
        }.padding()
    }
}

struct CorrectionGuidelinesCellView_Previews: PreviewProvider {
    static var previews: some View {
        CorrectionGuidelinesCellView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
