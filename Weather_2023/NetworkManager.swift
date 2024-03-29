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
    
    let cache = NSCache<NSString, UIImage>()
    
    
    private init () {}
    
    
    func fetchPhoto(url: String, completion: @escaping (Result<UIImage,NetworkError>) -> ()) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidUrl))
            return
        }
        if let photo = cache.object(forKey: url.absoluteString as NSString) {
            completion(.success(photo))
        } else {
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard let data = data else {
                    
                    completion(.failure(.invalidData))
                    return
                }
                
       
                DispatchQueue.main.async {
                    guard let photo = UIImage(data: data) else {
                        completion(.failure(.decodingError))
                        return
                    }
                    self.cache.setObject(photo, forKey: url.absoluteString as NSString)
                    completion(.success(photo))
                }
                
                
            } .resume()
        }
    }
    
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
