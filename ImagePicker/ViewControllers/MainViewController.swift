//
//  ViewController.swift
//  ImagePicker
//
//  Created by Роман Денисенко on 1.11.22.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Private properties
    private let lockImage = UIImage(named: "lock")
    private lazy var lock = UIImageView(image: lockImage)
    
    // MARK: - IBOutlets
    @IBOutlet weak var UnlockButton: UIButton!
    @IBOutlet weak var pinField: UITextField!
    @IBOutlet weak var secretQuestionField: UITextField!
    @IBOutlet weak var secretQuestionLabel: UILabel!
    @IBOutlet weak var secretQuestionButton: UIButton!
    
    // MARK: - Override methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if StorageManager.shared.isFirstLoad == true{
            pinField.placeholder = "Create new PIN"
            secretQuestionField.placeholder = " Enter your favourite food"
        } else{
            pinField.placeholder = "Enter your PIN"
            secretQuestionField.isHidden = true
            secretQuestionLabel.isHidden = true
        }
        
        UnlockButton.layer.cornerRadius = 15
        secretQuestionButton.layer.cornerRadius = 15
        pinField.dropShadow()
        secretQuestionField.dropShadow()
        
        lock.frame.size = CGSize(width: 30, height: 30)
        lock.center.x = view.center.x
        lock.center.y = pinField.center.y + 60
        view.addSubview(lock)
        
        let closeKeyBoard = UITapGestureRecognizer(target: self, action: #selector(closeKeyBoard))
        view.addGestureRecognizer(closeKeyBoard)
    }
    // MARK: - Private methods
    private func animateLock(){
        UIButton.animate(withDuration: 0.05, delay: 0,options:.curveLinear, animations:{
                          self.lock.center.x -= 4},completion: {_ in
        UIButton.animate(withDuration: 0.1, delay: 0,options:.curveLinear, animations:{
                          self.lock.center.x += 8}, completion: {_ in
        UIButton.animate(withDuration: 0.05, delay: 0,options:.curveLinear, animations:{
                          self.lock.center.x -= 4
                        })
                     })
                  })
    }
    
    @objc private func closeKeyBoard(){
        view.endEditing(true)
    }
    
    // MARK: - IBActions
    @IBAction func unlockButton(_ sender: UIButton) {
        if StorageManager.shared.isFirstLoad == true{
            guard pinField.text != "" && secretQuestionField.text != "" else  {
                animateLock()
                return
            }
            StorageManager.shared.pinCode = pinField.text ?? ""
            StorageManager.shared.questionAnswer = secretQuestionField.text ?? ""
            StorageManager.shared.isFirstLoad = false
        } else{
            guard pinField.text == StorageManager.shared.pinCode else {
              animateLock()
                return
            }
        }
        let gallery = GalleryViewController()
        let navigation = UINavigationController (rootViewController: gallery)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated:true)
    }
    
    @IBAction func secretQuestionButton(_ sender: UIButton) {
        let destinationVC = QuestionViewController()
        present(destinationVC,animated: true)
    }
}


