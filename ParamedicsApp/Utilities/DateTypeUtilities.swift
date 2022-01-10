//
//  DateTypeHandler.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-01.
//

import Foundation

class DateTimeUtilities {
    static func stringToDate(inputString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let newDate = dateFormatter.date(from: inputString)
        return newDate
    }
    
    static func dateFormatter(inputDate: String) -> String {
        let oldDateFormatter = DateFormatter()
        oldDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let oldDate = oldDateFormatter.date(from: inputDate)
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "dd MMM yyyy"
        guard let oldDate = oldDate else {
            return ""
        }
 
        return convertDateFormatter.string(from: oldDate)
    }
    
    static func getCurrentDateTime() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.string(from: today)
    }
}
