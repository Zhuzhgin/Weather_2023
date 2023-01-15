//
//  CityWeatherCell.swift
//  Weather_2023
//
//  Created by Artem Zhuzhgin on 07.01.2023.
//

import UIKit

class CityWeatherCell: UICollectionViewCell {
    
    static var reuseID = "cityCell"
    let cityPhoto = UIImageView()
    let cityName = UILabel()
    let temperature = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
        setupPhoto()
        setConstreints()
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        contentView.backgroundColor = .brown
        
    }
        

        
        required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
    func setupPhoto() {
        contentView.addSubview(cityPhoto)
        cityPhoto.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setupLabel() {
        contentView.addSubview(cityName)
        contentView.addSubview(temperature)
        cityName.translatesAutoresizingMaskIntoConstraints = false
        temperature.translatesAutoresizingMaskIntoConstraints = false
    }

    func setConstreints() {
        
        NSLayoutConstraint.activate([
            cityName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cityName.centerYAnchor.constraint(equalTo: centerYAnchor),
            temperature.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            temperature.centerYAnchor.constraint(equalTo: centerYAnchor),
            cityPhoto.trailingAnchor.constraint(equalTo: temperature.leadingAnchor, constant: -5),
            cityPhoto.topAnchor.constraint(equalTo: contentView.topAnchor),
            cityPhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cityPhoto.widthAnchor.constraint(equalTo: contentView.heightAnchor)
            
        ])
        
        
        
    }
}
