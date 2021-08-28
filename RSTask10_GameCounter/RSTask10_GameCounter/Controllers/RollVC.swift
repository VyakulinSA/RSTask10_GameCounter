//
//  RollVC.swift
//  RSTask10_GameCounter
//
//  Created by Вякулин Сергей on 28.08.2021.
//

import UIKit

class RollVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addBlurEffect()
        let random = Int.random(in: 1...6)
        showDice(randomNumber: random)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissRollVC))
        self.view.addGestureRecognizer(recognizer)
        
    }
    
    @objc func dismissRollVC() {
        dismiss(animated: true, completion: nil)
    }
    
    private func addBlurEffect(){
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.94
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
    }
    
    private func showDice(randomNumber: Int){
        let imageName = "dice_\(randomNumber)"
        
        let diceImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        self.view.addSubview(diceImageView)
        
        NSLayoutConstraint.activate([
            diceImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            diceImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            diceImageView.heightAnchor.constraint(equalToConstant: 120),
            diceImageView.widthAnchor.constraint(equalToConstant: 120)
        ])
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
//        let tabBarVC = RollVC()
//        //меняем input параметры в соответствии с образцом
//        @available(iOS 13.0, *)
//        func makeUIViewController(context: UIViewControllerRepresentableContext<PeopleVСProvider.ContainerView>) -> RollVC {
//            return tabBarVC
//        }
//        //не пишем никакого кода
//        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        }
//    }
//}