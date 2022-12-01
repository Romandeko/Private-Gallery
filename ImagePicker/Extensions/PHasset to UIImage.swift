//
//  PHasset to UIImage.swift
//  ImagePicker
//
//  Created by Роман Денисенко on 1.12.22.
//

import Foundation
import UIKit
import Photos
extension PHAsset {
    func getAssetThumbnail() -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: self,
                             targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
                             contentMode: .aspectFit,
                             options: option,
                             resultHandler: {(result, info) -> Void in
            thumbnail = result!
        })
        return thumbnail
    }
}
