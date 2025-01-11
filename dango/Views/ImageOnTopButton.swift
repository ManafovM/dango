//
//  ImageOnTopButton.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/10.
//

import UIKit

class ImageOnTopButton: UIButton {
    let title: String
    let image: UIImage?
    let tappedImage: UIImage?
    var onTap: (() -> Void)?
    
    init(title: String, imageName: String, tappedImageName: String = "", onTap: (() -> Void)? = nil) {
        self.title = title
        self.image = UIImage(systemName: imageName)
        self.tappedImage = UIImage(systemName: tappedImageName)
        self.onTap = onTap
        
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        var config = UIButton.Configuration.filled()
        config.imagePlacement = .top
        config.imagePadding = 8
        config.baseBackgroundColor = Color.darkBackground.value
        
        let font = UIFont.systemFont(ofSize: 14, weight: .light)
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: font]))
        self.configuration = config
        
        self.setImage(image, for: .normal)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func animateImageTransition(startTransform: CGAffineTransform, endTransform: CGAffineTransform, newImage: UIImage?) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
            self.imageView?.transform = startTransform
            self.imageView?.alpha = 0
        }) { _ in
            self.setImage(newImage, for: .normal)
            self.imageView?.transform = .identity
            self.imageView?.transform = endTransform
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.imageView?.transform = .identity
                self.imageView?.alpha = 1
            })
        }
    }
    
    func toggle() {
        if self.currentImage == self.image {
            self.setImage(self.tappedImage, for: .normal)
        } else {
            self.setImage(self.image, for: .normal)
        }
    }
    
    func toggleWithAnimation() {
        if self.currentImage == self.image {
            animateImageTransition(startTransform: CGAffineTransform(rotationAngle: .pi / 2), endTransform: CGAffineTransform(rotationAngle: -(.pi / 2)), newImage: self.tappedImage)
        } else {
            animateImageTransition(startTransform: CGAffineTransform(rotationAngle: -(.pi / 2)), endTransform: CGAffineTransform(rotationAngle: .pi / 2), newImage: self.image)
        }
    }
    
    @objc
    func buttonTapped() {
        onTap?()
    }
}
