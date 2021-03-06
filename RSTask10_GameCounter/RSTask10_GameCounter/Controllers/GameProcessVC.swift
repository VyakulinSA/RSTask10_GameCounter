//
//  GameProcessVC.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 28.08.2021.
//

import UIKit

final class GameProcessVC: UIViewController {
    private let dataShared = DataClass.sharedInstance()
    private var dataHolder: [Player]!
    private var timerL = Timer()
    private var multiplikator: CGFloat = 1.0
    let halpersClass = UserDefaultsManager()
    private var nextIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "backGroundColor")
        dataHolder = dataShared.playersArray
        settViews()
        configurationViews()
        
        if dataShared.timerPlay{
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
        view.backgroundColor = UIColor(named: "backGroundColor")
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
        stack.backgroundColor = UIColor(named: "backGroundColor")
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
    
    private let newGameButton = UIButton(type: .system).createBarButton(
        title: "New Game",
        font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!
    )
    
    private let resultsButton = UIButton(type: .system).createBarButton(
        title: "Results",
        font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!
    )
    
    private let rollButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "rollButtonImage"), for: .normal)
        return button
    }()
    
    private func configurationViews() {
        newGameButton.addTarget(self, action: #selector(newGameButtonTapped), for: .touchUpInside)
        resultsButton.addTarget(self, action: #selector(resultsButtonTapped), for: .touchUpInside)
        rollButton.addTarget(self, action: #selector(rollButtonTapped), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        settLetterStackView(withRefresh: false)
    }
    
    //MARK: settViews
    private func settViews() {
        let safeArea = self.view.safeAreaLayoutGuide
        settMultiplicator()
        
        //MARK:create newGameButton
        self.view.addSubview(newGameButton)
        
        newGameButton.anchor(
            top: safeArea.topAnchor,
            leading: safeArea.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: UIEdgeInsets(top: 6, left: 20, bottom: 0, right: 0)
        )
        
        //MARK:create resultsButton
        self.view.addSubview(resultsButton)
        
        resultsButton.anchor(
            top: safeArea.topAnchor,
            leading: nil,
            bottom: nil,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 25)
        )
        
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
        
        gameLabel.anchor(
            top: newGameButton.bottomAnchor,
            leading: safeArea.leadingAnchor,
            bottom: nil,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 12, left: 20, bottom: 0, right: 200)
        )
        
        //MARK:create rolllButton
        self.view.addSubview(rollButton)
        
        rollButton.anchor(
            top: nil,
            leading: nil,
            bottom: nil,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20),
            size: CGSize(width: 30, height: 30)
        )
        
        rollButton.centerYAnchor.constraint(equalTo: gameLabel.centerYAnchor).isActive = true

        //MARK:config timerLabel
        self.view.addSubview(timerLabel)
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: gameLabel.bottomAnchor, constant: 15)
        ])
        
        //MARK:config play / pause button
        self.view.addSubview(playPauseButton)
        
        playPauseButton.anchor(
            top: timerLabel.topAnchor,
            leading: timerLabel.trailingAnchor,
            bottom: timerLabel.bottomAnchor,
            trailing: nil,
            padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0),
            size: CGSize(width: 20, height: 0)
        )
        
        //MARK:config collectionView
        self.view.addSubview(gamerCollectionView)
        
        gamerCollectionView.anchor(
            top: timerLabel.bottomAnchor,
            leading: safeArea.leadingAnchor,
            bottom: nil,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0),
            size: CGSize(width: 0, height: 300 * multiplikator)
        )
        
        //MARK:config previous button
        self.view.addSubview(previousButton)
        
        previousButton.anchor(
            top: gamerCollectionView.bottomAnchor,
            leading: safeArea.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: UIEdgeInsets(top: 58 * multiplikator, left: 46, bottom: 0, right: 0)
        )
        
        //MARK:config next button
        self.view.addSubview(nextButton)
        
        nextButton.anchor(
            top: gamerCollectionView.bottomAnchor,
            leading: nil,
            bottom: nil,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 58 * multiplikator, left: 0, bottom: 0, right: 46)
        )

        //MARK:create plusOne button
        let plusOneButton = UIButton(type: .system).createEllipseButton(
            title: "+1",
            font: UIFont(name: "Nunito-ExtraBold", size: 40 * multiplikator)!,
            radius: 45 * multiplikator,
            shadow: true
        )
        
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
            stack.spacing = 18.5
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            return stack
        }()
        
        self.view.addSubview(stackView)
        
        stackView.anchor(
            top: plusOneButton.bottomAnchor,
            leading: safeArea.leadingAnchor,
            bottom: nil,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 20 * multiplikator, left: 20, bottom: 0, right: 20),
            size: CGSize(width: 0, height: 55 * multiplikator)
        )
        
        let numberArray = ["-10","-5","-1","+5","+10"]
        for title in numberArray {
            let plusButton = UIButton(type: .system).createEllipseButton(
                title: title,
                font: UIFont(name: "Nunito-ExtraBold", size: 25 * multiplikator)!,
                radius: 27.5 * multiplikator,
                shadow: true
            )
            
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

        //MARK:create support views for stackView
        let cust = UIView()
        
        cust.backgroundColor = UIColor(named: "backGroundColor")
        cust.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(cust)
        
        cust.anchor(
            top: nil,
            leading: safeArea.leadingAnchor,
            bottom: self.view.bottomAnchor,
            trailing: nil,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0),
            size: CGSize(width: 60, height: 30)
        )
        
        let cust1 = UIView()
        cust1.backgroundColor = UIColor(named: "backGroundColor")
        cust1.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(cust1)
        
        cust1.anchor(
            top: nil,
            leading: nil,
            bottom: self.view.bottomAnchor,
            trailing: safeArea.trailingAnchor,
            padding: UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0),
            size: CGSize(width: 60, height: 30)
        )
        
        //MARK:create undo button
        let undoButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "undo"), for: .normal)
            return button
        }()
        
        self.view.addSubview(undoButton)
        
        undoButton.anchor(
            top: nil,
            leading: safeArea.leadingAnchor,
            bottom: self.view.bottomAnchor,
            trailing: nil,
            padding: UIEdgeInsets(top: 0, left: 40, bottom: 32, right: 0)
        )
        
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

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 255 * multiplikator
        let height = 300 * multiplikator
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftRightInsets: CGFloat = (self.view.frame.width - CGFloat(255 * multiplikator)) / 2
        
        if let layout = collectionViewLayout as? CustomCollectionViewFlowLayout{
            layout.padding = leftRightInsets
        }
        let sectionInsets: UIEdgeInsets = .init(top: 0, left: leftRightInsets, bottom: 0, right: leftRightInsets)
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
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
    
    private func changeFirstLetterStackAfterScrolling() {
        let indexCenter = getCollectionItemIndexOnScreen()
        settColorsForLetterStackName(indexCenter: indexCenter)
        
        for i in 0..<dataShared.playersArray.count{
            if i != indexCenter{
                dataShared.playersArray[i].select = false
            } else {
                guard let indexPathOnScreen = gamerCollectionView.indexPathForItem(
                        at: self.view.convert(self.view.center, to: gamerCollectionView)) else {return}
                dataShared.playersArray[i].select = true
                dataShared.playersArray[i].playersIndex = indexPathOnScreen
                nextIndexPath = indexPathOnScreen
                
                guard let start = UserDefaults.standard.object(forKey: "startBackground") as? CFAbsoluteTime, start != 999 else {return}
                dataShared.gameTime.second = 0
                dataShared.gameTime.minute = 0
            }
        }
    }
    
    private func changePreviousNextButton() {
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
    
    func selectItemAfterResume() {
        for i in 0..<dataShared.playersArray.count{
            if dataShared.playersArray[i].select == true{
                gamerCollectionView.selectItem(at: dataShared.playersArray[i].playersIndex,
                                               animated: true, scrollPosition: .centeredHorizontally)
                nextIndexPath = dataShared.playersArray[i].playersIndex
                break
            }
        }
    }
    
    func timer() {
        timerL.invalidate()

        timerLabel.text = "\(getSecondAndMinuteString()[1]):\(getSecondAndMinuteString()[0])"
        
        timerL = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        RunLoop.current.add(timerL, forMode: .common)
    }
    
    func settDataFromGame() {
        dataHolder = dataShared.playersArray
        dataShared.gameTime.second = 0
        dataShared.gameTime.minute = 0
        gamerCollectionView.selectItem(at: IndexPath(indexes: [0,0]), animated: true, scrollPosition: .centeredHorizontally)
        gamerCollectionView.reloadData()
    }
    
    func settLetterStackView(withRefresh: Bool) {
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
                label.textColor = UIColor(named: "elementBackgroundColor")
            }
            letterStackName.addArrangedSubview(label)
        }
    }
    
    private func settMultiplicator() {
        let viewHeight = self.view.frame.height
        if viewHeight<800 && viewHeight>600{
            multiplikator = 0.8
        }else if viewHeight<600{
            multiplikator = 0.6
        }
    }
    
    private func getCollectionItemIndexOnScreen() -> Int?{
        guard let indexPathOnScreen = gamerCollectionView.indexPathForItem(
                at: self.view.convert(self.view.center, to: gamerCollectionView)) else {return nil}
        let indexCenter = indexPathOnScreen.item
        return indexCenter
    }
    
    private func settColorsForLetterStackName(indexCenter: Int?) {
        let views = letterStackName.arrangedSubviews
        for i in 0..<views.count{
            guard let label = views[i] as? UILabel else {return}
            if i != indexCenter{
                label.textColor = UIColor(named: "elementBackgroundColor")
            }else {
                label.textColor = .white
            }
        }
    }
}

