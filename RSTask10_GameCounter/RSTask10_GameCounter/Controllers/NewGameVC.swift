//
//  NewGameVC.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 25.08.2021.
//

import UIKit

class NewGameVC: UIViewController {
    
    private let startButtonHeight: CGFloat = 65
    private let tableRowHeight: CGFloat = 41
    private var dataHolder = DataClass.sharedInstance().playersArray
    private var tableViewHeightConstraint: NSLayoutConstraint?
    let firstStart = true
    
    //create cancelButton
    let cancelButton = UIButton(type: .system).createBarButton(title: "Cancel", font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!)
    
    //create tableView with players
    lazy var playersTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.cornerRadius = 15
        table.backgroundColor = UIColor(named: "elemBack")
        table.isEditing = true
        table.alwaysBounceVertical = false
        table.delegate = self
        table.dataSource = self
        return table
        
    }()
    
    //create startGameButton
    private let startGameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start game", for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 24)!
        
        button.titleLabel?.layer.shadowColor = UIColor(named: "buttonShadow")?.cgColor
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.titleLabel?.layer.shadowRadius = 0
        button.titleLabel?.layer.shadowOpacity = 1.0
        
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "tintColor")
        
        button.layer.shadowColor = UIColor(named: "buttonShadow")?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 0
        button.layer.shadowOpacity = 1.0
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backGround")
        settViews()
    }
    
    func settViews(){
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(cancelButton)
        
        cancelButton.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 6, left: 20, bottom: 0, right: 0))
        
        cancelButton.isHidden = !firstStart
        
        //create label
        let gameCounterLabel: UILabel = {
            let label = UILabel()
            label.text = "Game Counter"
            label.textColor = .white
            label.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 36)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.view.addSubview(gameCounterLabel)
        
        gameCounterLabel.anchor(top: cancelButton.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 20, bottom: 0, right: 20))
        
        //config startGameButton
        self.view.addSubview(startGameButton)
        
        startGameButton.layer.cornerRadius = startButtonHeight / 2
        startGameButton.onOffButton(enable: dataHolder.count != 0)
        
        startGameButton.anchor(top: nil, leading: safeArea.leadingAnchor, bottom: self.view.bottomAnchor, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 65, right: 20), size: CGSize(width: 0, height: startButtonHeight))
        
        startGameButton.addTarget(self, action: #selector(startGameButtonTapped), for: .touchUpInside)

        //config tableView with players

        self.view.addSubview(playersTableView)
        
        playersTableView.anchor(top: gameCounterLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 25, left: 20, bottom: 0, right: 20))
        
        //MARK: tableViewHeight
        tableViewHeightConstraint = playersTableView.heightAnchor.constraint(lessThanOrEqualToConstant: 120 + tableRowHeight * CGFloat(dataHolder.count))
        tableViewHeightConstraint?.isActive = true
        
        let bottomConstraint = playersTableView .bottomAnchor.constraint(equalTo: startGameButton.topAnchor, constant: -25)
        bottomConstraint.priority = UILayoutPriority(rawValue: 249)
        bottomConstraint.isActive = true
    }
    
    func settDataHolder() {
        dataHolder = DataClass.sharedInstance().playersArray
        tableViewHeightConstraint?.constant = 120 + tableRowHeight * CGFloat(dataHolder.count)
        startGameButton.onOffButton(enable: dataHolder.count != 0)
    }
}

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
        DataClass.sharedInstance().playersArray.remove(at: sourceIndexPath.row)
        DataClass.sharedInstance().playersArray.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //MARK: config cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: "elemBack")
        cell.textLabel?.text = dataHolder[indexPath.row].name
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
        seporator.backgroundColor = UIColor(named: "seporator")
        seporator.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(seporator)
        
        seporator.anchor(top: nil, leading: cell.leadingAnchor, bottom: cell.bottomAnchor, trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0), size: CGSize(width: 0, height: 1))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataClass.sharedInstance().playersArray.remove(at: indexPath.row)
            settDataHolder()
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
        headerView.backgroundColor = UIColor(named: "elemBack")
        let playerLabel: UILabel = {
            let label = UILabel()
            label.text = "Players"
            label.font = UIFont(name: CustomFonts.nunitoSemiBold.rawValue, size: 16)
            label.textColor = UIColor(red: 0.922, green: 0.922, blue: 0.961, alpha: 0.6)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        headerView.addSubview(playerLabel)
        
        playerLabel.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: nil, trailing: headerView.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: -16))
        
        return headerView
    }
    
    //config footerView
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor(named: "elemBack")
        
        let addButton = UIButton(type: .system).createEllipseButton(title: "+", font: UIFont(name: "Nunito-ExtraBold", size: 16)!, radius: 10.5, shadow: false)
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        footerView.addSubview(addButton)
        
        addButton.anchor(top: footerView.topAnchor, leading: footerView.leadingAnchor, bottom: footerView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 14, left: 22, bottom: 15, right: 0), size: CGSize(width: 21, height: 21))
        
        let playerLabel: UILabel = {
            let label = UILabel()
            label.text = "Add player"
            label.font = UIFont(name: CustomFonts.nunitoSemiBold.rawValue, size: 16)
            label.textColor = UIColor(named: "tintColor")
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        footerView.addSubview(playerLabel)
        
        playerLabel.anchor(top: footerView.topAnchor, leading: addButton.trailingAnchor, bottom: footerView.bottomAnchor, trailing: footerView.trailingAnchor, padding: UIEdgeInsets(top: 14, left: 15, bottom: 15, right: -29))
        return footerView
    }
}

//MARK: addTarget func
extension NewGameVC{
    
    @objc func addButtonTapped(){
        let addPlayerVC = AddPlayerVC()
        addPlayerVC.delegate = self
        addPlayerVC.modalPresentationStyle = .pageSheet
        show(addPlayerVC, sender: nil)
    }
    
    @objc func startGameButtonTapped() {
        let gameProcessVC = GameProcessVC()
        gameProcessVC.modalPresentationStyle = .fullScreen
        show(gameProcessVC, sender: nil)
    }
}


//MARK: SwiftUI
//Импортируем SwiftUI библиотеку
import SwiftUI
//создаем структуру
struct PeopleVСProvider: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    @available(iOS 13.0, *)
    struct ContainerView: UIViewControllerRepresentable {
        //создадим объект класса, который хотим показывать в Canvas
        let tabBarVC = NewGameVC()
        //меняем input параметры в соответствии с образцом
        @available(iOS 13.0, *)
        func makeUIViewController(context: UIViewControllerRepresentableContext<PeopleVСProvider.ContainerView>) -> NewGameVC {
            return tabBarVC
        }
        //не пишем никакого кода
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
