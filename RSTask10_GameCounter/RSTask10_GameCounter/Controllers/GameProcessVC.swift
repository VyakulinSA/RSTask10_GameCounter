//
//  GameProcessVC.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 28.08.2021.
//

import UIKit

final class GameProcessVC: UIViewController {
    
    private var dataHolder = DataClass.sharedInstance().playersArray
    var newGame = true
    private var collectionMoved = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backGround")
        self.settViews()
        
    }
    
    func settDataHolder() {
        dataHolder = DataClass.sharedInstance().playersArray
        gamerCollectionView.selectItem(at: IndexPath(indexes: [0,0]), animated: true, scrollPosition: .centeredHorizontally)
        gamerCollectionView.reloadData()
    }
    
    func prepareLetterStackView() {
        let arangedSubviews = letterStackName.arrangedSubviews
        for view in arangedSubviews{
            letterStackName.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        settLetterStackView()
    }
    
    lazy var gamerCollectionView: UICollectionView = {
        let layout = CustomCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        view.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: "gameCell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor(named: "backGround")
        view.isPagingEnabled = false
        view.decelerationRate = .fast
        return view
    }()
    
    let letterStackName: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.backgroundColor = UIColor(named: "backGround")
        return stack
    }()
    
    let previousButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "previous"), for: .normal)
        
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "next"), for: .normal)
        
        return button
    }()
    
    
    private func settViews(){
        let safeArea = self.view.safeAreaLayoutGuide
        
        //MARK:create newGameButton
        let newGameButton = UIButton(type: .system).createBarButton(title: "New Game", font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!)
        
        self.view.addSubview(newGameButton)
        
        newGameButton.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 6, left: 20, bottom: 0, right: 0))
        
        newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        //MARK:create resultsButton
        let resultsButton = UIButton(type: .system).createBarButton(title: "Results", font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!)
        
        self.view.addSubview(resultsButton)
        
        resultsButton.anchor(top: safeArea.topAnchor, leading: nil, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 25))
        
        resultsButton.addTarget(self, action: #selector(resultsButtonTapped), for: .touchUpInside)
        //MARK:create gamelabel
        let gameLabel: UILabel = {
            let label = UILabel()
            label.text = "Game"
            label.textColor = .white
            label.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 36)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.view.addSubview(gameLabel)
        
        gameLabel.anchor(top: newGameButton.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 20, bottom: 0, right: 200))
        
        
        //MARK:create rolllButton
        let rollButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "rollButtonImage"), for: .normal)
            
            return button
        }()
        
        self.view.addSubview(rollButton)
        
        rollButton.anchor(top: nil, leading: nil, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20), size: CGSize(width: 30, height: 30))
        rollButton.centerYAnchor.constraint(equalTo: gameLabel.centerYAnchor).isActive = true
        
        rollButton.addTarget(self, action: #selector(rollButtonTapped), for: .touchUpInside)
        
        //MARK:create timerLabel
        let timerLabel: UILabel = {
            let label = UILabel()
            label.text = "05:23"
            label.textColor = .white
            label.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 28)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.view.addSubview(timerLabel)
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: gameLabel.bottomAnchor, constant: 29)
        ])
        
        //MARK:creeate play / pause button
        let playPauseButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "Pause"), for: .normal)
            return button
        }()
        
        self.view.addSubview(playPauseButton)
        
        playPauseButton.anchor(top: timerLabel.topAnchor, leading: timerLabel.trailingAnchor, bottom: timerLabel.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0), size: CGSize(width: 20, height: 0))
        
        //MARK:create collectionView
        
        
        
        self.view.addSubview(gamerCollectionView)
        
        
        
        
        gamerCollectionView.anchor(top: timerLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 42, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 300))
        
        //MARK:create previous button
       
        
        self.view.addSubview(previousButton)
        
        previousButton.anchor(top: gamerCollectionView.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 58, left: 46, bottom: 0, right: 0))
        
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        
        //MARK:create next button
        
        
        self.view.addSubview(nextButton)
        
        nextButton.anchor(top: gamerCollectionView.bottomAnchor, leading: nil, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 58, left: 0, bottom: 0, right: 46))
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        //MARK:create plusOne button
        let plusOneButton = UIButton(type: .system).createEllipseButton(title: "+1", font: UIFont(name: "Nunito-ExtraBold", size: 40)!, radius: 45, shadow: true)
        plusOneButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        self.view.addSubview(plusOneButton)
        
        NSLayoutConstraint.activate([
            plusOneButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            plusOneButton.centerYAnchor.constraint(equalTo: previousButton.centerYAnchor),
            plusOneButton.heightAnchor.constraint(equalToConstant: 90),
            plusOneButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        //MARK:create plusButton stackView
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.spacing = 15
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            return stack
        }()
        
        self.view.addSubview(stackView)
        
        stackView.anchor(top: plusOneButton.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 55))
        
        let numberArray = ["-10","-5","-1","+5","+10"]
        for title in numberArray {
            let plusButton = UIButton(type: .system).createEllipseButton(title: title, font: UIFont(name: "Nunito-ExtraBold", size: 25)!, radius: 27.5, shadow: true)
            plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
            stackView.addArrangedSubview(plusButton)
        }
        
        
        //MARK: create firstLetterForName stackView
        
        self.view.addSubview(letterStackName)

        NSLayoutConstraint.activate([
            letterStackName.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            letterStackName.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -28),
            letterStackName.heightAnchor.constraint(equalToConstant: 27),
        ])
        
        settLetterStackView()
        
        
        //FIXME: сделать стэк без костылей
        //MARK:create support views for stackView
        let cust = UIView()
        cust.backgroundColor = UIColor(named: "backGround")
        cust.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(cust)
        
        cust.anchor(top: nil, leading: safeArea.leadingAnchor, bottom: self.view.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0), size: CGSize(width: 60, height: 30))
        
        let cust1 = UIView()
        cust1.backgroundColor = UIColor(named: "backGround")
        cust1.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(cust1)
        
        cust1.anchor(top: nil, leading: nil, bottom: self.view.bottomAnchor, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0), size: CGSize(width: 60, height: 30))
        
        //MARK:create undo button
        let undoButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "undo"), for: .normal)
            return button
        }()
        
        self.view.addSubview(undoButton)
        
        undoButton.anchor(top: nil, leading: safeArea.leadingAnchor, bottom: self.view.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 40, bottom: 32, right: 0))
        
        undoButton.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
    }
    
    @objc func rollButtonTapped() {
        let rollVC = RollVC()
        //FIXME: сделать кастомную анимацию перехода (из центра экрана с шатанием кубика)
        rollVC.modalPresentationStyle = .overFullScreen
        show(rollVC, sender: nil)
    }
    
    private func getCollectionItemIndexOnScreen() -> Int?{
        guard let indexPathOnScreen = gamerCollectionView.indexPathForItem(at: self.view.convert(self.view.center, to: gamerCollectionView)) else {return nil}
        let indexCenter = indexPathOnScreen.item
        return indexCenter
    }
    
    func settLetterStackView(){
        for i in 0..<dataHolder.count {
            let firstLetter = dataHolder[i].name.first!.uppercased()
            let label = UILabel()
            label.text = firstLetter
            label.font = UIFont(name: "Nunito-ExtraBold", size: 20)
            if i == 0{
                label.textColor = .white
            }else {
                label.textColor = UIColor(named: "elemBack")
            }
            letterStackName.addArrangedSubview(label)
        }
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension GameProcessVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataHolder.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath)
        
        if let cell = cell as? GameCollectionViewCell {
            cell.settLabels(name: dataHolder[indexPath.item].name, score: dataHolder[indexPath.item].score)
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GameProcessVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 255
        let height = 300
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let leftRightInsets: CGFloat = (self.view.frame.width - 255) / 2
        if let layout = collectionViewLayout as? CustomCollectionViewFlowLayout{
            layout.padding = leftRightInsets
        }
        
         let sectionInsets: UIEdgeInsets = .init(top: 0, left: leftRightInsets, bottom: 0, right: leftRightInsets)
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
}

