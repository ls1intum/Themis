//
//  ProblemStatementView.swift
//  feedback2go
//
//  Created by Florian Huber on 13.11.22.
//

import SwiftUI
import Foundation

struct ProblemStatementCellView: View {
    var body: some View {
        VStack {
            /*ForEach(ProblemStatementCellViewModel.splitString(ProblemStatementCellViewModel.mockData), id: \.self) { line in
                Text(line)
            }*/
            Text(ProblemStatementCellViewModel.convertString(ProblemStatementCellViewModel.mockData))
        }
    }
}

struct ProblemStatementCellView_Previews: PreviewProvider {
    static var previews: some View {
        ProblemStatementCellView()
    }
}
