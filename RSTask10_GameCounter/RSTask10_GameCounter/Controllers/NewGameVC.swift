//
//  NewGameVC.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 25.08.2021.
//

import Foundation
import UIKit

class NewGameVC: UIViewController {
    
    private let startButtonHeight: CGFloat = 65
    private let tableRowHeight: CGFloat = 41
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private let dataShared = DataClass.sharedInstance()
    
    var dataHolder: [Player]!
    
    let defaults = UserDefaults.standard
    
    weak var gameProcessDelegate: GameProcessVC?
    weak var resultDelegate: ResultsVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backGroundColor")
        dataHolder = dataShared.playersArray
        settViews()
        configurationViews()
    }
    
    //MARK: create cancelButton
    let cancelButton = UIButton(type: .system).createBarButton(
        title: "Cancel",
        font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!)
    
    
    lazy var playersTableView = with(UITableView()) {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 15
        $0.backgroundColor = UIColor(named: "elementBackgroundColor")
        $0.isEditing = true
        $0.alwaysBounceVertical = false
        $0.delegate = self
        $0.dataSource = self
    }
    
    //MARK: create startGameButton
    private let startGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start game", for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 24)!
        
        button.titleLabel?.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.titleLabel?.layer.shadowRadius = 0
        button.titleLabel?.layer.shadowOpacity = 1.0
        
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "buttonColor")
        
        button.layer.shadowColor = UIColor(named: "shadowColor")?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 0
        button.layer.shadowOpacity = 1.0
        
        return button
    }()
    
    private func configurationViews() {
        cancelButton.isHidden = !defaults.bool(forKey: "firstLaunch")
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        startGameButton.layer.cornerRadius = startButtonHeight / 2
        startGameButton.onOffButton(enable: dataHolder.count != 0)
        startGameButton.addTarget(self, action: #selector(startGameButtonTapped), for: .touchUpInside)
    }
    
    //MARK: settViews
    func settViews() {
        let safeArea = self.view.safeAreaLayoutGuide
        //MARK: config cancelButton
        self.view.addSubview(cancelButton)
        
        cancelButton.anchor(
            top: safeArea.topAnchor,
            leading: safeArea.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: UIEdgeInsets(top: 6, left: 20, bottom: 0, right: 0)
        )
        
        //MARK: config gameCounterLabel
        let gameCounterLabel: UILabel = {
            let label = UILabel()
            label.text = "Game Counter"
            label.textColor = .white
            label.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 36)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.view.addSubview(gameCounterLabel)
        
        gameCounterLabel.anchor(
            top: cancelButton.bottomAnchor,
            leading: safeArea.leadingAnchor,
            bottom: nil,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 12, left: 20, bottom: 0, right: 20)
        )
        
        //MARK: config startGameButton
        self.view.addSubview(startGameButton)
        
        startGameButton.anchor(
            top: nil,
            leading: safeArea.leadingAnchor,
            bottom: self.view.bottomAnchor,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 20, bottom: 65, right: 20),
            size: CGSize(width: 0, height: startButtonHeight)
        )
        
        //MARK: config tableView with players
        self.view.addSubview(playersTableView)
        
        playersTableView.anchor(
            top: gameCounterLabel.bottomAnchor,
            leading: safeArea.leadingAnchor,
            bottom: nil,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 25, left: 20, bottom: 0, right: 20)
        )
        
        //MARK: tableViewHeight
        tableViewHeightConstraint = playersTableView.heightAnchor
            .constraint(lessThanOrEqualToConstant: 120 + tableRowHeight * CGFloat(dataHolder.count))
        tableViewHeightConstraint?.isActive = true
        
        let bottomConstraint = playersTableView .bottomAnchor.constraint(equalTo: startGameButton.topAnchor, constant: -25)
        bottomConstraint.priority = UILayoutPriority(rawValue: 249)
        bottomConstraint.isActive = true
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension NewGameVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableRowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHolder.count
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = dataHolder[sourceIndexPath.row]
        dataHolder.remove(at: sourceIndexPath.row)
        dataHolder.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //MARK: config cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell = configCell(cellForConfig: cell)
        cell.textLabel?.text = dataHolder[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            dataHolder.remove(at: indexPath.row)
            refreshConstraint()
            tableView.deleteRows(at: [indexPath], with: .left)
        default:
            return
        }
    }
}

