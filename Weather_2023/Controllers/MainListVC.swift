//
//  MainListVC.swift
//  Weather_2023
//
//  Created by Artem Zhuzhgin on 07.01.2023.
//

import UIKit


class MainListVC: UIViewController {
    
    let weatherWebURL = "http://api.weatherapi.com/v1/current.json?key=5aa2adb334244f9692653450220611&q="
    
    var cities = City.getCities()
    var weatherColection: UICollectionView!
    
    let myRefreshControl: UIRefreshControl = {
        let refreshcontrol = UIRefreshControl()
        refreshcontrol.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshcontrol
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2
        navigationBarSet()
        setupWeatherCollection()
      
    }
    
    private func navigationBarSet() {
        navigationController?.navigationBar.backgroundColor = .blue
        navigationController?.navigationBar.topItem?.title = "Weather"
        navigationController?.navigationBar.largeContentTitle = "AAA"
        let rightBarButton  = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    @objc private func rightButtonTapped() {
       print("Right Button Tapped")
      
        
        alertAddNewCity { (name) in
         
        
            NetworkManager.shared.fetchWeather(url: self.weatherWebURL + name) { (result) in
            switch result {
            
            case .success(let weather):
                print("New weather \(name) - \(weather.current.temp_c) ")
            case .failure(_):
                print("error - wrong cityName")
            }
        }
        }
    }
    
    @objc func refresh() {
        myRefreshControl.endRefreshing()
    }
    
    func alertAddNewCity(complition: @escaping(String) -> Void )  {
        let alert = UIAlertController(title: "Add new city", message: "Enter city name", preferredStyle: .alert)
 
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter city"
           
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            print (alert.textFields?[0].text ?? "unknown city" )
            complition((alert.textFields?[0].text!)!)
        })
        
        alert.addAction(okAction)
        
        
        present(alert, animated: true) 
    }
    
    func setupWeatherCollection() {
        
        weatherColection = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionLayout())
        weatherColection.dataSource = self
        weatherColection.delegate = self
        weatherColection.register(CityWeatherCell.self, forCellWithReuseIdentifier: CityWeatherCell.reuseID)
        weatherColection.backgroundColor = .cyan
        weatherColection.refreshControl = myRefreshControl
        view.addSubview(weatherColection)
    }
    
    private func createCompositionLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      //  item.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      group.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
        
    }
}

extension MainListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityWeatherCell.reuseID, for: indexPath) as! CityWeatherCell
        let city = cities[indexPath.item]
        let cityWeatherUrl = city.weatherURL
        
        NetworkManager.shared.fetchWeather(url: cityWeatherUrl, complition: { (result) in
            
            switch result {
            case .success(let weather):
                self.cities[indexPath.item].currentWeather = weather
                cell.cityName.text = weather.location.name
                cell.temperature.text = String(weather.current.temp_c)
            case .failure(let error):
                
                print(error)
            }
            
        }
        )
//        let cityPhotoUrl = cities[indexPath.item].imageUrl
//
//        NetworkManager.shared.fetchPhoto(url: cityPhotoUrl) { (result) in
//            switch result {
//
//            case .success(let photo):
//                cell.cityPhoto.image = photo
//            case .failure(let error):
//                print(error)
//            }
//        }
//        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cityItem = cities[indexPath.item]

        
        let cityInfoVC = CityInfoVC(city: cityItem)
        cityInfoVC.view.backgroundColor = .lightGray
     
      
      
        navigationController?.pushViewController(cityInfoVC, animated: true)
      //  present(cityInfoVC, animated: true, completion: nil)
       cityInfoVC.modalPresentationStyle = .fullScreen
    }
    
}

