//
//  SearchResultsCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/08.
//

import UIKit

class SearchResultsCollectionViewController: BaseCollectionViewController {
    var videoDetailsViewController: UIViewController!
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item.ID>
    
    var searchRequestTask: Task<Void, Never>? = nil
    deinit { searchRequestTask?.cancel() }
    
    enum ViewModel {
        enum Section {
            case videos
        }
        
        typealias Item = Video
    }
    
    struct Model {
        var videos = [Video]()
    }
    
    var dataSource: DataSourceType!
    var model = Model()
    var items: [ViewModel.Item] = []

    init() {
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
        
        dataSource = createDatasource()
        collectionView.dataSource = dataSource
    }
    
    func search(for searchTerm: String) {
        searchRequestTask?.cancel()
        searchRequestTask = Task {
            if let videos = try? await SearchRequest(searchTerm: searchTerm).send() {
                self.model.videos = videos
            } else {
                self.model.videos = []
            }
            self.updateCollectionView()
            
            searchRequestTask = nil
        }
    }
    
    func updateCollectionView() {
        items = model.videos
        
        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item.ID>()
        
        snapshot.appendSections([.videos])
        snapshot.appendItems(items.map(\.id), toSection: .videos)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func createDatasource() -> DataSourceType {
        let cellRegistration = UICollectionView.CellRegistration<SearchResultsCollectionViewCell, ViewModel.Item.ID> { [weak self] cell, indexPath, itemIdentifier in
            
            guard let self, let item = items.first(where: { $0.id == itemIdentifier }) else { return }
            cell.configureCell(item)
        }
        
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        return dataSource
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemIdentifier = dataSource.itemIdentifier(for: indexPath),
              let item = items.first(where: { $0.id == itemIdentifier }) else { return }
        
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
