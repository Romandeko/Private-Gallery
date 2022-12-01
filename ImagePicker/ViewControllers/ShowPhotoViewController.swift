//
//  showPhotoViewController.swift
//  ImagePicker
//
//  Created by Роман Денисенко on 30.11.22.
//

import UIKit

class ShowPhotoViewController: UIViewController,UIScrollViewDelegate {
    let size : CGFloat = 60
    let myImageView = UIImageView()
    
    private let scrollView = UIScrollView()
    private let dismissButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp(){
        scrollView.delegate = self
        scrollView.maximumZoomScale = 60.0
        scrollView.minimumZoomScale = 1.0
        scrollView.backgroundColor = .white
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(scrollView)
        
        myImageView.contentMode = .scaleAspectFit
        myImageView.frame.origin.x = scrollView.frame.origin.x
        myImageView.frame.origin.y = scrollView.frame.origin.y
        myImageView.frame.size = scrollView.frame.size
        myImageView.isUserInteractionEnabled = true
        scrollView.addSubview(myImageView)
        
        dismissButton.frame.size = CGSize(width: size, height: size)
        dismissButton.setImage(UIImage(systemName: "xmark.circle"),for: .normal)
        dismissButton.frame.origin.x = view.frame.size.width - size
        dismissButton.frame.origin.y = size / 2
        view.addSubview(dismissButton)
        view.bringSubviewToFront(dismissButton)
        
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    @objc private func dismissVC(){
        dismiss(animated: true)
    }
    
    internal func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return myImageView
    }
}





