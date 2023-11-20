//
//  CollectionExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 18.11.23.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
