

//  Created by Juan Antonio Ortega Budia on 11/04/22.

import CoreLocation
import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()//pido permiso para location manager
        
        //en info.plist agrego el mensaje que quiero que me muestre en tres propiedades
        self.locationManager.requestLocation()
        
        
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        
    }

    @IBAction func locationPressed(_ sender: UIButton) {
        
        self.locationManager.requestLocation()
        
    }
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)//oculta teclado y activa los metodos de su protocolo delegado
        
        print(searchTextField.text!)
        
    }
    
}

//MARK: - UITextFieldDelegate
//protocolo delegado del campo de texto
extension WeatherViewController: UITextFieldDelegate{
    //cuando doy al botón return del teclado
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchTextField.endEditing(true)//oculta teclado
        print(searchTextField.text!)
        return true
        
    }
    
    //me dejaría finalizar la edicion cuando devuelva true
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if searchTextField.text != ""{
            return true
        } else {
            searchTextField.placeholder = "Type something"
            return false
        }
    }
    
    //cuando dejo de editar el campo de texto  almaceno la información y limpia el contenido del mismo
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = textField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
    
}
//MARK: - WeatherManagerDelegate

//protocolo delegado que defino en WeatherManager
extension WeatherViewController: WeatherManagerDelegate {
    
    
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: Weathermodel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.contitionName)
            self.cityLabel.text = weather.cityName
            
        }
       
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let safelocation = locations.last{
            //cuando encuentra una ubicacion paramos la actualizacion del location manager que podemos volver a activar cuando pulsemos el botón de localizacíon
            locationManager.stopUpdatingLocation()
            let lat = safelocation.coordinate.latitude
            let lon = safelocation.coordinate.longitude
            
            print(lat)
            print(lon)
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            
        }
    
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
