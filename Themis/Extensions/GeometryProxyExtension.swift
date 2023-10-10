//
//  GeometryProxyExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 28.09.23.
//

import SwiftUI

extension GeometryProxy {
    /// Returns the length of the smallest side
    var minSide: CGFloat {
        min(size.width, size.height)
    }
}
