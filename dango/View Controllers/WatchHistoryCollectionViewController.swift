//
//  WatchHistoryCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/11.
//

import UIKit

class WatchHistoryCollectionViewController: BaseCollectionViewController {
    var videoDetailsViewController: VideoDetailsViewController!
    
    var videos: [Video] {
        Settings.shared.watchHistory
    }
    
    init() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5 / 16 * 9))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 12
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)
        collectionView.register(NamedSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NamedSectionHeaderView.identifier)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for: indexPath) as! VideoCollectionViewCell
        
        let item = videos[indexPath.item]
        cell.configureCell(item)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NamedSectionHeaderView.identifier, for: indexPath) as! NamedSectionHeaderView
        header.nameLabel.text = "視聴履歴"
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = videos[indexPath.item]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle(for: VideoDetailsViewController.self))
        videoDetailsViewController = storyBoard.instantiateViewController(identifier: "VideoDetailsViewController") { coder in
            VideoDetailsViewController(coder: coder, video: item)
        }
        
        let navigationController = UINavigationController(rootViewController: videoDetailsViewController)
        navigationController.navigationBar.topItem?.leftBarButtonItem = CloseButton {
            self.videoDetailsViewController.dismiss(animated: true)
        }
        
        present(navigationController, animated: true, completion: nil)
    }
}
