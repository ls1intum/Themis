//
//  ScorePicker.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 19.04.23.
//

import SwiftUI

struct ScorePicker: View {
    @Binding var score: Double
    
    let maxScore = Double(10)
    
    var pickerRange: [Double] {
        Array(stride(from: -1 * maxScore, to: maxScore + 0.5, by: 0.5))
            .sorted { $0 > $1 }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("SCORE")
                .font(.subheadline)
                .bold()
                .foregroundColor(.secondary)
                .padding(.top)
            
            Picker("Score", selection: $score) {
                ForEach(pickerRange, id: \.self) { number in
                    if number < 0.0 {
                        Text(String(format: "%.1f", number)).foregroundColor(.red)
                    } else if number > 0.0 {
                        Text(String(format: "%.1f", number)).foregroundColor(.green)
                    } else {
                        Text(String(format: "%.1f", number))
                    }
                }
            }
            .pickerStyle(.wheel)
        }
        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.primary.opacity(0.02)))
    }
}

struct ScorePicker_Previews: PreviewProvider {
    static var previews: some View {
        ScorePicker(score: .constant(0.0))
    }
}
