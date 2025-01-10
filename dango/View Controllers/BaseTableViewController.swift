//
//  BaseTableViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/09.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = Color.darkBackground.value
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = Color.background.value
    }
}
