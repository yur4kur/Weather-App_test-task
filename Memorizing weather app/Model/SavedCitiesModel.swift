//
//  SavedCitiesModel.swift
//  Memorizing weather app
//
//  Created by Юрий Куринной on 03.11.2022.
//

import Foundation

class SavedCities: Codable {
    
    var savedCity: String?
    
    init (savedCity: String) {
        self.savedCity = savedCity
    }
}

// MARK: - Encode & Decode User Citites
extension SavedCities {
    
    static let userDefaultsKey = "SavedCitiesKey"
    
    static func save(_ savedCity: [SavedCities]) {
        let data = try? JSONEncoder().encode(savedCity)
        UserDefaults.standard.set(data, forKey: SavedCities.userDefaultsKey)
    }
    
    static func load() -> [SavedCities] {
        var returnList: [SavedCities] = []
        if let data = UserDefaults.standard.data(forKey: SavedCities.userDefaultsKey),
           let savedCities = try? JSONDecoder().decode([SavedCities].self, from: data) {
            returnList = savedCities
        }
        return returnList
    }    
}
