//
//  ResultsVC.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 28.08.2021.
//

import UIKit

class ResultsVC: UIViewController {
    
    var dataHolder = DataClass.sharedInstance().playersArray
    var turnsArray = DataClass.sharedInstance().turnsArray
    let rowHeight: CGFloat = 41
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backGround")
        self.settViews()
        
    }
    
    private func settViews(){
        let safeArea = self.view.safeAreaLayoutGuide
        
        //create cancelButton
        let newGameButton = UIButton(type: .system).createBarButton(title: "New Game", font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!)
        
        self.view.addSubview(newGameButton)
        
        newGameButton.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 6, left: 20, bottom: 0, right: 0))
        
        newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        //create addlButton
        let resumeButton = UIButton(type: .system).createBarButton(title: "Resume", font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!)
        
        self.view.addSubview(resumeButton)
        
        resumeButton.anchor(top: safeArea.topAnchor, leading: nil, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 25))
        
        resumeButton.addTarget(self, action: #selector(resumeButtonTapped), for: .touchUpInside)
        //create gamelabel
        let resultsLabel: UILabel = {
            let label = UILabel()
            label.text = "Results"
            label.textColor = .white
            label.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 36)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.view.addSubview(resultsLabel)
        
        resultsLabel.anchor(top: newGameButton.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 20, bottom: 0, right: 200))
        
        
        //create collectionView
        
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.showsVerticalScrollIndicator = false
            view.showsHorizontalScrollIndicator = false
            view.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: "resultCell")
            view.delegate = self
            view.dataSource = self
            view.backgroundColor = UIColor(named: "backGround")
            return view
        }()
        
        self.view.addSubview(collectionView)
        
        let collectionHeight: CGFloat = (rowHeight + 15) * CGFloat(dataHolder.count) < 300 ? (rowHeight + 15) * CGFloat(dataHolder.count) : 300
        
        collectionView.anchor(top: resultsLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: collectionHeight))
        
        //createTableView
        
        let resultsTableView: UITableView = {
            let table = UITableView(frame: .zero, style: .grouped)
            table.register(ResultsTableViewCell.self, forCellReuseIdentifier: "cellResults")
            table.delegate = self
            table.dataSource = self
            table.translatesAutoresizingMaskIntoConstraints = false
            table.layer.cornerRadius = 15
            table.backgroundColor = UIColor(named: "elemBack")
            table.alwaysBounceVertical = false
            return table
        }()
        
        self.view.addSubview(resultsTableView)
        
        resultsTableView.anchor(top: collectionView.bottomAnchor, leading: safeArea.leadingAnchor, bottom: self.view.bottomAnchor, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20))
        
    }
    
}

//MARK: Table

extension ResultsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return turnsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellResults", for: indexPath) as! ResultsTableViewCell
        cell.settScore(name: turnsArray[indexPath.row].player.name, score: turnsArray[indexPath.row].addScore)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    //MARK: config headerView
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "elemBack")
        let playerLabel: UILabel = {
            let label = UILabel()
            label.text = "Turns"
            label.font = UIFont(name: CustomFonts.nunitoSemiBold.rawValue, size: 16)
            label.textColor = UIColor(red: 0.922, green: 0.922, blue: 0.961, alpha: 0.6)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        headerView.addSubview(playerLabel)
        
        playerLabel.anchor(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: nil, trailing: headerView.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: -16))
        
        return headerView
    }
    
    
}

//MARK: Collection

extension ResultsVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataHolder.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resultCell", for: indexPath) as! ResultCollectionViewCell
        
        var filteredPlayers = dataHolder.sorted { pl1, pl2 in
            pl1.name < pl2.name
        }
        
        filteredPlayers.sort { pl1, pl2 in
            pl1.score > pl2.score
        }
        
        var score = 0
        var position = 1
        for i in 0..<filteredPlayers.count{
            if i == 0{
                score = filteredPlayers[i].score
                filteredPlayers[i].position = position
                continue
            }
            if filteredPlayers[i].score == score{
                filteredPlayers[i].position = position
            }else {
                score = filteredPlayers[i].score
                position += 1
                filteredPlayers[i].position = position
            }
        }
        
        
        cell.settLabels(position: filteredPlayers[indexPath.item].position, name: filteredPlayers[indexPath.item].name, score: filteredPlayers[indexPath.item].score)
        return cell
    }
    
    
}

extension ResultsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = rowHeight
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

//MARK: Targets
extension ResultsVC{
    
    @objc func resumeButtonTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func newGameButtonTapped(){
        let newGameVC = NewGameVC()
        newGameVC.resultDelegate = self
        newGameVC.modalPresentationStyle = .fullScreen
//        dismiss(animated: false, completion: nil)
        present(newGameVC, animated: true, completion: nil)
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
//        let tabBarVC = ResultsVC()
//        //меняем input параметры в соответствии с образцом
//        @available(iOS 13.0, *)
//        func makeUIViewController(context: UIViewControllerRepresentableContext<PeopleVСProvider.ContainerView>) -> ResultsVC {
//            return tabBarVC
//        }
//        //не пишем никакого кода
//        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        }
//    }
//}
