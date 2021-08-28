//
//  GameProcessVC.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 28.08.2021.
//

import UIKit

final class GameProcessVC: UIViewController {
    
    var dataHolder: Array = ["Kate","John","Betty"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.settViews()
        
    }
    
    
    private func settViews(){
        let safeArea = self.view.safeAreaLayoutGuide
        
        //create cancelButton
        let newGameButton = UIButton(type: .system).createBarButton(title: "New Game", font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!)
        
        self.view.addSubview(newGameButton)
        
        newGameButton.anchor(top: safeArea.topAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 6, left: 20, bottom: 0, right: 0))
        
        //create addlButton
        let resultsButton = UIButton(type: .system).createBarButton(title: "Results", font: UIFont(name: CustomFonts.nunitoExtraBold.rawValue, size: 17)!)
        
        self.view.addSubview(resultsButton)
        
        resultsButton.anchor(top: safeArea.topAnchor, leading: nil, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 25))
        
        //create gamelabel
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
        
        
        //create rolllButton
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
        
        //create timerLabel
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
        
        //creeate play / pause button
        let playPauseButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "Pause"), for: .normal)
            return button
        }()
        
        self.view.addSubview(playPauseButton)
        
        playPauseButton.anchor(top: timerLabel.topAnchor, leading: timerLabel.trailingAnchor, bottom: timerLabel.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0), size: CGSize(width: 20, height: 0))
        
        //create collectionView
        
        let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.showsVerticalScrollIndicator = false
            view.showsHorizontalScrollIndicator = false
            
            view.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: "gameCell")
            view.delegate = self
            view.dataSource = self
            view.backgroundColor = .black
            return view
        }()
        
        self.view.addSubview(collectionView)
        
        collectionView.anchor(top: timerLabel.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 42, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 300))
        
        //create previous button
        let previousButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "previous"), for: .normal)
            
            return button
        }()
        
        self.view.addSubview(previousButton)
        
        previousButton.anchor(top: collectionView.bottomAnchor, leading: safeArea.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 58, left: 46, bottom: 0, right: 0))
        
        //create next button
        let nextButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "next"), for: .normal)
            
            return button
        }()
        
        self.view.addSubview(nextButton)
        
        nextButton.anchor(top: collectionView.bottomAnchor, leading: nil, bottom: nil, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 58, left: 0, bottom: 0, right: 46))
        
        //create plusOne button
        let plusOneButton = UIButton(type: .system).createEllipseButton(title: "+1", font: UIFont(name: "Nunito-ExtraBold", size: 40)!, radius: 45, shadow: true)
        
        self.view.addSubview(plusOneButton)
        
        NSLayoutConstraint.activate([
            plusOneButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            plusOneButton.centerYAnchor.constraint(equalTo: previousButton.centerYAnchor),
            plusOneButton.heightAnchor.constraint(equalToConstant: 90),
            plusOneButton.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        //create plusButton stackView
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
            stackView.addArrangedSubview(plusButton)
        }
        
        
        //create firstLetterForName stackView
        let letterStackName: UIStackView = {
            let stack = UIStackView()
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.spacing = 5
            stack.axis = .horizontal
            stack.alignment = .center
            stack.distribution = .fill
            stack.backgroundColor = .black
            return stack
        }()
        
        self.view.addSubview(letterStackName)

        NSLayoutConstraint.activate([
            letterStackName.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            letterStackName.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -28),
            letterStackName.heightAnchor.constraint(equalToConstant: 27),
        ])
        
        
        for name in dataHolder {
            let firstLetter = name.first!.uppercased()
            let label = UILabel()
            label.text = firstLetter
            label.font = UIFont(name: "Nunito-ExtraBold", size: 20)
            label.textColor = .white
            letterStackName.addArrangedSubview(label)
        }
        
        //FIXME: сделать стэк без костылей
        //create support views for stackView
        let cust = UIView()
        cust.backgroundColor = .black
        cust.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(cust)
        
        cust.anchor(top: nil, leading: safeArea.leadingAnchor, bottom: self.view.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0), size: CGSize(width: 60, height: 30))
        
        let cust1 = UIView()
        cust1.backgroundColor = .black
        cust1.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(cust1)
        
        cust1.anchor(top: nil, leading: nil, bottom: self.view.bottomAnchor, trailing: safeArea.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0), size: CGSize(width: 60, height: 30))
        
        //create undo button
        let undoButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "undo"), for: .normal)
            return button
        }()
        
        self.view.addSubview(undoButton)
        
        undoButton.anchor(top: nil, leading: safeArea.leadingAnchor, bottom: self.view.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 40, bottom: 32, right: 0))
    }
    
//    @objc func rollButtonTapped() {
//        let rollVC = RollVC()
//        present(RollVC.self, animated: true, completion: nil)
//    }

}

// MARK: - UICollectionViewDataSource

extension GameProcessVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataHolder.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath)
        
        if let cell = cell as? GameCollectionViewCell {
            cell.settLabels(name: dataHolder[indexPath.item], score: indexPath.item)
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
        
         let sectionInsets: UIEdgeInsets = .init(top: 0, left: leftRightInsets, bottom: 0, right: leftRightInsets)
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
}

// MARK: - UICollectionViewDelegate

extension GameProcessVC: UICollectionViewDelegate {
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let type = presenter.type(at: indexPath.item)
//        switch type {
//        case .gallery(let gallery):
//            let presenter = RSGalleryPresenter(gallery: gallery)
//            let controller = RSGalleryViewController(presenter: presenter)
//            controller.modalPresentationStyle = .fullScreen
//            present(controller, animated: true)
//        case .story(let story):
//            let presenter = RSStoryPresenter(story: story)
//            let controller = RSStoryViewController(presenter: presenter)
//            controller.modalPresentationStyle = .fullScreen
//            present(controller, animated: true)
//        }
//    }
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
