//
//  PathStringExtension.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 18.10.23.
//

import Foundation

extension String {
    /// Treats this string as a path and removes the leading slash if it exists.
    func removeLeadingSlashIfExists() -> String {
        if self.first == "/" {
            return String(self.dropFirst())
        }
        return self
    }
    
    /// Treats this string as a path and appends a leading slash if it missing.
    func appendingLeadingSlashIfMissing() -> String {
        if let firstChar = self.first, firstChar != "/" {
            return "/" + self
        }
        return self
    }
}
