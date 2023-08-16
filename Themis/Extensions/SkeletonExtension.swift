//
//  SkeletonExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 13.08.23.
//

import SwiftUI
import Shimmer

extension View {
    /// Applies `.placeholder` redaction, a shimmer animation, and disables the view if the `condition` is true
    @ViewBuilder
    func showsSkeleton(if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? .placeholder : [])
            .shimmering(active: condition(), duration: 1.2)
            .disabled(condition())
    }
    
    /// Replaces the current view with the given `skeletonView`, applies `.placeholder` redaction, a shimmer animation, and disables the view if the `condition` is true
    @ViewBuilder
    func shows(_ skeletonView: some View, if condition: @autoclosure () -> Bool) -> some View {
        if condition() {
            skeletonView
                .redacted(reason: condition() ? .placeholder : [])
                .shimmering(active: condition(), duration: 1.2)
                .disabled(condition())
        } else {
            self
        }
    }
}

extension String {
    static func placeholder(lengthRange: ClosedRange<Int> = 1...10) -> String {
        let length = Int.random(in: lengthRange)
        return String(Array(repeating: "X", count: length))
    }
}
