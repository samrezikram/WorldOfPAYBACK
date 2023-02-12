//
//  String +Extensions.swift
//  WorldOfPAYBACK
//
//  Created by Samrez Ikram on 10/02/2023.
//

import Foundation

extension String {
    func formatISODate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "your_loc_id")

        if let date = dateFormatter.date(from: self) {
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
            dateFormatter.dateStyle = .long
            return dateFormatter.string(from: date)
        }
        return ""
    }

    func getISODate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return Date()
    }
}

extension Sequence {
    func uniqued<Type: Hashable>(by keyPath: KeyPath<Element, Type>) -> [Element] {
        var set = Set<Type>()
        return filter { set.insert($0[keyPath: keyPath]).inserted }
    }
}
