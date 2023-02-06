//
//  CityInfoVC.swift
//  Weather_2023
//
//  Created by Artem Zhuzhgin on 08.01.2023.
//

import UIKit

class CityInfoVC: UIViewController {
   
    private let city: City
    

    let activityIndicator = UIActivityIndicatorView()
    
    let cityName = UILabel(frame: CGRect(x: 50, y: 100, width: 300, height: 100))
    
    var cityPhotoView  = UIImageView()
    
    let saveButton = UIButton()
    
    let showHistoryButton = UIButton()
    
    var cityPhoto = UIImage()
    
    {
        didSet {
            //if oldValue == UIImage(named: "Image") {
            //activityIndicator.stopAnimating()
            
            cityPhotoView.image = cityPhoto
            //}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.addSubview(cityName)
        setSaveButton()
        setupPhotoImageView()
        setShowButton()
        setConnstraints()
       
    }
    
    init(city: City) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSaveButton() {
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.tintColor = .red
        saveButton.backgroundColor = .blue
        
       
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
    }
    
    @objc func saveButtonPressed() {
        let currentData = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Moscow")
        let temperature = String(city.currentWeather?.current.temp_c ?? 0)
        
        CoreDataManager.shared.saveWeather(cityName: city.currentWeather?.location.name ?? "nemoCity", date: currentData, temperature: temperature ) { (weather) in
          //  print("savedDate: City Name  - \(weather.name!), date - \(weather.date!), temp - \(weather.temperature!)")
        }
      //  print(currentData)
        
    }
    
    private func setShowButton(){
        view.addSubview(showHistoryButton)
        showHistoryButton.translatesAutoresizingMaskIntoConstraints = false
        showHistoryButton.setTitle("Show History", for: .normal)
        showHistoryButton.addTarget(self, action: #selector(showButtonPressed), for: .touchUpInside)
        showHistoryButton.backgroundColor = .brown
        showHistoryButton.tintColor = .white
        
       
        
    }
    
    @objc func showButtonPressed () {
        CoreDataManager.shared.fetchData { (weathers) in
            var cityWeatherHistory: [WeatherHistory] = []
            for weather in weathers {
                if weather.name == city.currentWeather?.location.name {
                    cityWeatherHistory.append(weather)

                    print("\(weather.name ?? "no data"), date: \(weather.date ?? Date() ), weather: \(weather.temperature ?? "no data")")
                }
                //CoreDataManager.shared.deleteWeatherHistory(weather: weather)
            }
            let historyVC = TemperatureHicstoryVC(cityWeatherHistory: cityWeatherHistory)
            
            navigationController?.pushViewController(historyVC, animated: true)
           
        }
        
    }
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        
        activityIndicator.color = .black
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
     func setupPhotoImageView() {
     
        view.addSubview(cityPhotoView)
        cityPhotoView.translatesAutoresizingMaskIntoConstraints = false
        cityPhotoView.contentMode = .scaleAspectFit
        cityPhotoView.image = UIImage(named: "Image")
        setupActivityIndicator()

        let url = city.imageUrl
        NetworkManager.shared.fetchPhoto(url: url) { (result) in
            switch result {
            
            case .success(let photo):
                self.cityPhoto = photo
              
                //self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
   
    private func setConnstraints() {

        NSLayoutConstraint.activate([
            cityPhotoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            cityPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cityPhotoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
           
            activityIndicator.centerXAnchor.constraint(equalTo: cityPhotoView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: cityPhotoView.centerYAnchor),
            
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            saveButton.topAnchor.constraint(equalTo: view.bottomAnchor,constant: -80),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            showHistoryButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10),
            showHistoryButton.topAnchor.constraint(equalTo: cityPhotoView.bottomAnchor, constant: 50),
            showHistoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showHistoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        
        ])
        
        
    }

}
