//
//  VideoDetailsView.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/16.
//

import UIKit

class VideoDetailsView: UIView {
    let stackView = UIStackView()
    
    init(frame: CGRect, video: Video) {
        super.init(frame: frame)
        setupStackView()
        setupVideoInfo(video: video)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func setupVideoInfo(video: Video) {
        let titleLabel = UILabel()
        titleLabel.text = video.title
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        stackView.addArrangedSubview(titleLabel)
        
        let yearLabel = UILabel()
        yearLabel.text = "\(video.year)年"
        yearLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        yearLabel.textColor = .secondaryLabel
        stackView.addArrangedSubview(yearLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = video.description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        stackView.addArrangedSubview(descriptionLabel)
        
        let playButton = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        
        var buttonTitle = AttributedString("再生")
        buttonTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        var buttonSubtitle = AttributedString(" (\(video.duration)分)")
        buttonSubtitle.font = UIFont.systemFont(ofSize: 12, weight: .light)
        
        buttonTitle.append(buttonSubtitle)
        config.attributedTitle = buttonTitle
        config.image = UIImage(systemName: "play.fill")
        config.imagePadding = 8.0
        config.baseForegroundColor = Color.darkBackground.value
        config.baseBackgroundColor = .white
        config.cornerStyle = .medium
        playButton.configuration = config
        
        playButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        stackView.addArrangedSubview(playButton)
    }
}
