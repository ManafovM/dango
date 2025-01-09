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
    var videoPlayer: AVPlayer!
    var playerViewController = AVPlayerViewController()
    
    init?(coder: NSCoder, episodes: [Episode]) {
        self.episodes = episodes
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: EpisodeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: EpisodeCollectionViewCell.identifier)
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func setupVideoPlayer(videoUrl: String) {
        let videoUrl = URL(string: videoUrl)!
        videoPlayer = AVPlayer(url: videoUrl)
        playerViewController.player = videoPlayer
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
        let episode = episodes[indexPath.item]
        setupVideoPlayer(videoUrl: episode.videoUrl)
        
        present(self.playerViewController, animated: true) {
            guard let windowScene = self.playerViewController.view.window?.windowScene else { return }
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
            self.videoPlayer.play()
        }
    }
}
