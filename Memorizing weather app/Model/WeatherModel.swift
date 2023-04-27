//
//  WeatherModel.swift
//  Memorizing weather app
//
//  Created by Юрий Куринной on 25.01.2023.
//

import Foundation

struct WeatherModel: Codable {
    struct Weather: Codable {
        var description: String = ""
        var icon: String = ""
    }
    var weather: [Weather] = []
    struct Main: Codable {
        var temp: Double = 0.0
        var feels_like: Double = 0.0
    }
    var main: Main = Main()
    var name: String = ""
}
