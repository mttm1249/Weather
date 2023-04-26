//
//  WeatherViewController.swift
//  Weather
//
//  Created by mttm on 25.04.2023.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private var activityIndicator = UIActivityIndicatorView()
    private let locationManager = CLLocationManager()
    private let defaultLatitude = 55.755864
    private let defaultLongitude = 37.617698
    private var forecasts: [Forecast] = []
    private var conditions: [Condition] = []
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var currentTempInfoLabel: UILabel!
    @IBOutlet weak var feelsLikeInfoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var conditionImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupBackgroundColor()
        setupTableView()
        setupLocationManager()
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func setupBackgroundColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        let topColor = #colorLiteral(red: 0.8531202674, green: 0.8630762696, blue: 0.9995830655, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.5812642574, green: 0.5959089398, blue: 0.692727685, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ForecastCell", bundle: nil), forCellReuseIdentifier: ForecastCell.reuseIdentifier)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    private func formatTemperature(_ temperature: Double) -> String {
        return (temperature > 0 ? "+" : "") + "\(temperature)°"
    }
    
    private func setupTodayWeatherInfo(from data: WeatherData) {
        locationNameLabel.text = data.geoObject.locality.name
        
        let feelsLikeText = "Ощущается как:"
        currentTempInfoLabel.text = formatTemperature(data.fact.temp)
        feelsLikeInfoLabel.text = "\(feelsLikeText) \(formatTemperature(data.fact.feelsLike))"
        
        guard let icon = conditions.first else { return }
        conditionImage.image = IconManager.getIcon(icon)
    }
    
    private func fetchWeatherData(coordinate: CLLocationCoordinate2D) {
        
        // Start activityIndicator animating
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        WeatherNetworkService.shared.fetchWeatherData(latitude: String(coordinate.latitude), longitude: String(coordinate.longitude)) { result in
            
            // Stop activityIndicator animating
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            
            switch result {
            case .success(let weatherData):
                self.forecasts = weatherData.forecasts
                self.conditions = self.forecasts.map { $0.parts.day.condition }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.setupTodayWeatherInfo(from: weatherData)
                }
            case .failure(let error):
                print("Failed to fetch weather data: \(error)")
            }
        }
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.reuseIdentifier, for: indexPath) as! ForecastCell
        let forecast = forecasts[indexPath.row]
        let condition = conditions[indexPath.row]
        cell.configure(forecast)
        cell.configureImage(condition)
        return cell
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            // Get current location if authorized
            if let location = manager.location {
                fetchWeatherData(coordinate: location.coordinate)
            } else {
                // Use default location if current location is not available
                fetchWeatherData(coordinate: CLLocationCoordinate2D(latitude: defaultLatitude, longitude: defaultLongitude))
            }
        case .denied, .restricted, .notDetermined:
            // Use default location if not authorized
            fetchWeatherData(coordinate: CLLocationCoordinate2D(latitude: defaultLatitude, longitude: defaultLongitude))
        default:
            break
        }
    }
}
