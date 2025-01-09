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
    
    func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "作品名で検索"
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchController.searchBar.text,
              !searchTerm.isEmpty else { return }
        
        if let resultsController = searchController.searchResultsController as? SearchResultsCollectionViewController {
            resultsController.search(for: searchTerm)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearchResults()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchTerm = searchController.searchBar.text,
           searchTerm.isEmpty {
            resetSearchResults()
        }
    }
    
    func resetSearchResults() {
        if let resultsController = searchController.searchResultsController as? SearchResultsCollectionViewController {
            resultsController.dataSource.apply(NSDiffableDataSourceSnapshot())
        }
    }
}
