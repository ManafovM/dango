//
//  VideoDetailsButtonsView.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/10.
//

import UIKit

class VideoDetailsButtonsView: UIView {
    let video: Video
    
    var myListButton: ImageOnTopButton!
    var ratingButton: ImageOnTopButton!
    var shareButton: ImageOnTopButton!
    
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
        myListButton = ImageOnTopButton(title: "マイリスト", imageName: "plus", tappedImageName: "checkmark", onTap: { [weak self] in
            guard let self = self else { return }
            
            let added = Settings.shared.toggleMyList(video)
            if added {
                print("マイリストに追加されました")
            } else {
                print("マイリストから削除されました")
            }
            
            myListButton.toggleWithAnimation()
        })
        
        if Settings.shared.myList.contains(video) {
            myListButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }
        
        stackView.addArrangedSubview(myListButton)
    }
    
    func setupRatingButton() {
        ratingButton = ImageOnTopButton(title: "作品を評価", imageName: "star", tappedImageName: "star.fill", onTap: { [weak self] in
            guard let self = self else { return }
            print("評価ボタンが押されました")
            ratingButton.toggle()
        })
        stackView.addArrangedSubview(ratingButton)
    }
    
    func setupShareButton() {
        shareButton = ImageOnTopButton(title: "共有", imageName: "square.and.arrow.up", onTap: {
            print("共有ボタンが押されました")
        })
        stackView.addArrangedSubview(shareButton)
    }
}
