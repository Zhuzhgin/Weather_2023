//
//  CityInfoVC.swift
//  Weather_2023
//
//  Created by Artem Zhuzhgin on 08.01.2023.
//

import UIKit

class CityInfoVC: UIViewController {
   
    private let city: City

    var aaa: String!
    
    let cityName = UILabel(frame: CGRect(x: 10, y: 10, width: 300, height: 100))
    
    let cityPhoto = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(cityName)
        setupPhotoImage()
        
     
        setConnstraints()
       
    }
    
    init(city: City) {
        
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func setupPhotoImage() {
     
        view.addSubview(cityPhoto)
        cityPhoto.translatesAutoresizingMaskIntoConstraints = false

        
//        guard let cityItem = city else {
//            print("!!!Error")
//            return
//        }
        let url = city.imageUrl
        print(url)
        
        
       
        NetworkManager.shared.fetchPhoto(url: url) { (result) in
            switch result {
            
            case .success(let photo):
                self.cityPhoto.image = photo
            case .failure(let error):
                print(error)
            }
        }
        
    }
   
    private func setConnstraints() {
        
        NSLayoutConstraint.activate([
            cityPhoto.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cityPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityPhoto.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cityPhoto.topAnchor.constraint(equalTo: view.topAnchor, constant: 200)
        
        ])
        
        
    }

}
