//
//  AddPlayerVC.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 26.08.2021.
//

import UIKit

class AddPlayerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        self.settViews()
        
    }
    
    private func settViews(){
        let safeArea = self.view.safeAreaLayoutGuide
        
        //create cancelButton
        let backButton = UIButton(type: .system).createBarButton(title: "Back", font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!)
        
        self.view.addSubview(backButton)
        
        backButton.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 6, left: 20, bottom: 0, right: 0))
        
        //create label
        let addPlayerLabel: UILabel = {
            let label = UILabel()
            label.text = "Add Player"
            label.textColor = .white
            label.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 36)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.view.addSubview(addPlayerLabel)
        
        addPlayerLabel.anchor(top: backButton.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 20, bottom: 0, right: 20))
        
        
        //create addlButton
        let addButton = UIButton(type: .system).createBarButton(title: "Add", font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!)
        
        self.view.addSubview(addButton)
        
        addButton.anchor(top: safeArea.topAnchor, leading: nil, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 25))
        
        //create textField Player Name
        let playerNameTF: UITextField = {
            let textField = UITextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.backgroundColor = UIColor(named: "elemBack")
//            textField.textColor = UIColor(red: 0.608, green: 0.608, blue: 0.631, alpha: 1)
            textField.textColor = .white
            textField.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 20)
            //FIXME: прочитать про настройку PlaceHolder
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor(red: 0.608, green: 0.608, blue: 0.631, alpha: 1),
                NSAttributedString.Key.font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 20)
            ]
            textField.attributedPlaceholder = NSAttributedString(string: "Player Name", attributes: attributes as [NSAttributedString.Key : Any])
            textField.setLeftPaddingPoints(24)
            
            return textField
        }()
        
        self.view.addSubview(playerNameTF)
        
        playerNameTF.anchor(top: addPlayerLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 60))
        
        
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
//        let tabBarVC = AddPlayerVC()
//        //меняем input параметры в соответствии с образцом
//        @available(iOS 13.0, *)
//        func makeUIViewController(context: UIViewControllerRepresentableContext<PeopleVСProvider.ContainerView>) -> AddPlayerVC {
//            return tabBarVC
//        }
//        //не пишем никакого кода
//        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        }
//    }
//}
