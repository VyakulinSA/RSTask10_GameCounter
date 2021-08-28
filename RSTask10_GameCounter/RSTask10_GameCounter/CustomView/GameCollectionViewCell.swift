//
//  GameCollectionViewCell.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 28.08.2021.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "elemBack")
        settViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor(named: "elemBack")
        settViews()
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "nameColor")
        label.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.nunitoBold.rawValue, size: 100)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func settViews(){
        
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
    
    func settLabels(name: String, score: Int){
        self.nameLabel.text = name
        self.scoreLabel.text = String(score)
    }
    
}

////MARK: SwiftUI
////Импортируем SwiftUI библиотеку
//import SwiftUI
////создаем структуру
//struct PeopleVСProvider: PreviewProvider {
//    @available(iOS 13.0.0, *)
//    static var previews: some View {
//        ContainerView().edgesIgnoringSafeArea(.all)
//    }
//
//    @available(iOS 13.0, *)
//    struct ContainerView: UIViewControllerRepresentable {
//        //создадим объект класса, который хотим показывать в Canvas
//        let tabBarVC = GameProcessVC()
//        //меняем input параметры в соответствии с образцом
//        @available(iOS 13.0, *)
//        func makeUIViewController(context: UIViewControllerRepresentableContext<PeopleVСProvider.ContainerView>) -> GameProcessVC {
//            return tabBarVC
//        }
//        //не пишем никакого кода
//        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        }
//    }
//}