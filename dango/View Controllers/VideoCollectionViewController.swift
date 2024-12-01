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
        enum Section: Hashable {
            case recommendation(name: String, description: String)
        }
        
        typealias Item = Video
    }
    
    struct Model {
        var recommendations = [Recommendation]()
    }
    
    var dataSource: DataSourceType!
    var model = Model()
    var items: [ViewModel.Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            let section: ViewModel.Section = .recommendation(name: recommendation.name, description: recommendation.description)
            return (section, recommendation.videos)
        })
        items = itemsBySection.values.reduce([], +)
        
        let sectionIDs = itemsBySection.keys
    }
}
