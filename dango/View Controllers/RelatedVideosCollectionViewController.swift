//
//  VideoDetailsCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/18.
//

import UIKit

class RelatedVideosCollectionViewController: UICollectionViewController {
    var relatedRequestTask: Task<Void, Never>? = nil
    deinit { relatedRequestTask?.cancel() }
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item.ID>
    
    enum ViewModel {
        enum Section: Hashable {
            case related
        }
        
        typealias Item = Video
    }
    
    struct Model {
        var related = [Video]()
    }
    
    var dataSource: DataSourceType!
    var model = Model()
    var items: [ViewModel.Item] = []

    init() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .fractionalWidth(0.5 / 16 * 9))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 12, trailing: 16)
        section.interGroupSpacing = 12
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        update()
    }
    
    func update() {
        relatedRequestTask?.cancel()
        relatedRequestTask = Task {
            if let related = try? await RelatedVideosRequest().send() {
                self.model.related = related
            } else {
                self.model.related = []
            }
            self.updateCollectionView()
            
            relatedRequestTask = nil
        }
    }
    
    func updateCollectionView() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.related])
        snapshot.appendItems(model.related.map(\.id), toSection: .related)
        
        dataSource.apply(snapshot)
    }
    
    func createDataSource() -> DataSourceType {
        let cellRegistration = UICollectionView.CellRegistration<VideoCollectionViewCell, ViewModel.Item.ID> { [weak self] cell, indexPath, itemIdentifier in
            guard let self, let item = items.first(where: { $0.id == itemIdentifier }) else { return }
            cell.configureCell(item)
        }
        
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        return dataSource
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .fractionalWidth(0.5 / 16 * 9))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 12, trailing: 16)
        section.interGroupSpacing = 12
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemIdentifier = dataSource.itemIdentifier(for: indexPath),
              let item = items.first(where: { $0.id == itemIdentifier }) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: VideoDetailsViewController.self))
        let controller = storyboard.instantiateViewController(identifier: "VideoDetailsViewController") { coder in
            VideoDetailsViewController(coder: coder, video: item)
        }
        
        present(controller, animated: true, completion: nil)
    }
}
