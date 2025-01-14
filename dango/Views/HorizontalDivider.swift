//
//  HorizontalDivider.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/10.
//

import UIKit

class HorizontalDivider: UIView {
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .lightGray.withAlphaComponent(0.5)
        heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
    }
}
