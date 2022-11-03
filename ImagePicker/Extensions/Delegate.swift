//
//  NAVIGAte.swift
//  ImagePicker
//
//  Created by Роман Денисенко on 2.11.22.
//

import Foundation
import UIKit

extension GalleryViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        var name:String?
        if let imageName = info[.imageURL] as? URL{
            name = imageName.lastPathComponent
        }
        setImage(image,withName: name)
        self.presentedViewController?.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.presentedViewController?.dismiss(animated: true)
        let alert = UIAlertController(title: "Error", message: "Choose Image", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style:.default)
        alert.addAction(okAction)
        present(alert,animated: true)
    }
}
