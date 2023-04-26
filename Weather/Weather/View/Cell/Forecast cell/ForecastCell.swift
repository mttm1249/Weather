//
//  ForecastCell.swift
//  Weather
//
//  Created by mttm on 25.04.2023.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    static let reuseIdentifier = "ForecastCell"
    
    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    @IBOutlet weak var forecastDateLabel: UILabel!
    @IBOutlet weak var forecastDayLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!

    func configure(_ model: Forecast) {
        forecastDateLabel.text = Time.formatDateString(model.date, outputStringFormat: "d MMMM")
        forecastDayLabel.text = Time.formatDateString(model.date, outputStringFormat: "EEEE")

        if let tempAvg = model.parts.day.tempAvg {
            let sign = tempAvg > 0 ? "+" : "-"
            dayTempLabel.text = "\(sign)\(tempAvg)°"
        }
        if let tempAvg = model.parts.night.tempAvg {
            let sign = tempAvg > 0 ? "+" : "-"
            nightTempLabel.text = "\(sign)\(tempAvg)°"
        }
    }
    
    func configureImage(_ model: Condition) {
        iconImage.image = IconManager.getIcon(model)
    }
}
