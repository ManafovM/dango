//
//  VideoCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import UIKit

private let reuseIdentifier = "Cell"

class VideoCollectionViewController: UICollectionViewController {
    
    var videosRequestTask: Task<Void, Never>? = nil
    deinit { videosRequestTask?.cancel() }
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item.ID>
    
    enum ViewModel {
        enum Section: Hashable {
            case featured
            case recentlyPlayed
            case genres
            case tag(_ tag: String)
        }
        
        typealias Item = Video
    }
    
    struct Model {
        var videosByTag = [String: [Video]]()
    }
    
    var dataSource: DataSourceType!
    var model = Model()
    var items: [ViewModel.Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func update() {
        videosRequestTask?.cancel()
        videosRequestTask = Task {
            if let videos = try? await VideoRequest().send() {
                self.model.videosByTag = videos
            } else {
                self.model.videosByTag = [:]
            }
            self.updateCollectionView()
            
            videosRequestTask = nil
        }
    }
    
    func updateCollectionView() {
        let itemsBySection = Dictionary(uniqueKeysWithValues: model.videosByTag.map { (tag, videos) in
            let section: ViewModel.Section
            
            switch tag {
            case "featured":
                section = .featured
            case "recentlyPlayed":
                section = .recentlyPlayed
            default:
                section = .tag(tag)
            }
            return (section, videos)
        })
        items = itemsBySection.values.reduce([], +)
        
        let sectionIDs = itemsBySection.keys
    }
}
