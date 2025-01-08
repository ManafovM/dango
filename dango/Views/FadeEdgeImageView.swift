//
//  FadeEdgeImageView.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/11.
//

import UIKit

class FadeEdgeImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        applyFadeEffect()
    }

    private func applyFadeEffect() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        
        gradientLayer.colors = [
            Color.darkBackground.value.cgColor,
            UIColor.clear.cgColor
        ]
        
        gradientLayer.locations = [0.7, 1]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        layer.mask = gradientLayer
    }
}