//MARK: Targets
extension GameProcessVC{
    
    @objc func newGameButtonTapped() {
        let newGameVC = NewGameVC()
        newGameVC.gameProcessDelegate = self
        let navVC = UINavigationController(rootViewController: newGameVC)
        navVC.navigationBar.isHidden = true
        present(navVC, animated: true, completion: nil)
    }
    
    @objc func plusButtonTapped(sender: UIButton) {
        guard let indexPathOnScreen = gamerCollectionView.indexPathForItem(
                at: self.view.convert(self.view.center, to: gamerCollectionView)) else {return}
        guard indexPathOnScreen == nextIndexPath else {return}
        let indexCenter = indexPathOnScreen.item
        let plusNumber = Int((sender.titleLabel?.text)!)!
        
        dataShared.playersArray[indexCenter].score += plusNumber
        dataShared.turnsArray.append(
            Turn(player: dataShared.playersArray[indexCenter],
                addScore: (sender.titleLabel?.text)!,
                playersIndex: indexPathOnScreen))
        
        settDataFromGame()
        nextButtonTapped()
    }
    
    @objc func previousButtonTapped() {
        guard var indexPathOnScreen = gamerCollectionView.indexPathForItem(
                at: self.view.convert(self.view.center, to: gamerCollectionView)) else {return}
        if indexPathOnScreen.item == 0{
            indexPathOnScreen.item = dataHolder.count - 1
        }else {
            indexPathOnScreen.item -= 1
        }
        gamerCollectionView.selectItem(at: indexPathOnScreen, animated: true, scrollPosition: .centeredHorizontally)
        nextIndexPath = indexPathOnScreen
    }
    
