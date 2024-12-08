//
//  VideoCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import UIKit

private let reuseIdentifier = "Cell"

class VideoCollectionViewController: UICollectionViewController {
    
    var recommendationsRequestTask: Task<Void, Never>? = nil
    deinit { recommendationsRequestTask?.cancel() }
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item.ID>
    
    enum ViewModel {
        enum Section: Hashable, Comparable {
            case recommendation(name: String, description: String)
            
            static func < (lhs: Section, rhs: Section) -> Bool {
                switch (lhs, rhs) {
                case (.recommendation(let l, _), .recommendation(let r, _)):
                    return l < r
                }
            }
        }
        
        typealias Item = Video
    }
    
    struct Model {
        var recommendations = [Recommendation]()
    }
    
    var dataSource: DataSourceType!
    var model = Model()
    var items: [ViewModel.Item] = []
    
    enum RecommendationHeader: String {
        case kind = "RecommendationHeader"
        
        var identifier: String {
            return rawValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        update()
    }
    
    func update() {
        recommendationsRequestTask?.cancel()
        recommendationsRequestTask = Task {
            if let recommendations = try? await RecommendationsRequest().send() {
                self.model.recommendations = recommendations
            } else {
                self.model.recommendations = []
            }
            self.updateCollectionView()
            
            recommendationsRequestTask = nil
        }
    }
    
    func updateCollectionView() {
        let itemsBySection = Dictionary(uniqueKeysWithValues: model.recommendations.map { recommendation in
            let section: ViewModel.Section = .recommendation(name: recommendation.name, description: recommendation.description ?? "")
            return (section, recommendation.videos)
        })
        items = itemsBySection.values.reduce([], +)
        
        let sectionIDs = itemsBySection.keys.sorted()
        
        dataSource.applySnapshotUsing(sectionIDs: sectionIDs, itemsBySection: itemsBySection.mapValues({ $0.map(\.id) }))
    }
    
    func createDataSource() -> DataSourceType {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ViewModel.Item.ID> { [weak self] cell, indexPath, itemIdentifier in
            guard let self, let item = items.first(where: { $0.id == itemIdentifier }) else { return }
            
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            content.secondaryText = item.description
            cell.contentConfiguration = content
        }
        
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<NamedSectionHeaderView>(elementKind: RecommendationHeader.kind.identifier) { headerView, elementKind, indexPath in
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            if case let .recommendation(name, description) = section {
                headerView.nameLabel.text = name
            }
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        return dataSource
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: RecommendationHeader.kind.identifier, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