extension GameProcessVC: UIScrollViewDelegate{
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        changeFirstLetterStackAfterScrolling()
        changePreviousNextButton()
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        changeFirstLetterStackAfterScrolling()
        changePreviousNextButton()
    }
    
    private func changeFirstLetterStackAfterScrolling(){
        let indexCenter = getCollectionItemIndexOnScreen()
        
        let views = letterStackName.arrangedSubviews
        for i in 0..<views.count{
            guard let label = views[i] as? UILabel else {return}
            if i != indexCenter{
                label.textColor = UIColor(named: "elemBack")
            }else {
                label.textColor = .white
            }
        }
    }
    
    private func changePreviousNextButton(){

        let indexCenter = getCollectionItemIndexOnScreen()
        
        if indexCenter == 0 {
            nextButton.setImage(UIImage(named: "next"), for: .normal)
            previousButton.setImage(UIImage(named: "previous"), for: .normal)
        } else if indexCenter == dataHolder.count - 1{
            nextButton.setImage(UIImage(named: "nextPrevious"), for: .normal)
            previousButton.setImage(UIImage(named: "back"), for: .normal)
        } else {
            nextButton.setImage(UIImage(named: "next"), for: .normal)
            previousButton.setImage(UIImage(named: "back"), for: .normal)
        }
    }
}

