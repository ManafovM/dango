//
//  EpisodeCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/05.
//

import UIKit
import AVKit

class EpisodeCollectionViewController: BaseCollectionViewController {
    let episodes: [Episode]!
    var currentEpisode: Episode!
    var videoPlayer: AVPlayer!
    var playerViewController = AVPlayerViewController()
    
    init(episodes: [Episode]) {
        self.episodes = episodes
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: EpisodeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: EpisodeCollectionViewCell.identifier)
    }
    
    func setupVideoPlayer(videoUrl: String) {
        let videoUrl = URL(string: videoUrl)!
        videoPlayer = AVPlayer(url: videoUrl)
        playerViewController.player = videoPlayer
        playerViewController.delegate = self
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCollectionViewCell.identifier, for: indexPath) as! EpisodeCollectionViewCell
        
        let item = episodes[indexPath.item]
        cell.configureCell(item)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentEpisode = episodes[indexPath.item]
        setupVideoPlayer(videoUrl: currentEpisode.videoUrl)
        
        present(playerViewController, animated: true) { [weak self] in
            guard let self else { return }
            videoPlayer.play()
            
            if let watchHistory = Settings.shared.watchHistory.first(where: { $0.videoId == self.currentEpisode.videoId }),
               let timestamp = watchHistory.episodesTimestamps[currentEpisode.number] {
                let seekTime = CMTime(seconds: Double(timestamp), preferredTimescale: 600)
                videoPlayer.seek(to: seekTime)
            }
        }
    }
}

extension EpisodeCollectionViewController: AVPlayerViewControllerDelegate {
    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: any UIViewControllerTransitionCoordinator) {
        let currentTime = videoPlayer.currentTime().seconds
        Settings.shared.watched(videoId: self.currentEpisode.videoId, episodeNum: self.currentEpisode.number, timestampSec: Int(currentTime))
    }
}
