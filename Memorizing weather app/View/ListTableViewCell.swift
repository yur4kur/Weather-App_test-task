//
//  ListTableViewCell.swift
//  Memorizing weather app
//
//  Created by Юрий Куринной on 05.11.2022.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    
    func configure(_ city: SavedCities) {
        cityLabel.text = city.savedCity
    }

}
