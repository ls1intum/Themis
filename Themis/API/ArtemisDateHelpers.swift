//
//  ArtemisDateHelpers.swift
//  Themis
//
//  Created by Paul Schwind on 23.01.23.
//

import Foundation

enum ArtemisDateHelpers {
    private static var artemisDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }

    static func parseDate(_ dateString: String?) -> Date? {
        guard let dateString else {
            return nil
        }
        return artemisDateFormatter.date(from: dateString)
    }
    
    static func stringifyDate(_ date: Date?) -> String? {
        guard let date else {
            return nil
        }
        return artemisDateFormatter.string(from: date)
    }

    static func getReadableDateString(_ dateString: String?) -> String? {
        guard let date = parseDate(dateString) else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    static func getReadableDateStringDetailed(_ dateString: String?) -> String? {
        guard let dateString else {
            return nil
        }
        
        let customDateFormatter = DateFormatter()
        customDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = customDateFormatter.date(from: dateString) else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
}
