//
//  DateExtensions.swift
//  ImageGallery
//
//  Created by Mohamed Shah on 24/05/20.
//  Copyright © 2020 Mohamed Shah P. All rights reserved.
//

import Foundation

extension Date {
    
    func convertToString() -> String {
        var convertedString = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d' at 'h:mm a"
        dateFormatter.timeZone = NSTimeZone(name: "IST") as TimeZone?
        
        let calendar = Calendar.current
        
        var dateStringToPrefix: String?
        if calendar.isDateInToday(self) {
            dateStringToPrefix = "Today"
        }
        else if calendar.isDateInYesterday(self) {
            dateStringToPrefix = "Yesterday"
        }
        convertedString = dateFormatter.string(from: self)
        
        if let datePrefix = dateStringToPrefix {
            if let endIndex = convertedString.index(of: " at") {
                let dateString = convertedString[..<endIndex]
                convertedString.replaceSubrange(convertedString.range(of: dateString)!, with: datePrefix)
            }
        }
        
        return convertedString
    }
}
