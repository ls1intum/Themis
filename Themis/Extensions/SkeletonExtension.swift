//
//  SkeletonExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 13.08.23.
//

import SwiftUI
import Shimmer

extension View {
    @ViewBuilder
    func showsSkeleton(if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? .placeholder : [])
            .shimmering(active: condition(), duration: 1.2)
            .disabled(condition())
    }
}
