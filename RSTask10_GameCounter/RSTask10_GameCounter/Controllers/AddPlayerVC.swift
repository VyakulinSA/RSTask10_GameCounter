//
//  AddPlayerVC.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 26.08.2021.
//

import UIKit

class AddPlayerVC: UIViewController {
    
    private var dataHolder = DataClass.sharedInstance().playersArray
    var delegate: NewGameVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backGround")
        
        settViews()
        addButton.onOffButton(enable: false)
    }
    
    //create textField Player Name
    private let playerNameTF: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(named: "elemBack")
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
    
    //create addlButton
    private let addButton = UIButton(type: .system).createBarButton(title: "Add", font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!)
    
    private func settViews(){
        let safeArea = self.view.safeAreaLayoutGuide
        
        //create cancelButton
        let backButton = UIButton(type: .system).createBarButton(title: "Back", font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!)
        
        self.view.addSubview(backButton)
        
        backButton.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 6, left: 20, bottom: 0, right: 0))
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
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
        
        
        //config addlButton
//        addButton.isEnabled = false
        self.view.addSubview(addButton)
        
        addButton.anchor(top: safeArea.topAnchor, leading: nil, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 25))
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        //config textField Player Name
        self.view.addSubview(playerNameTF)
        
        playerNameTF.anchor(top: addPlayerLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 60))
        
        playerNameTF.becomeFirstResponder()
        playerNameTF.delegate = self
        
        playerNameTF.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)

    }
}


extension AddPlayerVC: UITextFieldDelegate{
    
    @objc func textFieldChange() {
        if playerNameTF.text?.isEmpty == false{
            addButton.onOffButton(enable: true)
        }else {
            addButton.onOffButton(enable: false)
        }
    }
}

extension AddPlayerVC {
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonTapped() {
        let newPlayer = playerNameTF.text!
        DataClass.sharedInstance().playersArray.append(Player(name: newPlayer, score: 0))
        delegate?.settDataHolder()
        delegate?.playersTableView.reloadData()
        dismiss(animated: true, completion: nil)
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
