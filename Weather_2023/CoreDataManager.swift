//
//  CoreDataManager.swift
//  Weather_2023
//
//  Created by Artem Zhuzhgin on 23.01.2023.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
     static var shared = CoreDataManager()
    private var context : NSManagedObjectContext
   
    private init() {
        context = peristentConteiner.viewContext
    }

    
   private var peristentConteiner: NSPersistentContainer = {
        let conteiner = NSPersistentContainer(name: "Weather_2023")
        conteiner.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo) ")
            }
        }
        
        return conteiner
        
    }()
    
    func deleteWeatherHistory(weather: WeatherHistory){
        
        context.delete(weather)
        saveContext()
    }
    
    func saveWeather(cityName: String, date: Date, temperature: String, complition: (WeatherHistory) -> Void) {
        
        let weatherHistory = WeatherHistory(context: context)
        weatherHistory.date = date
        weatherHistory.temperature = temperature
        weatherHistory.name = cityName
        saveContext()
        complition(weatherHistory)
    }
    
    func fetchData(complition: (_ weatherSaveList: [WeatherHistory]) -> Void) {
        let request: NSFetchRequest<WeatherHistory> = WeatherHistory.fetchRequest()
        do {
            let weatherHistory = try context.fetch(request)
            complition(weatherHistory)
        } catch {
            print ("Error")
            
        }
    }
    
    func saveContext() {
        if context.hasChanges {
        do {
            try context.save()
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        }
    }
    
}

