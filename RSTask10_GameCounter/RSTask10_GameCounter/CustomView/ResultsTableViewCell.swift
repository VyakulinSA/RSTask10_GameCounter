//
//  ResultsTableViewCell.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 29.08.2021.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        settViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let addScoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 20)
        label.textColor = .white
        return label
    }()
    
    private func settViews(){
        
        self.backgroundColor = UIColor(named: "elemBack")
        self.textLabel?.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 20)
        self.textLabel?.textColor = .white
        
        
        let seporator = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width - 16, height: 1))
        seporator.backgroundColor = UIColor(named: "seporator")
        seporator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(seporator)
        
        seporator.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0), size: CGSize(width: 0, height: 1))
        
        self.addSubview(addScoreLabel)
        NSLayoutConstraint.activate([
            addScoreLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addScoreLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
    }
    
    func settScore(name: String, score: Int){
        self.textLabel?.text = name
        addScoreLabel.text = "\(score)"
    }
    
    

}
