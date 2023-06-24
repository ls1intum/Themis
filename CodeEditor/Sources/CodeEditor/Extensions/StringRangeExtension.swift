//
//  StringRangeExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 24.06.23.
//

import Foundation

extension String {
    func hasRange(_ range: NSRange) -> Bool {
        return Range(range, in: self) != nil
    }
}
