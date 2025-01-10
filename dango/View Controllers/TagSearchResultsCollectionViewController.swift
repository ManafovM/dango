//
//  TagSearchResultsCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/09.
//

import Foundation

class TagSearchResultsCollectionViewController: SearchResultsCollectionViewController {
    var tagSearchRequestTask: Task<Void, Never>? = nil
    deinit { tagSearchRequestTask?.cancel() }
    
    override func search(for searchTerm: String) {
        tagSearchRequestTask?.cancel()
        tagSearchRequestTask = Task {
            if let videos = try? await TagSearchRequest(searchTerm: searchTerm).send() {
                self.model.videos = videos
            } else {
                self.model.videos = []
            }
            self.updateCollectionView()
            
            tagSearchRequestTask = nil
        }
    }
}
