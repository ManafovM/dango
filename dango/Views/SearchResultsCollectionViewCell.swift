//
//  SearchResultsCollectionViewCell.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/09.
//

import UIKit

class SearchResultsCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchResultsCollectionViewCell"
    
    var imageRequestTask: Task<Void, Never>? = nil
    deinit { imageRequestTask?.cancel() }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .white
        label.numberOfLines = 3
        
        return label
    }()
    
    let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .lightGray.withAlphaComponent(0.5)
        divider.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        
        return divider
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
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 16/9)
        ])
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureCell(_ video: Video) {
        imageRequestTask = Task {
            if let image = try? await ImageRequest(imagePath: video.thumbnailUrl).send() {
                self.imageView.image = image
            }
            imageRequestTask = nil
        }
        
        titleLabel.text = video.title
        descriptionLabel.text = video.description
    }
}
