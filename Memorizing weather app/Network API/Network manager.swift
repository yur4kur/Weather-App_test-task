//
//  Network manager.swift
//  Memorizing weather app
//
//  Created by Юрий Куринной on 25.01.2023.
//

import Foundation

class NetworkManager {
    
    enum APIs: String {
        case weather = "weather?q="
        case forecast = "forecast?q="
    }
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/"
    private let keyAndMetrics = "&appid=871486b6e485f1f4b2602c115d27413f&units=metric"
    
    func getWeather(for location: String, _ completion: @escaping (WeatherModel) -> Void) {
        if let url = URL(string: baseURL + APIs.weather.rawValue + location + keyAndMetrics) {
            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error in getting weather: \(error.localizedDescription)")
                }
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    guard let responseData = data else { return }
                    do {
                        let weather = try JSONDecoder().decode(WeatherModel.self, from: responseData)
                        completion(weather)
                    } catch {
                        print("Error in decoding weather data")
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func getForecast(for location: String, _ completion: @escaping (ForecastModel) -> Void) {
        if let url = URL(string: baseURL + APIs.forecast.rawValue + location + keyAndMetrics) {
            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error in getting forecast: \(error.localizedDescription)")
                }
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    guard let responseData = data else { return }
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    do {
                        let forecast = try decoder.decode(ForecastModel.self, from: responseData)
                        completion(forecast)
                    } catch {
                        print("Error in decoding forecast data")
                    }
                }
            }
            dataTask.resume()
        }
    }
}

