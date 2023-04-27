//
//  SavedCitiesTableViewController.swift
//  Memorizing weather app
//
//  Created by Юрий Куринной on 05.11.2022.
//

import UIKit

// MARK: - Delegate protocol to pass chosen city to ViewController
protocol SavedCitiesTableViewControllerDelegate: AnyObject {
    func updateCity(city: SavedCities)
}

class SavedCitiesTableViewController: UITableViewController {

    @IBOutlet var savedCitiesTableView: UITableView!
   
    // Creating delegate to be reachable from ViewController
   static weak var delegate: SavedCitiesTableViewControllerDelegate?
    
    private var citiesList: [SavedCities] = SavedCities.load() {
        didSet {
            SavedCities.save(citiesList)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        cell.configure(citiesList[indexPath.row])
        return cell
    }
    
    // MARK: - Cell selection methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Creating property to reach chosen cell & using protocol method on that cell
        let city = citiesList[indexPath.row]
        SavedCitiesTableViewController.delegate?.updateCity(city: city)
        self.dismiss(animated: true)
    }
    
    // MARK: - Cell delete method.
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            citiesList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
