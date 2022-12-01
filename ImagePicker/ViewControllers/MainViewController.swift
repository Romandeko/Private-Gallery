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
    @IBOutlet weak var UnlockButton: UIButton!
    @IBOutlet weak var pinField: UITextField!
    @IBOutlet weak var faceIDOutlet: UIButton!
    @IBOutlet weak var showPinOutlet: UIButton!

    // MARK: - Override methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pinField.delegate = self
        if StorageManager.shared.isFirstLoad == true{
            pinField.placeholder = "Create new PIN"
        } else{
            pinField.placeholder = "Enter your PIN"
        }
        buttonSettings()

        let closeKeyBoard = UITapGestureRecognizer(target: self, action: #selector(closeKeyBoard))
        view.addGestureRecognizer(closeKeyBoard)
    }
    
    // MARK: - Private methods
    @objc private func closeKeyBoard(){
        view.endEditing(true)
    }
    
    private func animateLock(){
        UIButton.animate(withDuration: 0.05, delay: 0, options:.curveLinear, animations:{
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
        showPinOutlet.isEnabled = false
        showPinOutlet.setImage(UIImage(systemName: "eye"), for: .normal)
        showPinOutlet.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        UnlockButton.layer.cornerRadius = 15
        faceIDOutlet.layer.cornerRadius = 15
        pinField.dropShadow()
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
    @IBAction func unlockButton(_ sender: UIButton) {
        if StorageManager.shared.isFirstLoad == true{
            guard pinField.text?.count == 4  else  {
                animateLock()
                return
            }
            StorageManager.shared.pinCode = pinField.text ?? ""
            StorageManager.shared.isFirstLoad = false
            
        } else{
            guard pinField.text == StorageManager.shared.pinCode else {
                animateLock()
                  return
              }
        }
      navigateToGallery()
    }
    
    @IBAction func faceIDButton(_ sender: UIButton) {
        authenticate()
    }
    @IBAction func showPinButton(_ sender: Any) {
        pinField.isSecureTextEntry.toggle()
    showPinOutlet.isSelected = !pinField.isSecureTextEntry
    }
}


