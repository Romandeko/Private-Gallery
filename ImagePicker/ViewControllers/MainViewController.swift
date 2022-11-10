//
//  ViewController.swift
//  ImagePicker
//
//  Created by Роман Денисенко on 1.11.22.
//

import UIKit
import LocalAuthentication

class MainViewController: UIViewController {
    // MARK: - Private properties
    private let lockImage = UIImage(named: "lock")
    private lazy var lock = UIImageView(image: lockImage)

    // MARK: - IBOutlets
    @IBOutlet weak var faceIDButton: UIButton!
    @IBOutlet weak var showPinButton: UIButton!
    @IBOutlet weak var UnlockButton: UIButton!
    @IBOutlet weak var pinField: UITextField!
    @IBOutlet weak var secretQuestionField: UITextField!
    @IBOutlet weak var secretQuestionButton: UIButton!
    @IBOutlet weak var secretBottomConstraint: NSLayoutConstraint!
 
    // MARK: - Override methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pinField.delegate = self
        if StorageManager.shared.isFirstLoad == true{
            pinField.placeholder = "Create new PIN"
            secretQuestionField.placeholder = " Enter your favourite beer"
        } else{
            pinField.placeholder = "Enter your PIN"
            secretQuestionField.isHidden = true
            secretQuestionButton.isHidden = false
        }
        buttonSettings()
        registerKeyboardNotifications()
        let closeKeyBoard = UITapGestureRecognizer(target: self, action: #selector(closeKeyBoard))
        view.addGestureRecognizer(closeKeyBoard)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private methods
    private func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Foundation.Notification){
        guard let userInfo = notification.userInfo else {
            return
        }
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as  AnyObject).cgRectValue.size
        secretBottomConstraint.constant =  60 + keyboardSize.height
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: Foundation.Notification){
        secretBottomConstraint.constant = 60
        view.layoutIfNeeded()
    }
    
    @objc private func closeKeyBoard(){
        view.endEditing(true)
    }
    
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
    
    private func buttonSettings(){
        showPinButton.isEnabled = false
        showPinButton.setImage(UIImage(systemName: "eye"), for: .normal)
        showPinButton.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        UnlockButton.layer.cornerRadius = 15
        faceIDButton.layer.cornerRadius = 15
        secretQuestionButton.layer.cornerRadius = 15
        pinField.dropShadow()
        secretQuestionField.dropShadow()
        lock.frame.size = CGSize(width: 30, height: 30)
        lock.center.x = view.center.x
        lock.center.y = pinField.center.y + 40
        view.addSubview(lock)
    }
   
    func authenticate(){
        let context = LAContext()
        var error: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {  [weak self] in
                    guard success, error == nil else{
                        return
                    }
                    self?.navigateToGallery()
                }
            }
        } else {

            let alert = UIAlertController(title: "Unavailable", message: "FaceID Auth not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
    private func navigateToGallery(){
        let gallery = GalleryViewController()
        let navigation = UINavigationController (rootViewController: gallery)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated:true)
    }
    
    // MARK: - IBActions
    @IBAction public func unlockButton(_ sender: Any) {
        if StorageManager.shared.isFirstLoad == true{
            guard pinField.text?.count == 4 && secretQuestionField.text != "" else  {
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
      navigateToGallery()
    }
    
    @IBAction func secretQuestionButton(_ sender: UIButton) {
        let destinationVC = QuestionViewController()
        present(destinationVC,animated: true)
    }
    
    @IBAction func showPin(_ sender: UIButton) {
            pinField.isSecureTextEntry.toggle()
        showPinButton.isSelected = !pinField.isSecureTextEntry
    }
    
    @IBAction func unlockWithFaceID(_ sender: UIButton) {
        authenticate()
    }
}

