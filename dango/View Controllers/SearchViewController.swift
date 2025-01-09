//
//  SearchViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/08.
//

import UIKit

class SearchViewController: BaseViewController {
    let searchController = UISearchController(searchResultsController: SearchResultsCollectionViewController())

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "作品名で検索"
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // 検査結果更新
    }
}
