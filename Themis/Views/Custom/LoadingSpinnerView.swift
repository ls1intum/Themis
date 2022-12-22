//
//  LoadingSpinnerView.swift
//  Themis
//
//  Created by Andreas Cselovszky on 22.12.22.
//

import SwiftUI

struct LoadingSpinnerView: View {
    var duration: Double = 0.7 // per spin
    var lineWidth: Double = 8
    @State var spinnerStart = 0.0
    @State var spinnerEnd = 0.03
    @State var currDegree = Angle.degrees(540)

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.secondary.opacity(0.5),
                    lineWidth: lineWidth
                )
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(
                    Color.secondary,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(currDegree)
        }
        .frame(width: 20)
        .onAppear {
            withAnimation(.linear(duration: duration)
                .repeatForever(autoreverses: false)
            ) {
                currDegree += .degrees(360)
            }
        }
    }
}

struct LoadingSpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSpinnerView()
    }
}
