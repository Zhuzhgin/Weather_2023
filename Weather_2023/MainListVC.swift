//
//  MainListVC.swift
//  Weather_2023
//
//  Created by Artem Zhuzhgin on 07.01.2023.
//

import UIKit

//var cities = ["Tyumen", "Moscow", "Ekaterinburg", "Ufa", "Tbilisi", "Sheregesh", "mineral", "Erevan", "Antalya"]



class MainListVC: UIViewController {
    var cities = City.getCities()
    var weatherColection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2
 
        setupWeatherCollection()
    }
    
    
    func setupWeatherCollection() {
        
        weatherColection = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionLayout())
        weatherColection.dataSource = self
        weatherColection.delegate = self
        weatherColection.register(CityWeatherCell.self, forCellWithReuseIdentifier: CityWeatherCell.reuseID)
        weatherColection.backgroundColor = .cyan
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
        let cityWeatherUrl = cities[indexPath.item].weatherURL
        
        NetworkManager.shared.fetchWeather(url: cityWeatherUrl, complition: { (result) in
            
            switch result {
            case .success(let weather):
                cell.cityName.text = weather.location.name
                cell.temperature.text = String(weather.current.temp_c)
            case .failure(let error):
                print(error)
            }
            
        }
        )
        let cityPhotoUrl = cities[indexPath.item].imageUrl
       
        NetworkManager.shared.fetchPhoto(url: cityPhotoUrl) { (result) in
            switch result {
            
            case .success(let photo):
                cell.cityPhoto.image = photo
            case .failure(let error):
                print(error)
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cityItem = cities[indexPath.item]

        let cityInfoVC = CityInfoVC(city: cityItem)
        cityInfoVC.view.backgroundColor = .lightGray
        
        
      
        print(cityItem.cityName.rawValue )
        cityInfoVC.aaa = "BBBBB"
     
        
        
        
        
        cityInfoVC.cityName.text = cities[indexPath.item].cityName.rawValue
      
        present(cityInfoVC, animated: true, completion: nil)
       // cityInfoVC.modalPresentationStyle = .fullScreen
    }
    
}
