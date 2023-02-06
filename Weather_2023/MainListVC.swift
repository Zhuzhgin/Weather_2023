//
//  MainListVC.swift
//  Weather_2023
//
//  Created by Artem Zhuzhgin on 07.01.2023.
//

import UIKit


class MainListVC: UIViewController {
    
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
        navigationController?.navigationBar.backgroundColor = .blue
        navigationController?.navigationBar.topItem?.title = "Cities Current Temperature"
        navigationController?.navigationBar.largeContentTitle = "AAA"
        
        setupWeatherCollection()
      
    }
    
    @objc func refresh() {
        weatherColection.reloadData()
        myRefreshControl.endRefreshing()
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
     
        cityInfoVC.cityName.text = " City: \(cities[indexPath.item].cityName.rawValue) "
      
      
        navigationController?.pushViewController(cityInfoVC, animated: true)
      //  present(cityInfoVC, animated: true, completion: nil)
       cityInfoVC.modalPresentationStyle = .fullScreen
    }
    
}

