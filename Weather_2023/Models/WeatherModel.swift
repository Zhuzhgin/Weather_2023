//
//  WeatherModel.swift
//  Weather_2023
//
//  Created by Artem Zhuzhgin on 07.01.2023.
//

import Foundation
import UIKit

struct Weather: Decodable {
    let location: Location
    let current: Current
    
}
    struct Location: Decodable {
    let name: String
    let region : String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime_epoch: Int
    let localtime: String
}
    
struct Current: Decodable {
    let last_updated_epoch: Int
    let last_updated: String
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: Condition
    
    let wind_mph: Double
    let wind_kph: Double
    let wind_degree: Int
    let wind_dir: String
    let pressure_mb: Double
    let pressure_in: Double
    let precip_mm: Double
    let precip_in: Double
    let humidity: Int
    let cloud: Int
    let feelslike_c:Double
    let feelslike_f: Double
    let vis_km: Double
    let vis_miles:Double
    let uv: Double
    let gust_mph: Double
    let gust_kph: Double
}
struct Condition: Decodable {
    let text: String
    let icon: String
    let code: Int
}
