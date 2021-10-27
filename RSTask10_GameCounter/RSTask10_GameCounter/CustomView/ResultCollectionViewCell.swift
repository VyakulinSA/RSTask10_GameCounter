//
//  ResultCollectionViewCell.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 28.08.2021.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        settViews()
    }
    
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.text = "#1"
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = UIColor(named: "playerNameColor")
        label.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "20"
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.nunitoBold.rawValue, size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func settViews() {
        
        contentView.addSubview(positionLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            positionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            positionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: positionLabel.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 10),
            scoreLabel.centerYAnchor.constraint(equalTo: positionLabel.centerYAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func settLabels(position: Int, name: String, score: Int) {
        self.positionLabel.text = "#\(position)"
        self.nameLabel.text = name
        self.scoreLabel.text = String(score)
    }
}
