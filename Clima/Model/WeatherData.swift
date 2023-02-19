//
//  WeatherData.swift
//  Clima
//
//  Created by Juan Antonio Ortega Budia on 11/04/22.

import Foundation

struct WeatherData: Decodable {
    
    let name: String
    let main: Main
    let weather: [Weather]

}

struct Main: Decodable {
    
    let temp: Double
    
}

struct Weather: Decodable {
    
    let description: String
    let id: Int
    
}