//MARK: Targets
extension GameProcessVC{
    
    @objc func newGameButtonTapped(){
        let newGameVC = NewGameVC()
        newGameVC.gameProcessDelegate = self
        present(newGameVC, animated: true, completion: nil)
        
    }
    
    @objc func plusButtonTapped(sender: UIButton){
        guard let indexPathOnScreen = gamerCollectionView.indexPathForItem(at: self.view.convert(self.view.center, to: gamerCollectionView)) else {return}
        let indexCenter = indexPathOnScreen.item
        let plusNumber = Int((sender.titleLabel?.text)!)!
        
        DataClass.sharedInstance().playersArray[indexCenter].score += plusNumber
        DataClass.sharedInstance().turnsArray.append(Turn(player: DataClass.sharedInstance().playersArray[indexCenter], addScore: (sender.titleLabel?.text)!, playersIndex: indexPathOnScreen))
        settDataHolder()
        nextButtonTapped()
    }
    
    @objc func previousButtonTapped(){
        guard var indexPathOnScreen = gamerCollectionView.indexPathForItem(at: self.view.convert(self.view.center, to: gamerCollectionView)) else {return}
        if indexPathOnScreen.item == 0{
            indexPathOnScreen.item = dataHolder.count - 1
        }else {
            indexPathOnScreen.item -= 1
        }
        gamerCollectionView.selectItem(at: indexPathOnScreen, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    @objc func nextButtonTapped(){
        guard var indexPathOnScreen = gamerCollectionView.indexPathForItem(at: self.view.convert(self.view.center, to: gamerCollectionView)) else {return}
        if indexPathOnScreen.item == dataHolder.count - 1{
            indexPathOnScreen.item = 0
        }else {
            indexPathOnScreen.item += 1
        }
        gamerCollectionView.selectItem(at: indexPathOnScreen, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    @objc func undoButtonTapped(){
        guard let lastTurn = DataClass.sharedInstance().turnsArray.popLast() else {return}
        DataClass.sharedInstance().playersArray[lastTurn.playersIndex.item].score -= Int(lastTurn.addScore)!
        gamerCollectionView.selectItem(at: lastTurn.playersIndex, animated: true, scrollPosition: .centeredHorizontally)
        settDataHolder()
        
    }
    
    @objc func resultsButtonTapped(){
        let resultVC = ResultsVC()
        present(resultVC, animated: true, completion: nil)
        
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
