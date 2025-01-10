//
//  ButtonsView.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/10.
//

import UIKit

class ButtonsView: UIView {
    let video: Video
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    init(video: Video) {
        self.video = video
        super.init(frame: .zero)
        
        setupStackView()
        setupMyListButton()
        setupRatingButton()
        setupShareButton()
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
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func setupMyListButton() {
        let myListButton = ImageOnTopButton(title: "マイリスト", imageName: "checkmark", onTap: {
            let added = Settings.shared.toggleMyList(self.video)
            if added {
                print("マイリストに追加されました")
            } else {
                print("マイリストから削除されました")
            }
        })
        stackView.addArrangedSubview(myListButton)
    }
    
    func setupRatingButton() {
        let ratingButton = ImageOnTopButton(title: "作品を評価", imageName: "star", onTap: {
            print("評価ボタンが押されました")
        })
        stackView.addArrangedSubview(ratingButton)
    }
    
    func setupShareButton() {
        let shareButton = ImageOnTopButton(title: "共有", imageName: "square.and.arrow.up", onTap: {
            print("共有ボタンが押されました")
        })
        stackView.addArrangedSubview(shareButton)
    }
}
