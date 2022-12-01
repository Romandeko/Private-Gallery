//
//  TextFieldDelegate.swift
//  ImagePicker
//
//  Created by Роман Денисенко on 30.11.22.
//

import Foundation
import UIKit
extension MainViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        showPinOutlet.isEnabled = (pinField.text?.count ?? 0) > 0
        if pinField.text?.count ?? 0 > 4{
            pinField.text?.removeLast()
        }
    }
}
