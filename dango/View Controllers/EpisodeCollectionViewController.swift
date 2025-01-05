//
//  EpisodeCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/05.
//

import UIKit

class EpisodeCollectionViewController: UICollectionViewController {
    let episodes: [Episode]!
    
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
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
        collectionView.backgroundColor = Color.darkBackground.value
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
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
}
