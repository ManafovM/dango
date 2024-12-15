//
//  VideoDetailsTopImageView.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/15.
//

import UIKit

class VideoDetailsTopImageView: UIView {
    var imageRequestTask: Task<Void, Never>? = nil
    deinit { imageRequestTask?.cancel() }
    
    let imageView = FadeEdgeImageView()
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialDark))
    
    var defaultHeight: CGFloat = 220
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        setupBlurEffectView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImage() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
    }
    
    func setupBlurEffectView() {
        visualEffectView.alpha = 0
        imageView.addSubview(visualEffectView)
    }
    
    func loadImage(from path: String) {
        imageRequestTask = Task {
            if let image = try? await ImageRequest(imagePath: path).send() {
                self.imageView.image = image
            }
            imageRequestTask = nil
        }
    }
    
    func updateFrameForOffset(_ yOffset: CGFloat) {
        if yOffset < 0 {
            imageView.frame = CGRect(
                x: yOffset / 2,
                y: yOffset,
                width: frame.width - yOffset,
                height: defaultHeight - yOffset
            )
        } else {
            let shrinkFactor = max(0, defaultHeight - yOffset)
            imageView.frame = CGRect(
                x: 0,
                y: 0,
                width: frame.width,
                height: shrinkFactor
            )
        }
        
        let blurAlpha = min(1.0, yOffset / defaultHeight)
        visualEffectView.alpha = blurAlpha
        visualEffectView.frame = CGRect(
            x: imageView.frame.origin.x,
            y: imageView.frame.origin.y,
            width: imageView.frame.width,
            height: max(imageView.frame.height, 2)
        )
    }
}
