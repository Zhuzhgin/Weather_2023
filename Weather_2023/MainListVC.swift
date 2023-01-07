//
//  MainListVC.swift
//  Weather_2023
//
//  Created by Artem Zhuzhgin on 07.01.2023.
//

import UIKit

class MainListVC: UIViewController {

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
        30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityWeatherCell.reuseID, for: indexPath) as! CityWeatherCell
        
        cell.cityName.text = String(indexPath.item)
        cell.temperature.text = "-25 C"
        return cell
    }
      
    
    
}
