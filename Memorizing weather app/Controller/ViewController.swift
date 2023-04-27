//
//  ViewController.swift
//  Memorizing weather app
//
//  Created by Юрий Куринной on 03.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var searchCityTextfield: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var feelsTempLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    
    @IBOutlet weak var forecastTableView: UITableView! {
        didSet {
            forecastTableView.delegate = self
            forecastTableView.dataSource = self
            forecastTableView.backgroundColor = .clear
            
            let nib = UINib(nibName: "ForecastTableViewCell", bundle: nil)
            forecastTableView.register(nib, forCellReuseIdentifier: "forecastXibCell")
        }
    }
    
    var forecastLines: [ForecastModel.List]? {
        didSet {
            DispatchQueue.main.async {
                self.forecastTableView.reloadData()
                self.showHiddenObjects()
            }
        }
    }
    
    let dateFormatter = DateFormatter()
    
    private var userLocation: String?
    
    private var citiesList: [SavedCities] = SavedCities.load() {
        didSet {
            SavedCities.save(citiesList)
        }
    }
    
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityNameLabel.isHidden = true
        currentTempLabel.isHidden = true
        feelsTempLabel.isHidden = true
        currentWeatherLabel.isHidden = true
        forecastTableView.isHidden = true
        
        searchCityTextfield.delegate = self
        
        dateFormatter.dateFormat = "E, hh:mm a"
        
    }

    @IBAction func didTapSaveCity(_ sender: UIButton) {
        guard let text = searchCityTextfield.text, !text.isEmpty else { return }
        let city = SavedCities(savedCity: text)
        citiesList = SavedCities.load()
        citiesList.append(city)
    }
    
    @IBAction func didTapLoadCity(_ sender: UIButton) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SavedCitiesIdentifier") as? SavedCitiesTableViewController {
            SavedCitiesTableViewController.delegate = self
            self.present(vc, animated: true)
        }
    }
    
    private func showHiddenObjects() {
        cityNameLabel.isHidden = false
        currentTempLabel.isHidden = false
        feelsTempLabel.isHidden = false
        currentWeatherLabel.isHidden = false
        forecastTableView.isHidden = false
    }
}


// MARK: - TextField Delegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (searchCityTextfield.text != nil) {
        userLocation = searchCityTextfield.text
            fetchData()
        }
       return true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Signing for delegate to use protocol method and get data from another VC
extension ViewController: SavedCitiesTableViewControllerDelegate {
    
    func updateCity(city: SavedCities) {
        userLocation = city.savedCity
        fetchData()
    }
}

// MARK: - Table delegates
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = forecastLines else { return 10 }
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = forecastTableView.dequeueReusableCell(withIdentifier: "forecastXibCell", for: indexPath) as! ForecastTableViewCell
        guard let list = forecastLines?[indexPath.row] else { return UITableViewCell() }
        cell.dateLabel.text = dateFormatter.string(from: list.dt)
        cell.weatherIcon.image = UIImage(named: list.weather[0].icon)
        cell.maxTempLabel.text = "↑ " + Int(list.main.temp_max ).description + "°"
        cell.minTempLabel.text = "↓ " + Int(list.main.temp_min ).description + "°"
        return cell
    }
}

// MARK: Extension for fetching data through Network Manager
extension ViewController {
    
    private func fetchData() {
        networkManager.getWeather(for: userLocation ?? "") { WeatherModel in
            DispatchQueue.main.async {
                self.cityNameLabel.text = WeatherModel.name
                self.currentWeatherLabel.text = WeatherModel.weather[0].description.capitalized
                self.currentTempLabel.text = Int(WeatherModel.main.temp).description + "°"
                self.feelsTempLabel.text = "Feels: " + Int(WeatherModel.main.feels_like).description  + "°"
            }
        }
        
        networkManager.getForecast(for: userLocation ?? "") { ForecastModel in
            DispatchQueue.main.async {
                self.forecastLines = ForecastModel.list
            }
        }
    }
}
