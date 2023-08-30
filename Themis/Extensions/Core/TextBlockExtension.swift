//
//  TextBlockExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 30.08.23.
//

import Foundation
import SharedModels

extension TextBlock {
    var range: Range<Int>? {
        guard let startIndex, let endIndex else {
            return nil
        }
        return startIndex ..< endIndex
    }
}
