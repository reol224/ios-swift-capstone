//
//  weather.swift
//  ios_capstone
//
//  Created by Jack on 2022/8/13.
//

import Foundation

//Initializing the variables with types
struct WeatherData:Codable {
        let base: String
        let visibility: Int
        let dt: Int
    let weather: [Weather]
        let main: Main
        let timezone, id: Int
        let name: String
        let cod: Int
}
//Initializing variables to fetch data
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}
//variables to fetch from
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
