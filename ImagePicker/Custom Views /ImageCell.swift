//
//  ImageCell.swift
//  ImagePicker
//
//  Created by Роман Денисенко on 29.11.22.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let identifier = "ImageCell"
    @IBOutlet weak var imageView: UIImageView!
    public func configure(withImage image : UIImage){
        imageView.image = image
    }
    static func nib() -> UINib{
        return UINib(nibName: "ImageCell", bundle: nil)
    }
}
