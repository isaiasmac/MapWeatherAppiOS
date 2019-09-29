//
//  ViewController.swift
//  MapWeatherApp
//
//  Created by Isaías López on 9/27/19.
//  Copyright © 2019 Isaías López. All rights reserved.
//

import UIKit
import GoogleMaps


class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipProbabilityLabel: UILabel!
    @IBOutlet weak var precipTypeLabel: UILabel!
    
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    
    let locationManager = CLLocationManager()
    var isWeatherInfoShow = false {
        didSet {
            if isWeatherInfoShow {
                self.headerViewTopConstraint.constant = 0
                showAnimation()
            }
            else {
                self.headerViewTopConstraint.constant = -190.0
                showAnimation()
            }
        }
    }
    
    var currentLocation: CLLocation? = nil {
        didSet {
            self.mapView.camera = GMSCameraPosition(target: currentLocation!.coordinate,
                                                    zoom: AppConstants.DEFAULT_ZOOM_LEVEL,
                                                    bearing: 0,
                                                    viewingAngle: 0)
            self.reverseGeocode(location: currentLocation!)
            self.getWeatherInformation(location: currentLocation!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.428616, longitude: -70.609782, zoom: 6.0)
        self.mapView.camera = camera
        self.mapView.animate(to: camera)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleWeatherServiceFailed),
                                               name: NSNotification.Name(rawValue: AppKeys.WEATHER_SERVICE_FAILED),
                                               object: nil)
    }
    
    deinit {
        self.locationManager.delegate = nil
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: AppKeys.WEATHER_SERVICE_FAILED), object: self)
    }
    
    @objc func infoButtonAction(_ sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                self.showAlert()
                return
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                self.isWeatherInfoShow = true
            @unknown default:
                fatalError("Error desconocido.")
            }
        }
        else {
            self.showAlert()
            return
        }
    }
    
    @objc func handleWeatherServiceFailed() {
        let alert = UIAlertController(title: "Error",
                                      message: "Ha ocurrido un error al solicitar la información, intentalo de nuevo más tarde.",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func configUI() {
        mapView.settings.myLocationButton = false
        
        self.summaryLabel.text = "--"
        self.tempLabel.text = "--"
        
        self.headerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.headerView.layer.shadowOpacity = 1
        self.headerView.layer.shadowColor = UIColor.gray.cgColor
        
        infoButton.backgroundColor = UIColor.white
        infoButton.layer.cornerRadius = 50.0/2.0
        infoButton.layer.masksToBounds = true
        
        self.infoButton.addTarget(self, action: #selector(infoButtonAction(_:)), for: UIControl.Event.touchUpInside)
    }
    
    private func getWeatherInformation(location: CLLocation) {
        WeatherService.getInfo(lat: location.coordinate.latitude, lng: location.coordinate.longitude) { (status, weather) in
            if status {
                if let weatherData = weather {
                    self.summaryLabel.text = weatherData.summary
                    self.tempLabel.text = "\(weatherData.getTemperature())º"
                    self.precipProbabilityLabel.text = "\(weatherData.getPrecipProbability())%"
                    self.humidityLabel.text = "\(weatherData.getHumidity())%"
                    self.iconImageView.image = UIImage(named: weatherData.icon)
                    if let precipType = weatherData.precipType {
                        self.precipTypeLabel.text = precipType
                    }
                    
                }
            }
        }
    }
    
    private func reverseGeocode(location: CLLocation) {
        print("\(#function) location => \(location)")
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarkers, error) in
            if let locality = placemarkers?.first?.locality {
                DispatchQueue.main.async {
                    self.navigationItem.title = locality
                }
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Servicio de Localización",
                                      message: "No tienes activado o autorizado la Localización en tu dispositivo, activalo en Configuración para continuar",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Continuar", style: .default, handler: { (action) in
            if let appSettings =  URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func showAnimation() {
        UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: Location Manager
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(#function) locations")
        
        if let l = locations.first {
            self.currentLocation = l
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(#function) error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("\(#function) status")
        
        guard status == .authorizedWhenInUse else {
            print("\(#function) STATUS NOT ALLOW")
            //self.showAlert()
            return
        }
        
        mapView.isMyLocationEnabled = true
    }

}
