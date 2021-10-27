//
//  GameCollectionViewCell.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 28.08.2021.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    var multiplicator: CGFloat = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "elementBackgroundColor")
        settViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor(named: "elementBackgroundColor")
        settViews()
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "playerNameColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func settViews() {
        
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            scoreLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func settLabels(name: String, score: Int) {
        self.nameLabel.text = name
        self.scoreLabel.text = String(score)
        self.nameLabel.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 28 * multiplicator)
        self.scoreLabel.font = UIFont(name: CustomFonts.nunitoBold.rawValue, size: 100 * multiplicator)
    }
}
