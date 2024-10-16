//
//  DateHelper.swift
//  MacroProject
//
//  Created by Ages on 15/10/24.
//

import Foundation

struct DateHelper {
    static func formattedDateString(from date: Date = Date(), style: DateFormatter.Style = .full) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: date)
    }
}
