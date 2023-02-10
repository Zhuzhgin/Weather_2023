//
//  CityInfoVC.swift
//  Weather_2023
//
//  Created by Artem Zhuzhgin on 08.01.2023.
//

import UIKit

class CityInfoVC: UIViewController {
   
    private let city: City
    
    var fullInfoCollection: UICollectionView!
    
    let activityIndicator = UIActivityIndicatorView()
    
    let weatherInfoLabel = UILabel()
    
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
        
        navigationItem.title = "\(city.cityName.rawValue)"
        setLabel()
        setCollection()
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
    
    private func setCollection() {
        fullInfoCollection = UICollectionView(frame: .zero, collectionViewLayout: createCompozitionLayout())
        
        fullInfoCollection.register(WeatherCell.self, forCellWithReuseIdentifier: "weatherCell")
        fullInfoCollection.collectionViewLayout = createCompozitionLayout()
        fullInfoCollection.dataSource = self
        fullInfoCollection.delegate = self
        fullInfoCollection.backgroundColor = .green
//        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.interSectionSpacing = 5
//        config.interSectionSpacing = 5
//
       // fullInfoCollection.isScrollEnabled = false
        fullInfoCollection.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fullInfoCollection)
        
    }
    
    private func createCompozitionLayout() -> UICollectionViewLayout {
        
        let itemsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.49), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemsize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
       
        let groupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.49))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize, subitems: [item])
       // group.interItemSpacing = .fixed(0)
        let section = NSCollectionLayoutSection(group: group)
       //section.interGroupSpacing = 100
        let layout = UICollectionViewCompositionalLayout(section: section)
    
        return layout
        
    }
   
    private func setLabel() {
        view.addSubview(weatherInfoLabel)
        weatherInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherInfoLabel.text = """
            current temp - \(city.currentWeather?.current.temp_c ?? 00) \n
            wind speed - \(String(describing: city.currentWeather?.current.wind_kph)) MPH

            """
        
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
        }
        
    }
    
    private func setShowButton(){
        view.addSubview(showHistoryButton)
        showHistoryButton.translatesAutoresizingMaskIntoConstraints = false
        showHistoryButton.setTitle("Show History", for: .normal)
        showHistoryButton.addTarget(self, action: #selector(showButtonPressed), for: .touchUpInside)
        showHistoryButton.backgroundColor = .brown
        showHistoryButton.tintColor = .white
        showHistoryButton.layer.cornerRadius = 10
        
       
        
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
        let allInsetsHeight = CGFloat(20 * 5)
        let fullSafeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height - allInsetsHeight
        let photoViewHeight = fullSafeAreaHeight / 2
        let infoCollectionHeight = fullSafeAreaHeight / 4
        let buttonHeight = fullSafeAreaHeight / 16
        
        NSLayoutConstraint.activate([
           
            fullInfoCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            fullInfoCollection.heightAnchor.constraint(equalToConstant: infoCollectionHeight),
            fullInfoCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fullInfoCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cityPhotoView.heightAnchor.constraint(equalToConstant: photoViewHeight),
            cityPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cityPhotoView.topAnchor.constraint(equalTo: fullInfoCollection.bottomAnchor, constant: 5),
           
            activityIndicator.centerXAnchor.constraint(equalTo: cityPhotoView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: cityPhotoView.centerYAnchor),
            
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            showHistoryButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
            showHistoryButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            showHistoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            showHistoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        
        ])
        
        
    }

}

extension CityInfoVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCell
        cell.backgroundColor = .secondarySystemBackground
        print(indexPath.item)
        switch indexPath.item {
        case 0 :
            cell.header.text = "Temperature, C"
            cell.mainLabel.text = String(city.currentWeather?.current.temp_c ?? 0)
        case 1:
            cell.header.text = "Pressure"
            cell.mainLabel.text = String(city.currentWeather?.current.pressure_mb ?? 0)
        case 2:
            
            cell.header.text = "Wind direction"
            cell.mainLabel.text = city.currentWeather?.current.wind_dir

        default:
            cell.header.text = "Wind speed"
            cell.mainLabel.text = "\(city.currentWeather?.current.wind_kph ?? 0 ) kph"

        }
        return cell
    }
    
   
    
    
}
