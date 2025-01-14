//
//  VideoDetailsTopImageView.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/15.
//

import UIKit

class VideoDetailsTopImageView: FadeEdgeImageView {
    var imageRequestTask: Task<Void, Never>? = nil
    deinit { imageRequestTask?.cancel() }
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialDark))
    
    var defaultHeight: CGFloat = 220
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupBlurEffectView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageView() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    func setupBlurEffectView() {
        visualEffectView.alpha = 0
        addSubview(visualEffectView)
    }
    
    func loadImage(from url: String) {
        imageRequestTask = Task {
            if let image = try? await ImageRequest(imageUrl: url).send() {
                self.image = image
            }
            imageRequestTask = nil
        }
    }
    
    func updateFrameForOffset(_ yOffset: CGFloat, parentFrameWidth: CGFloat) {
        if yOffset < 0 {
            frame = CGRect(
                x: yOffset / 2,
                y: yOffset,
                width: parentFrameWidth - yOffset,
                height: defaultHeight - yOffset
            )
        } else {
            let shrinkFactor = max(0, defaultHeight - yOffset)
            frame = CGRect(
                x: 0,
                y: 0,
                width: parentFrameWidth,
                height: shrinkFactor
            )
        }
        
        let blurAlpha = min(1.0, yOffset / defaultHeight)
        visualEffectView.alpha = blurAlpha
        visualEffectView.frame = CGRect(
            x: frame.origin.x,
            y: frame.origin.y,
            width: frame.width,
            height: max(frame.height, 2)
        )
    }
}
