//
//  AddPlayerVC.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 26.08.2021.
//

import UIKit

class AddPlayerVC: UIViewController {
    
    private var dataHolder = DataClass.sharedInstance().playersArray
    weak var delegate: NewGameVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backGroundColor")
        
        settViews()
        configurationViews()
        addButton.onOffButton(enable: false)
    }
    
    //create textField Player Name
    private let playerNameTF: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(named: "elementBackgroundColor")
        textField.textColor = .white
        textField.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 20)
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.608, green: 0.608, blue: 0.631, alpha: 1),
            NSAttributedString.Key.font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 20)
        ]
        textField.attributedPlaceholder = NSAttributedString(
            string: "Player Name",
            attributes: attributes as [NSAttributedString.Key : Any]
        )
        textField.setLeftPaddingPoints(24)
        return textField
    }()
    
    //create addlButton
    private let addButton = UIButton(type: .system).createBarButton(
        title: "Add",
        font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!
    )
    
    private func settViews() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        //create cancelButton
        let backButton = UIButton(type: .system).createBarButton(
            title: "Back",
            font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!
        )
        
        self.view.addSubview(backButton)
        
        backButton.anchor(
            top: safeArea.topAnchor,
            leading: safeArea.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: UIEdgeInsets(top: 6, left: 20, bottom: 0, right: 0)
        )
        
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
        
        addPlayerLabel.anchor(
            top: backButton.bottomAnchor,
            leading: safeArea.leadingAnchor,
            bottom: nil,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 12, left: 20, bottom: 0, right: 20)
        )
        
        self.view.addSubview(addButton)
        
        addButton.anchor(
            top: safeArea.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 25)
        )
        
        //config textField Player Name
        self.view.addSubview(playerNameTF)
        
        playerNameTF.anchor(
            top: addPlayerLabel.bottomAnchor,
            leading: safeArea.leadingAnchor,
            bottom: nil,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0),
            size: CGSize(width: 0, height: 60)
        )
    }
    
    private func configurationViews() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addButtonTapped() {
        let newPlayer = playerNameTF.text!
        delegate?.dataHolder.append(Player(name: newPlayer, score: 0, select: dataHolder.count == 0))
        delegate?.refreshConstraint()
        delegate?.playersTableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
}
