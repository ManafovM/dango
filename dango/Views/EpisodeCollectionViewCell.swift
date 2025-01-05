//
//  EpisodeCollectionViewCell.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/05.
//

import UIKit

class EpisodeCollectionViewCell: UICollectionViewCell {
    static let identifier = "EpisodeCollectionViewCell"
    
    var imageRequestTask: Task<Void, Never>? = nil
    deinit { imageRequestTask?.cancel() }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10.0
    }
    
    func configureCell(_ episode: Episode) {
        imageRequestTask = Task {
            if let image = try? await ImageRequest(imagePath: episode.thumbnailUrl).send() {
                self.imageView.image = image
            }
            imageRequestTask = nil
        }
        titleLabel.text = "第\(episode.number)話 \(episode.title)"
        descriptionLabel.text = episode.description
    }
}
