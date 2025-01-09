//
//  GenreSearchResultsCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/09.
//

import Foundation

class GenreSearchResultsCollectionViewController: SearchResultsCollectionViewController {
    var genreSearchRequestTask: Task<Void, Never>? = nil
    deinit { genreSearchRequestTask?.cancel() }
    
    override func search(for searchTerm: String) {
        genreSearchRequestTask?.cancel()
        genreSearchRequestTask = Task {
            if let videos = try? await GenreSearchRequest(searchTerm: searchTerm).send() {
                self.model.videos = videos
            } else {
                self.model.videos = []
            }
            self.updateCollectionView()
            
            genreSearchRequestTask = nil
        }
    }
}
