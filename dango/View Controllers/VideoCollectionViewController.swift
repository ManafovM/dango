//
//  VideoCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import UIKit

private let reuseIdentifier = "Cell"

class VideoCollectionViewController: UICollectionViewController {
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item.ID>
    
    enum ViewModel {
        enum Section: Hashable {
            case featured
            case recentlyPlayed
            case genres
            case tag(_ tag: Tag)
        }
        
        typealias Item = Video
    }
    
    struct Model {
        var videos = [Video]()
    }
    
    var dataSource: DataSourceType!
    var model = Model()
    var items: [ViewModel.Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell
        
        return cell
    }
}
