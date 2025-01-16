//
//  CloseButton.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/09.
//

import UIKit

class CloseButton: UIBarButtonItem {
    var onTap: (() -> Void)?
    
    init(onTap: (() -> Void)? = nil) {
        self.onTap = onTap
        super.init()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButton() {
        let closeButton = UIButton(type: .custom)
        closeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let xmark = UIImage(systemName: "xmark")
        let smallXmark = xmark?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .small))
        closeButton.setImage(smallXmark, for: .normal)
        
        closeButton.tintColor = .white
        closeButton.backgroundColor = .systemGray4
        closeButton.layer.cornerRadius = 15
        
        closeButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        customView = closeButton
    }
    
    @objc
    func buttonTapped() {
        onTap?()
    }
}
