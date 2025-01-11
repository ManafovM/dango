//
//  CastCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/29.
//

import UIKit

class CastCollectionViewController: BaseCollectionViewController {
    let cast: [Artist]!
    
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Artist> { cell, indexPath, item in
        var config = cell.defaultContentConfiguration()
        
        let attributedText = NSMutableAttributedString(string: item.role)
        attributedText.append(NSAttributedString(string: "                              "))
        attributedText.append(NSAttributedString(string: item.name))
        config.attributedText = attributedText
        config.textProperties.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        cell.contentConfiguration = config
        
        var backgroundConfig = UIBackgroundConfiguration.listCell()
        backgroundConfig.backgroundColor = Color.background.value
        backgroundConfig.cornerRadius = 12
        backgroundConfig.strokeColor = .lightGray.withAlphaComponent(0.5)
        backgroundConfig.strokeWidth = 1 / UIScreen.main.scale
        cell.backgroundConfiguration = backgroundConfig
    }
    
    init(cast: [Artist]) {
        self.cast = cast
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 6
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(NamedSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NamedSectionHeaderView.identifier)
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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NamedSectionHeaderView.identifier, for: indexPath) as! NamedSectionHeaderView
        header.nameLabel.text = "キャスト・スタッフ"
        return header
    }
}
