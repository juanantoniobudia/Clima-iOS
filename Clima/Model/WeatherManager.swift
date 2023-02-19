//
//  WeatherManager.swift
//  Clima
//
//  Created by Juan Antonio Ortega Budia on 11/04/22.


import Foundation
import CoreLocation

//protocolo delegado o metodo que voy a ejecutar al instanciar mi clase
protocol WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: Weathermodel)
    func didFailWithError(error: Error)
    
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ec46f9c2091c99b72708f63d0843ce0b&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather (cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude :CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String){
        //1 create a url
        if let url = URL(string: urlString) {
            //2 create a URLSession
            let session = URLSession(configuration: .default)
            //3 Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
               
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.paseJson(safeData){
                        
                        //ejecuto el metodo de la vista principal con el  el objeto tipo weather que me devuelve la funcion parseJson. He creado un protocolo delegado con el metodo didUpdateWeather al que paso mi objeto weather cada vez que se actualice
                        self.delegate?.didUpdateWeather(self ,weather: weather)
                        
                    }

                }
            }
            //4 Start the task
            task.resume()
            
            
        }
    }
    
    func paseJson(_ weatherData: Data) -> Weathermodel?{
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = Weathermodel(conditionID: id, cityName: name, temperature: temp)
           
            return weather
           
            
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        
        
    }
    
    
    
    
    
}
