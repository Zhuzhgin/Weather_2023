//
//  NetworkManager.swift
//  Weather_2023
//
//  Created by Artem Zhuzhgin on 08.01.2023.
//

import Foundation
import UIKit
enum NetworkError: Error {
    case invalidUrl
    case decodingError
    case invalidData
}


class NetworkManager {
    static var shared = NetworkManager()
    
    private init () {}
    
    func fetchWeather(url: String, complition: @escaping(Result<Weather, NetworkError>)-> Void) {
        
        guard let url = URL(string: url) else {
            complition(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {
                complition(.failure(.invalidData))
                return
            }
            
            DispatchQueue.main.async {
                let weather = try! JSONDecoder().decode(Weather.self, from: data)
             //   print(weather)
                complition(.success(weather))
                
            }
            

            
        }.resume()
    }
    
}
