//
//  SearchTableViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/09.
//

import UIKit

class SearchTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        guard let searchTerm = cell.textLabel?.text else { return }
        
        var controller: SearchResultsCollectionViewController!
        if searchTerm == "すべての作品" {
            controller = AllVideosCollectionViewController()
        } else {
            controller = GenreSearchResultsCollectionViewController()
        }
        
        controller.title = searchTerm
        controller.search(for: searchTerm)
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
