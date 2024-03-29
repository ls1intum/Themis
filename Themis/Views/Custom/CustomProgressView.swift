//
//  CustomProgressView.swift
//  Themis
//
//  Created by Andreas Cselovszky on 10.01.23.
//

import SwiftUI

struct CustomProgressView: View {

    let progress: Double
    let max: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.themisSecondary.opacity(0.5),
                    lineWidth: 5
                )
            Circle()
                .trim(from: 0, to: progress / max)
                .stroke(
                    Color.themisSecondary,
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: progress)
        }
        .frame(width: 20)
    }
}
