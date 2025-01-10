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
    var onTap: (() -> Void)?
    
    init(title: String, imageName: String, onTap: (() -> Void)? = nil) {
        self.title = title
        self.image = UIImage(systemName: imageName)
        self.onTap = onTap
        
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        var config = UIButton.Configuration.filled()
        config.image = image
        config.imagePlacement = .top
        config.imagePadding = 8
        config.baseBackgroundColor = Color.darkBackground.value
        
        let font = UIFont.systemFont(ofSize: 14, weight: .light)
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: font]))
        
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        self.configuration = config
    }
    
    @objc
    func buttonTapped() {
        onTap?()
    }
}
