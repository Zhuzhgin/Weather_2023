//
//  WeatherCell.swift
//  Weather_2023
//
//  Created by Artem Zhuzhgin on 08.02.2023.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    static var reuseID = "weatherCell"
    
    let header = UILabel()
    let mainLabel = UILabel()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setHeader()
        setLabel()
        setConstraints()
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHeader() {
        contentView.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setLabel() {
        
        contentView.addSubview(mainLabel)
       // mainLabel.font = .boldSystemFont(ofSize: 30)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.textColor = .black
    }
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            //header.heightAnchor.constraint(equalToConstant: 30),
            header.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            mainLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
          //  mainLabel.heightAnchor.constraint(equalToConstant: 40)
        
        ])
    }

}
