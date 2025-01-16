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
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    init(title: String, backgroundColor: UIColor = Color.darkBackground.value, imageName: String, tappedImageName: String = "", onTap: (() -> Void)? = nil) {
        self.title = title
        self.image = UIImage(systemName: imageName)
        self.tappedImage = UIImage(systemName: tappedImageName)
        self.onTap = onTap
        
        super.init(frame: .zero)
        setupButton(backgroundColor: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton(backgroundColor: UIColor) {
        var config = UIButton.Configuration.filled()
        config.imagePlacement = .top
        config.imagePadding = 8
        config.baseBackgroundColor = backgroundColor
        
        let font = UIFont.systemFont(ofSize: 14, weight: .light)
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: font]))
        configuration = config
        
        setImage(image, for: .normal)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        feedbackGenerator.prepare()
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
        if currentImage == image {
            setImage(tappedImage, for: .normal)
        } else {
            setImage(image, for: .normal)
        }
    }
    
    func toggleWithAnimation() {
        if currentImage == image {
            animateImageTransition(startTransform: CGAffineTransform(rotationAngle: .pi / 2), endTransform: CGAffineTransform(rotationAngle: -(.pi / 2)), newImage: tappedImage)
        } else {
            animateImageTransition(startTransform: CGAffineTransform(rotationAngle: -(.pi / 2)), endTransform: CGAffineTransform(rotationAngle: .pi / 2), newImage: image)
        }
    }
    
    @objc
    func buttonTapped() {
        feedbackGenerator.impactOccurred()
        onTap?()
    }
}
