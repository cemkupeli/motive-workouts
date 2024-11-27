//
//  DateService.swift
//  Motive
//
//  Created by Cem Kupeli on 11/27/24.
//

import Foundation

class DateService {
    static private let calendar = Calendar.current
        
    static private let compressedDateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter
    }()
    
    static func compressedDate(from date: Date) -> String {
        return DateService.compressedDateFormatter.string(from: date)
    }
}
