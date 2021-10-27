//
//  ResultsVC.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 28.08.2021.
//

import UIKit

class ResultsVC: UIViewController {
    
    weak var gameDelegate: GameProcessVC?
    
    private var dataHolder = DataClass.sharedInstance().playersArray
    private var turnsArray = DataClass.sharedInstance().turnsArray
    
    private let rowHeight: CGFloat = 41
    var multiplikator: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backGroundColor")
        self.settViews()
    }
    
    private func settViews() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        //MARK: create cancelButton
        let newGameButton = UIButton(type: .system).createBarButton(
            title: "New Game",
            font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!
        )
        
        self.view.addSubview(newGameButton)
        
        newGameButton.anchor(
            top: safeArea.topAnchor,
            leading: safeArea.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: UIEdgeInsets(top: 6, left: 20, bottom: 0, right: 0)
        )
        
        newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        
        //MARK: create addlButton
        let resumeButton = UIButton(type: .system).createBarButton(
            title: "Resume",
            font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!
        )
        
        self.view.addSubview(resumeButton)
        
        resumeButton.anchor(
            top: safeArea.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 25)
        )
        
        resumeButton.addTarget(self, action: #selector(resumeButtonTapped), for: .touchUpInside)
        
        //MARK: create gamelabel
        let resultsLabel: UILabel = {
            let label = UILabel()
            label.text = "Results"
            label.textColor = .white
            label.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 36 * multiplikator)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.view.addSubview(resultsLabel)
        
        resultsLabel.anchor(
            top: newGameButton.bottomAnchor,
            leading: safeArea.leadingAnchor,
            bottom: nil,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 12, left: 20, bottom: 0, right: 200)
        )

        //MARK: create collectionView
        
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
            view.backgroundColor = UIColor(named: "backGroundColor")
            return view
        }()
        
        self.view.addSubview(collectionView)
        
        let collectionHeight: CGFloat = (rowHeight + 15) * CGFloat(dataHolder.count) < 300 ? (rowHeight + 15) * CGFloat(dataHolder.count) : 300
        
        collectionView.anchor(
            top: resultsLabel.bottomAnchor,
            leading: safeArea.leadingAnchor,
            bottom: nil,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20),
            size: CGSize(width: 0, height: collectionHeight * multiplikator)
        )
        
        //MARK: createTableView
        
        let resultsTableView: UITableView = {
            let table = UITableView(frame: .zero, style: .grouped)
            table.register(ResultsTableViewCell.self, forCellReuseIdentifier: "cellResults")
            table.delegate = self
            table.dataSource = self
            table.translatesAutoresizingMaskIntoConstraints = false
            table.layer.cornerRadius = 15
            table.backgroundColor = UIColor(named: "elementBackgroundColor")
            table.alwaysBounceVertical = false
            return table
        }()
        
        self.view.addSubview(resultsTableView)
        
        resultsTableView.anchor(
            top: collectionView.bottomAnchor,
            leading: safeArea.leadingAnchor,
            bottom: self.view.bottomAnchor,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        )
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource

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
        return 50 * multiplikator
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "elementBackgroundColor")
        let playerLabel: UILabel = {
            let label = UILabel()
            label.text = "Turns"
            label.font = UIFont(name: CustomFonts.nunitoSemiBold.rawValue, size: 16 * multiplikator)
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
            padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: -16)
        )
        
        return headerView
    }
    
    
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension ResultsVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataHolder.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resultCell", for: indexPath) as! ResultCollectionViewCell
        
        let filteredPlayers = settScoreAndPositionPlayers(playersArray: filteredPlayers(playersArray: dataHolder))
        
        cell.settLabels(
            position: filteredPlayers.1[indexPath.item],
            name: filteredPlayers.0[indexPath.item].name,
            score: filteredPlayers.0[indexPath.item].score
        )
        return cell
    }
    
    
}

extension ResultsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = rowHeight
        return CGSize(width: width, height: height * multiplikator)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

//MARK: Targets
extension ResultsVC{
    
    @objc func resumeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func newGameButtonTapped() {
        let newGameVC = NewGameVC()
        newGameVC.resultDelegate = self
        newGameVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(newGameVC, animated: true)
    }
}

//MARK: Helpers func
extension ResultsVC {
    
    private func filteredPlayers(playersArray: [Player])->[Player]{
        var filteredPlayers = playersArray.sorted { $0.name < $1.name }
        filteredPlayers.sort { $0.score > $1.score}
        return filteredPlayers
    }
    
    private func settScoreAndPositionPlayers(playersArray: [Player])->([Player],[Int]){
        var score = 0
        var position = 1
        var playerPositionArray = [Int](repeating: 1, count: playersArray.count)
        
        for i in 0..<playersArray.count{
            if i == 0{
                score = playersArray[i].score
                playerPositionArray[i] = position
                continue
            }
            if playersArray[i].score == score{
                playerPositionArray[i] = position
            }else {
                score = playersArray[i].score
                position += 1
                playerPositionArray[i] = position
            }
        }
        return (playersArray, playerPositionArray)
    }
}