    @objc func nextButtonTapped() {
        guard var indexPathOnScreen = gamerCollectionView.indexPathForItem(
                at: self.view.convert(self.view.center, to: gamerCollectionView)) else {return}
        if indexPathOnScreen.item == dataHolder.count - 1{
            indexPathOnScreen.item = 0
        }else {
            indexPathOnScreen.item += 1
        }
        gamerCollectionView.selectItem(at: indexPathOnScreen, animated: true, scrollPosition: .centeredHorizontally)
        nextIndexPath = indexPathOnScreen
    }
    
    @objc func undoButtonTapped() {
        guard let lastTurn = dataShared.turnsArray.popLast() else {return}
        dataShared.playersArray[lastTurn.playersIndex.item].score -= Int(lastTurn.addScore)!
        settDataFromGame()
        gamerCollectionView.selectItem(at: lastTurn.playersIndex, animated: true, scrollPosition: .centeredHorizontally)
        nextIndexPath = lastTurn.playersIndex
    }
    
    @objc func resultsButtonTapped() {
        let resultVC = ResultsVC()
        resultVC.multiplikator = multiplikator
        resultVC.gameDelegate = self
        let navVS = UINavigationController(rootViewController: resultVC)
        navVS.navigationBar.isHidden = true
        present(navVS, animated: true, completion: nil)
    }
    
    @objc func playPauseButtonTapped() {
        if dataShared.timerPlay{
            playPauseButton.setImage(UIImage(named: "Play"), for: .normal)
            timerL.invalidate()
            dataShared.timerPlay = false
        } else {
            playPauseButton.setImage(UIImage(named: "Pause"), for: .normal)
            timer()
            dataShared.timerPlay = true
        }
    }
    
    @objc func rollButtonTapped() {
        let rollVC = RollVC()
        rollVC.modalPresentationStyle = .overFullScreen
        show(rollVC, sender: nil)
    }
    
    @objc func tick() {
        dataShared.gameTime.second += 1
        let minute =  Int(dataShared.gameTime.second / 60)
        let seconds = dataShared.gameTime.second % 60
        dataShared.gameTime.minute += minute
        dataShared.gameTime.second = seconds
        timerLabel.text = "\(getSecondAndMinuteString()[1]):\(getSecondAndMinuteString()[0])"
        
        let start = CFAbsoluteTimeGetCurrent()
        halpersClass.saveDataInUserDefaults(valueForStartBackground: start)
    }
    
    private func getSecondAndMinuteString()->[String]{
        let gameTime = dataShared.gameTime
        let secondString = String(gameTime.second).count < 2 ? "0\(String(gameTime.second))" : (String(gameTime.second))
        let minuteString = String(gameTime.minute).count < 2 ? "0\(String(gameTime.minute))" : String(gameTime.minute)
        return [secondString,minuteString]
    }
}
