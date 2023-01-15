//
//  CityModel.swift
//  Weather_2023
//
//  Created by Artem Zhuzhgin on 12.01.2023.
//

import Foundation
import UIKit

let weatherWebURL = "http://api.weatherapi.com/v1/current.json?key=5aa2adb334244f9692653450220611&q="
enum Cities: String {
    case Tyumen = "Tyumen"
    case moscow = "Moscow"
    case ekat = "Ekaterinburg"
    case ufa = "Ufa"
    case tbilisi = "Tbilisi"
    case sheregesh = "Sheregesh"
    case mineralVodi = "mineral"
    case erevan = "Erevan"
    case antalya = "Antalya"
    case bangkok = "Bangkok"
    case istambul = "Istambul"
}
struct City {
    var cityName: Cities
    var imageUrl: String
    var weatherURL: String
    
    static func getCities() -> [City] {
        return [
            City(
                cityName: .Tyumen,
                imageUrl:  "https://tripplanet.ru/wp-content/uploads/europe/russia/tyumen/dostoprimechatelnosti-tjumeni.jpg",
                weatherURL: weatherWebURL + Cities.Tyumen.rawValue),
            City(
                cityName: .antalya,
                imageUrl: "https://russo-travel.ru/upload/medialibrary/62f/62f83d046ef40d009c39f07c119ef301.jpg",
                weatherURL: weatherWebURL + Cities.antalya.rawValue),
           City(cityName: .ekat, imageUrl: "https://wikiway.com/upload/iblock/ed1/Gorodskoy-prud-Ekaterinburga.jpg", weatherURL: weatherWebURL + Cities.ekat.rawValue),
            City(cityName: .erevan, imageUrl: "https://www.tripzaza.com/ru/destinations/wp-content/uploads/2018/07/Dostoprimechatelnosti-Erevana-e1531302765198.jpg", weatherURL: weatherWebURL + Cities.erevan.rawValue),
            City(cityName: .mineralVodi, imageUrl: "https://gkd.ru/assets/i/ai/4/1/3/i/2757363.jpg", weatherURL: weatherWebURL + Cities.mineralVodi.rawValue),
            City(cityName: .moscow, imageUrl: "https://upload.wikimedia.org/wikipedia/commons/0/01/Moscow_July_2011-16.jpg", weatherURL: weatherWebURL + Cities.moscow.rawValue),
            City(cityName: .sheregesh, imageUrl: "https://sheregesh-hotels.ru/assets/gallery/431/7151.jpg", weatherURL: weatherWebURL + Cities.sheregesh.rawValue),
            City(cityName: .tbilisi, imageUrl: "https://lebristolgeorgia.ru/wp-content/uploads/2017/03/%D0%A2%D0%B1%D0%B8%D0%BB%D0%B8%D1%81%D0%B8-1.jpg", weatherURL: weatherWebURL + Cities.tbilisi.rawValue),
            City(cityName: .ufa, imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Belaya_River%2C_Ufa-5.jpg/300px-Belaya_River%2C_Ufa-5.jpg", weatherURL: weatherWebURL + Cities.ufa.rawValue),
            City(cityName: .bangkok, imageUrl: "https://cdn2.tu-tu.ru/image/pagetree_node_data/6/c2db5cad56372bee03c2ce6ea19c09b1/", weatherURL: weatherWebURL + Cities.bangkok.rawValue)
        ]
        
        
        
    }
}
