//
//  VideoCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import UIKit

class VideoCollectionViewController: BaseCollectionViewController {
    
    var featuredRequestTask: Task<Void, Never>? = nil
    var recommendationsRequestTask: Task<Void, Never>? = nil
    deinit {
        featuredRequestTask?.cancel()
        recommendationsRequestTask?.cancel()
    }
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item.ID>
    
    enum ViewModel {
        enum Section: Hashable, Comparable {
            case featured
            case recommendation(name: String, description: String)
            
            static func < (lhs: Section, rhs: Section) -> Bool {
                switch (lhs, rhs) {
                case (.recommendation(let l, _), .recommendation(let r, _)):
                    return l < r
                case (.featured, _):
                    return true
                case (_, .featured):
                    return false
                }
            }
        }
        
        typealias Item = Video
    }
    
    struct Model {
        var featured = [Video]()
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
        featuredRequestTask?.cancel()
        featuredRequestTask = Task {
            if let featured = try? await FeaturedVideosRequest().send() {
                self.model.featured = featured
            } else {
                self.model.featured = []
            }
            self.updateCollectionView()
            
            featuredRequestTask = nil
        }
        
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
        var itemsBySection = Dictionary(uniqueKeysWithValues: model.recommendations.map { recommendation in
            let section: ViewModel.Section = .recommendation(name: recommendation.name, description: recommendation.description ?? "")
            return (section, recommendation.videos)
        })
        itemsBySection[.featured] = model.featured
        
        items = itemsBySection.values.reduce([], +)
        
        let sectionIDs = itemsBySection.keys.sorted()
        
        dataSource.applySnapshotUsing(sectionIDs: sectionIDs, itemsBySection: itemsBySection.mapValues({ $0.map(\.id) }))
    }
    
    func createDataSource() -> DataSourceType {
        let cellRegistration = UICollectionView.CellRegistration<VideoCollectionViewCell, ViewModel.Item.ID> { [weak self] cell, indexPath, itemIdentifier in
            guard let self, let item = items.first(where: { $0.id == itemIdentifier }) else { return }
            cell.configureCell(item)
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
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            
            switch section {
            case .featured:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .fractionalWidth(0.92 / 16 * 9))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 8, trailing: 8)
                section.interGroupSpacing = 10
                
                return section
            case .recommendation:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5 / 16 * 9))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: RecommendationHeader.kind.identifier, alignment: .top)
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
                section.interGroupSpacing = 12
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
            }
        }
        
        return layout
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemIdentifier = dataSource.itemIdentifier(for: indexPath),
              let item = items.first(where: { $0.id == itemIdentifier }) else { return }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle(for: VideoDetailsViewController.self))
        let controller = storyBoard.instantiateViewController(identifier: "VideoDetailsViewController") { coder in
            VideoDetailsViewController(coder: coder, video: item)
        }
        
        present(controller, animated: true, completion: nil)
    }
}
