//
//  TemperatureHicstoryVC.swift
//  Weather_2023
//
//  Created by Artem Zhuzhgin on 29.01.2023.
//

import UIKit

class TemperatureHicstoryVC: UITableViewController {

    var cityWeatherHisory: [WeatherHistory]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tempCell")
        

    }
    
    init(cityWeatherHistory: [WeatherHistory]) {
        self.cityWeatherHisory = cityWeatherHistory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return cityWeatherHisory.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tempCell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        let date = cityWeatherHisory[indexPath.row].date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let strDate = dateFormatter.string(from: date!)
        
        content.text = strDate
        
        content.prefersSideBySideTextAndSecondaryText = true
        content.secondaryText = cityWeatherHisory[indexPath.row].temperature
        cell.contentConfiguration = content

        return cell
    }
    

    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { _,_,comletion in
            
            
            CoreDataManager.shared.deleteWeatherHistory(weather: self.cityWeatherHisory[indexPath.row])
            self.cityWeatherHisory.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            print("delete weather history")
            comletion(true)
            tableView.reloadData()
            
        }
       
       
        return UISwipeActionsConfiguration(actions: [action])
    }

}
