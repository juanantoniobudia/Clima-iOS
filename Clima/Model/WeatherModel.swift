//
//  WeatherModel.swift
//  Clima
//
//  Created by Juan Antonio Ortega Budia on 11/04/22.


import Foundation

struct Weathermodel {
    
    let conditionID: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var contitionName: String {
        switch conditionID {
        case 200...232:
                return "cloud.bolt"
        case 300...321:
                return "cloud.drizzle"
        case 500...531:
                return "cloud.rain"
        case 600...622:
                return "cloud.bolt"
        case 701...781:
                return "cloud.fog"
        case 800:
                return "sun.max"
        case 800...804:
                return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    
    
}
