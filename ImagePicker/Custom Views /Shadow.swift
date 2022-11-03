

import Foundation
import UIKit
extension UITextField {
    func dropShadow (scale : Bool = true){
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
    }
}
