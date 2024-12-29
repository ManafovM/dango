//
//  CastCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/29.
//

import UIKit

class CastCollectionViewController: UICollectionViewController {
    let cast: [Artist]!
    
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Artist> { cell, indexPath, item in
        var config = cell.defaultContentConfiguration()
        config.text = item.role
        config.secondaryText = item.name
        config.prefersSideBySideTextAndSecondaryText = true
        cell.contentConfiguration = config
        
        var backgroundConfig = UIBackgroundConfiguration.listCell()
        backgroundConfig.backgroundColor = Color.background.value
        backgroundConfig.cornerRadius = 12
        backgroundConfig.strokeColor = .lightGray.withAlphaComponent(0.5)
        backgroundConfig.strokeWidth = 1 / UIScreen.main.scale
        cell.backgroundConfiguration = backgroundConfig
    }
    
    init?(coder: NSCoder, cast: [Artist]) {
        self.cast = cast
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(cast.count, 5)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = cast[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    
        cell.accessories = [
            .disclosureIndicator(options: .init(tintColor: .systemGray))
        ]
    
        return cell
    }
}
