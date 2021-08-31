//
//  GameProcessVC.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 28.08.2021.
//

import UIKit

final class GameProcessVC: UIViewController {
    
    private var dataHolder = DataClass.sharedInstance().playersArray
    private var timerL = Timer()
    private var multiplikator: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backGround")
        self.settViews()
        
        if DataClass.shared.timerPlay{
            timer()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        selectItemAfterResume()
    }
    
    //MARK: create gamerCollectionView
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
    
    //MARK: create letterStackName
    private let letterStackName: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 5
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.backgroundColor = UIColor(named: "backGround")
        return stack
    }()
    
    //MARK: create previousButton
    private let previousButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "previous"), for: .normal)
        
        return button
    }()
    
    //MARK: create nextButton
    private let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "next"), for: .normal)
        
        return button
    }()
    
    //MARK: create timerLabel
    private let timerLabel: UILabel = {
        let label = UILabel()
        let gameTime = DataClass.sharedInstance().gameTime
        let secondString = String(gameTime.second).count < 2 ? "0\(String(gameTime.second))" : (String(gameTime.second))
        let minuteString = String(gameTime.minute).count < 2 ? "0\(String(gameTime.minute))" : String(gameTime.minute)
        label.text = "\(minuteString):\(secondString)"
        label.textColor = .white
        label.font = UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: create playPauseButton
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        if !DataClass.sharedInstance().timerPlay{
            button.setImage(UIImage(named: "Play"), for: .normal)
        } else {
            button.setImage(UIImage(named: "Pause"), for: .normal)
        }
        return button
    }()
    
    //MARK: settViews
    private func settViews(){
        let safeArea = self.view.safeAreaLayoutGuide
        settMultiplicator()
        
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
        
        //MARK:config timerLabel
        self.view.addSubview(timerLabel)
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: gameLabel.bottomAnchor, constant: 15)
        ])
        
        //MARK:config play / pause button
        self.view.addSubview(playPauseButton)
        
        playPauseButton.anchor(top: timerLabel.topAnchor, leading: timerLabel.trailingAnchor, bottom: timerLabel.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0), size: CGSize(width: 20, height: 0))
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        
        //MARK:config collectionView
        self.view.addSubview(gamerCollectionView)
        
        gamerCollectionView.anchor(top: timerLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 300 * multiplikator))
        
        //MARK:config previous button
        self.view.addSubview(previousButton)
        
        previousButton.anchor(top: gamerCollectionView.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 58 * multiplikator, left: 46, bottom: 0, right: 0))
        
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        
        //MARK:config next button
        self.view.addSubview(nextButton)
        
        nextButton.anchor(top: gamerCollectionView.bottomAnchor, leading: nil, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 58 * multiplikator, left: 0, bottom: 0, right: 46))
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        //MARK:create plusOne button
        
        let plusOneButton = UIButton(type: .system).createEllipseButton(title: "+1", font: UIFont(name: "Nunito-ExtraBold", size: 40 * multiplikator)!, radius: 45 * multiplikator, shadow: true)
        plusOneButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        self.view.addSubview(plusOneButton)
        
        NSLayoutConstraint.activate([
            plusOneButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            plusOneButton.centerYAnchor.constraint(equalTo: previousButton.centerYAnchor),
            plusOneButton.heightAnchor.constraint(equalToConstant: 90 * CGFloat(multiplikator)),
            plusOneButton.widthAnchor.constraint(equalToConstant: 90 * CGFloat(multiplikator))
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
        
        stackView.anchor(top: plusOneButton.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 20 * multiplikator, left: 20, bottom: 0, right: 20), size: CGSize(width: 0, height: 55 * multiplikator))
        
        let numberArray = ["-10","-5","-1","+5","+10"]
        for title in numberArray {
            let plusButton = UIButton(type: .system).createEllipseButton(title: title, font: UIFont(name: "Nunito-ExtraBold", size: 25 * multiplikator)!, radius: 27.5 * multiplikator, shadow: true)
            plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
            stackView.addArrangedSubview(plusButton)
        }
        
        
        //MARK: config firstLetterForName stackView
        self.view.addSubview(letterStackName)

        NSLayoutConstraint.activate([
            letterStackName.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            letterStackName.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -28),
            letterStackName.heightAnchor.constraint(equalToConstant: 27),
        ])
        
        settLetterStackView(withRefresh: false)

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
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension GameProcessVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataHolder.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath)
        
        if let cell = cell as? GameCollectionViewCell {
            cell.multiplicator = multiplikator
            cell.settLabels(name: dataHolder[indexPath.item].name, score: dataHolder[indexPath.item].score)
        }
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GameProcessVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 255 * multiplikator
        let height = 300 * multiplikator
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftRightInsets: CGFloat = (self.view.frame.width - CGFloat(255 * multiplikator)) / 2
        
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

