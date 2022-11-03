//
//  SecretQuestionViewController.swift
//  ImagePicker
//
//  Created by Роман Денисенко on 3.11.22.
//

import UIKit

class QuestionViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var questionField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var getPINButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        questionField.dropShadow()
        questionField.placeholder = "Enter answer to secret question"
        getPINButton.layer.cornerRadius = 15
    }
    
    // MARK: - IBActions
    @IBAction func getPINButton(_ sender: UIButton) {
        if questionField.text == StorageManager.shared.questionAnswer{
            answerLabel.isHidden = false
            answerLabel.text = StorageManager.shared.pinCode
        }
    }
    
}
