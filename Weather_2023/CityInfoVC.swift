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
    
    let cityName = UILabel(frame: CGRect(x: 50, y: 50, width: 300, height: 100))
    
    var cityPhotoView  = UIImageView()
    
    var cityPhoto = UIImage()
    {
        didSet {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            cityPhotoView.image = cityPhoto
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(cityName)
        setupActivityIndicator()
        setupPhotoImageView()
        
        setConnstraints()
       
    }
    
    init(city: City) {
        
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let url = city.imageUrl
        
        NetworkManager.shared.fetchPhoto(url: url) { (result) in
            switch result {
            
            case .success(let photo):
                self.cityPhoto = photo
            case .failure(let error):
                print(error)
            }
        }
    }
   
    private func setConnstraints() {

        NSLayoutConstraint.activate([
            cityPhotoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cityPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cityPhotoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            activityIndicator.centerXAnchor.constraint(equalTo: cityPhotoView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: cityPhotoView.centerYAnchor)
        
        ])
        
        
    }

}
