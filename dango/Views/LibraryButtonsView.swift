//
//  LibraryButtonsView.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/10.
//

import UIKit

class LibraryButtonsView: UIView {
    var myListButton: ImageOnTopButton!
    var downloadsButton: ImageOnTopButton!
    var purchasedButton: ImageOnTopButton!
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        
        setupStackView()
        setupMyListButton()
        setupDownloadsButton()
        setupPurchasedButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStackView() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stackView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func setupMyListButton() {
        myListButton = ImageOnTopButton(title: "マイリスト", backgroundColor: Color.lightBackground.value, imageName: "list.clipboard.fill", onTap: {
            let myListController = MyListCollectionViewController()
            myListController.title = "マイリスト"
            
            let videoIds = Settings.shared.myList.map { $0.id }
            if !videoIds.isEmpty {
                myListController.search(by: videoIds)
            }
            
            if let controller = self.getViewController() {
                controller.navigationController?.pushViewController(myListController, animated: true)
            }
        })
        stackView.addArrangedSubview(myListButton)
    }
    
    func setupDownloadsButton() {
        downloadsButton = ImageOnTopButton(title: "ダウンロード", backgroundColor: Color.lightBackground.value, imageName: "platter.filled.bottom.and.arrow.down.iphone", onTap: { })
        stackView.addArrangedSubview(downloadsButton)
    }
    
    func setupPurchasedButton() {
        purchasedButton = ImageOnTopButton(title: "購入済み", backgroundColor: Color.lightBackground.value, imageName: "bag.fill", onTap: { })
        stackView.addArrangedSubview(purchasedButton)
    }
}