//MARK: config headerView and footerView
extension NewGameVC{
    //config headerView
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "elementBackgroundColor")
        let playerLabel: UILabel = {
            let label = UILabel()
            label.text = "Players"
            label.font = UIFont(name: CustomFonts.nunitoSemiBold.rawValue, size: 16)
            label.textColor = UIColor(red: 0.922, green: 0.922, blue: 0.961, alpha: 0.6)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        headerView.addSubview(playerLabel)
        
        playerLabel.anchor(
            top: headerView.topAnchor,
            leading: headerView.leadingAnchor,
            bottom: nil,
            trailing: headerView.trailingAnchor,
            padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: -16))
        
        return headerView
    }
    
    //config footerView
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor(named: "elementBackgroundColor")
        
        footerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addButtonTapped)))
        
        let addButton = UIButton(type: .system).createEllipseButton(
            title: "+",
            font: UIFont(name: "Nunito-ExtraBold", size: 17)!,
            radius: 11, shadow: false)
        
        addButton.isUserInteractionEnabled = false
        
        footerView.addSubview(addButton)
        
        addButton.anchor(
            top: footerView.topAnchor,
            leading: footerView.leadingAnchor,
            bottom: footerView.bottomAnchor,
            trailing: nil,
            padding: UIEdgeInsets(top: 14, left: 22, bottom: 15, right: 0),
            size: CGSize(width: 22, height: 0)
        )
        
        let playerLabel: UILabel = {
            let label = UILabel()
            label.text = "Add player"
            label.font = UIFont(name: CustomFonts.nunitoSemiBold.rawValue, size: 16)
            label.textColor = UIColor(named: "buttonColor")
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        footerView.addSubview(playerLabel)
        
        playerLabel.anchor(
            top: footerView.topAnchor,
            leading: addButton.trailingAnchor,
            bottom: footerView.bottomAnchor,
            trailing: footerView.trailingAnchor,
            padding: UIEdgeInsets(top: 14, left: 15, bottom: 15, right: -29)
        )
        
        return footerView
    }
}

//MARK: Target
extension NewGameVC{
    
    @objc func addButtonTapped() {
        let addPlayerVC = AddPlayerVC()
        addPlayerVC.delegate = self
        addPlayerVC.modalPresentationStyle = .pageSheet
        self.navigationController?.setViewControllers([self,addPlayerVC], animated: true)
    }
    
    @objc func startGameButtonTapped() {
        let halpersClass = UserDefaultsManager()
        
        settParamsForNewGame()
        halpersClass.saveDataInUserDefaults(valueForStartBackground: nil)
        defaults.setValue(true, forKey: "firstLaunch")
        
        refreshConstraint()
        
        if resultDelegate != nil {
            gameProcessDelegate = resultDelegate?.gameDelegate
        }
        
        if gameProcessDelegate != nil {
            gameProcessDelegate?.timer()
            gameProcessDelegate?.settDataFromGame()
            gameProcessDelegate?.settLetterStackView(withRefresh: true)
            gameProcessDelegate?.gamerCollectionView.reloadData()
            self.dismiss(animated: true, completion: nil)
        } else {
            let gameProcessVC = GameProcessVC()
            gameProcessVC.modalPresentationStyle = .fullScreen
            dismiss(animated: true, completion: nil)
            present(gameProcessVC, animated: true, completion: nil)
        }
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: Halpers func
extension NewGameVC {
    
    func refreshConstraint() {
        tableViewHeightConstraint?.constant = 120 + tableRowHeight * CGFloat(dataHolder.count)
        startGameButton.onOffButton(enable: dataHolder.count != 0)
    }
    
    private func configCell(cellForConfig: UITableViewCell) -> UITableViewCell{
        let cell = cellForConfig
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: "elementBackgroundColor")
        
        cell.textLabel?.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 20)
        cell.textLabel?.textColor = .white
        //FIXME: change image on code
        let sortIcon = UIImageView(image: UIImage(named: "icon_Sort"))
        sortIcon.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(sortIcon)
        
        NSLayoutConstraint.activate([
            sortIcon.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -15),
            sortIcon.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
        
        let seporator = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width - 16, height: 1))
        seporator.backgroundColor = UIColor(named: "seporatorColor")
        seporator.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(seporator)
        
        seporator.anchor(
            top: nil,
            leading: cell.leadingAnchor,
            bottom: cell.bottomAnchor,
            trailing: cell.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0),
            size: CGSize(width: 0, height: 1)
        )
        
        return cell
    }
    
    private func settParamsForNewGame() {
        dataShared.playersArray = dataHolder
        dataShared.gameTime = GameTime(minute: 0, second: 0)
        dataShared.turnsArray = [Turn]()
        dataShared.timerPlay = true
        
        for i in 0..<dataShared.playersArray.count{
            dataShared.playersArray[i].score = 0
        }
    }
}