// MARK: - UIScrollViewDelegate
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
        settColorsForLetterStackName(indexCenter: indexCenter)
        
        for i in 0..<DataClass.sharedInstance().playersArray.count{
            if i != indexCenter{
                DataClass.sharedInstance().playersArray[i].select = false
            } else {
                guard let indexPathOnScreen = gamerCollectionView.indexPathForItem(at: self.view.convert(self.view.center, to: gamerCollectionView)) else {return}
                DataClass.sharedInstance().playersArray[i].select = true
                DataClass.sharedInstance().playersArray[i].playersIndex = indexPathOnScreen
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

//MARK: Halpers func
extension GameProcessVC{
    
    func selectItemAfterResume(){
        for i in 0..<DataClass.sharedInstance().playersArray.count{
            if DataClass.sharedInstance().playersArray[i].select == true{
                gamerCollectionView.selectItem(at: DataClass.sharedInstance().playersArray[i].playersIndex, animated: true, scrollPosition: .centeredHorizontally)
                break
            }
        }
    }
    
    func timer(){
        timerL.invalidate()

        timerLabel.text = "\(getSecondAndMinuteString()[1]):\(getSecondAndMinuteString()[0])"
        
        timerL = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        RunLoop.current.add(timerL, forMode: .common)
    }
    
    func settDataFromGame() {
        dataHolder = DataClass.sharedInstance().playersArray
        gamerCollectionView.selectItem(at: IndexPath(indexes: [0,0]), animated: true, scrollPosition: .centeredHorizontally)
        gamerCollectionView.reloadData()
    }
    
    func settLetterStackView(withRefresh: Bool){
        if withRefresh{
            let arangedSubviews = letterStackName.arrangedSubviews
            for view in arangedSubviews{
                letterStackName.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }
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
    
    private func settMultiplicator(){
        let viewHeight = self.view.frame.height
        if viewHeight<800 && viewHeight>600{
            multiplikator = 0.8
        }else if viewHeight<600{
            multiplikator = 0.6
        }
    }
    
    private func getCollectionItemIndexOnScreen() -> Int?{
        guard let indexPathOnScreen = gamerCollectionView.indexPathForItem(at: self.view.convert(self.view.center, to: gamerCollectionView)) else {return nil}
        let indexCenter = indexPathOnScreen.item
        return indexCenter
    }
    
    private func settColorsForLetterStackName(indexCenter: Int?){
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
 
}

//MARK: Targets
extension GameProcessVC{
    
    @objc func newGameButtonTapped(){
        let newGameVC = NewGameVC()
        newGameVC.gameProcessDelegate = self
        let navVC = UINavigationController(rootViewController: newGameVC)
        navVC.navigationBar.isHidden = true
        present(navVC, animated: true, completion: nil)
    }
    
    @objc func plusButtonTapped(sender: UIButton){
        guard let indexPathOnScreen = gamerCollectionView.indexPathForItem(at: self.view.convert(self.view.center, to: gamerCollectionView)) else {return}
        let indexCenter = indexPathOnScreen.item
        let plusNumber = Int((sender.titleLabel?.text)!)!
        
        DataClass.sharedInstance().playersArray[indexCenter].score += plusNumber
        DataClass.sharedInstance().turnsArray.append(Turn(player: DataClass.sharedInstance().playersArray[indexCenter], addScore: (sender.titleLabel?.text)!, playersIndex: indexPathOnScreen))
        
        settDataFromGame()
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
        settDataFromGame()
        gamerCollectionView.selectItem(at: lastTurn.playersIndex, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    @objc func resultsButtonTapped(){
        let resultVC = ResultsVC()
        resultVC.multiplikator = multiplikator
        resultVC.gameDelegate = self
        let navVS = UINavigationController(rootViewController: resultVC)
        navVS.navigationBar.isHidden = true
        present(navVS, animated: true, completion: nil)
    }
    
    @objc func playPauseButtonTapped() {
        if DataClass.sharedInstance().timerPlay{
            playPauseButton.setImage(UIImage(named: "Play"), for: .normal)
            timerL.invalidate()
            DataClass.sharedInstance().timerPlay = false
        } else {
            playPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
            timer()
            DataClass.sharedInstance().timerPlay = true
        }
    }
    
    @objc func rollButtonTapped() {
        let rollVC = RollVC()
        rollVC.modalPresentationStyle = .overFullScreen
        show(rollVC, sender: nil)
    }
    
    @objc func tick(){
        DataClass.sharedInstance().gameTime.second += 1
        if DataClass.sharedInstance().gameTime.second == 60 {
            DataClass.sharedInstance().gameTime.minute += 1
            DataClass.sharedInstance().gameTime.second = 0
        }
        timerLabel.text = "\(getSecondAndMinuteString()[1]):\(getSecondAndMinuteString()[0])"
    }
    
    private func getSecondAndMinuteString()->[String]{
        let gameTime = DataClass.sharedInstance().gameTime
        let secondString = String(gameTime.second).count < 2 ? "0\(String(gameTime.second))" : (String(gameTime.second))
        let minuteString = String(gameTime.minute).count < 2 ? "0\(String(gameTime.minute))" : String(gameTime.minute)
        return [secondString,minuteString]
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
