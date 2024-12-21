//
//  VideoCollectionViewCell.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/08.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    static let identifier = "VideoCollectionViewCell"
    
    var imageRequestTask: Task<Void, Never>? = nil
    deinit { imageRequestTask?.cancel() }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
    func configureCell(_ video: Video) {
        imageRequestTask = Task {
            if let image = try? await ImageRequest(imagePath: video.thumbnailUrl).send() {
                self.imageView.image = image
            }
            imageRequestTask = nil
        }
    }
}
