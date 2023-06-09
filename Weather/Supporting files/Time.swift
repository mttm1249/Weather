//
//  Time.swift
//  Weather
//
//  Created by mttm on 25.04.2023.
//

import Foundation

class Time {

    static func formatDateString(_ inputDateString: String, outputStringFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ru_RU")

        guard let date = dateFormatter.date(from: inputDateString) else {
            print("Error: Invalid input date format.")
            return nil
        }
        
        dateFormatter.dateFormat = outputStringFormat
        let formattedDateString = dateFormatter.string(from: date)
        
        return formattedDateString
    }
}
