//
//  ForecastModel.swift
//  Memorizing weather app
//
//  Created by Юрий Куринной on 25.01.2023.
//

import Foundation

struct ForecastModel: Codable {
    struct List: Codable {
        var dt: Date
        struct Main: Codable {
            var temp_min: Double
            var temp_max: Double
        }
        var main: Main
        struct Weather: Codable {
            var main: String
            var icon: String
        }
        var weather: [Weather]
    }
    var list: [List]
}
