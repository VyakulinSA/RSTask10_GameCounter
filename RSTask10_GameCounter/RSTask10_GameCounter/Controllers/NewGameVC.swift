//
//  NewGameVC.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 25.08.2021.
//

import UIKit

class NewGameVC: UIViewController {
    
    let startButtonHeight: CGFloat = 65
    let tableRowHeight: CGFloat = 41
    lazy var playersTableView = UITableView()
    
    var dataHolder: Array = ["One","Two","Three","Four","Five"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        self.settViews()
        
    }
    
    override func viewDidLayoutSubviews() {
        //disable scroll if contentSize < tableViewFrame
        playersTableView.isScrollEnabled = playersTableView.contentSize.height > playersTableView.frame.size.height
    }
    
    
    private func settViews(){
        let safeArea = self.view.safeAreaLayoutGuide
        
        //create cancelButton
        let cancelButton = UIButton().createBarButton(title: "Cancel", font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!)
        
        self.view.addSubview(cancelButton)
        
        cancelButton.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 6, left: 20, bottom: 0, right: 0))
        
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
        
        //create startGameButton
        let startGameButton: UIButton = {
            let button = UIButton()
            button.setTitle("Start game", for: .normal)
            button.titleLabel?.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 24)!
            
            button.titleLabel?.layer.shadowColor = UIColor(named: "buttonShadow")?.cgColor
            button.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 2)
            button.titleLabel?.layer.shadowRadius = 0
            button.titleLabel?.layer.shadowOpacity = 1.0
            
            button.setTitleColor(.white, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(named: "tintColor")
            button.layer.cornerRadius = startButtonHeight / 2

            button.layer.shadowColor = UIColor(named: "buttonShadow")?.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 5)
            button.layer.shadowRadius = 0
            button.layer.shadowOpacity = 1.0
            
            return button
        }()
        
        self.view.addSubview(startGameButton)
        
        startGameButton.anchor(top: nil, leading: safeArea.leadingAnchor, bottom: self.view.bottomAnchor, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 65, right: 20), size: CGSize(width: 0, height: startButtonHeight))
        
        //create tableView with players
        self.playersTableView = {
            let table = UITableView()
            table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            table.delegate = self
            table.dataSource = self
            table.translatesAutoresizingMaskIntoConstraints = false
            table.layer.cornerRadius = 15
            table.backgroundColor = UIColor(named: "elemBack")
            table.isEditing = true
//            table.isScrollEnabled = false
            return table
            
        }()
        
        self.view.addSubview(self.playersTableView)
        
        self.playersTableView .anchor(top: gameCounterLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 25, left: 20, bottom: 0, right: 20))
        
        self.playersTableView .heightAnchor.constraint(lessThanOrEqualToConstant: 77 + tableRowHeight * CGFloat(dataHolder.count)).isActive = true
        
        let bottomConstraint = self.playersTableView .bottomAnchor.constraint(equalTo: startGameButton.topAnchor, constant: -25)
        bottomConstraint.priority = UILayoutPriority(rawValue: 249)
        bottomConstraint.isActive = true
    }

}

extension NewGameVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataHolder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: "elemBack")
        cell.textLabel?.text = dataHolder[indexPath.row]
        //FIXME: change image on code
        let sortIcon = UIImageView(image: UIImage(named: "icon_Sort"))
        sortIcon.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(sortIcon)
        
        NSLayoutConstraint.activate([
            sortIcon.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -15),
            sortIcon.centerYAnchor.constraint(equalTo: cell.centerYAnchor)
        ])
        
        if indexPath.row != dataHolder.count - 1{
            let seporator = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width - 16, height: 1))
            seporator.backgroundColor = UIColor(named: "seporator")
            seporator.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(seporator)
            
            seporator.anchor(top: nil, leading: cell.leadingAnchor, bottom: cell.bottomAnchor, trailing: cell.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0), size: CGSize(width: 0, height: 1))
        } else {
            cell.setEditing(true, animated: false)
            print(cell.isEditing)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove: String = dataHolder[sourceIndexPath.row]
        dataHolder.remove(at: sourceIndexPath.row)
        dataHolder.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    

    
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row != dataHolder.count - 1{
            return true
        }else{
            return false
        }
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
