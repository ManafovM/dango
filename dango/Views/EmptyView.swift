//
//  EmptyView.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/13.
//

import UIKit

class EmptyView: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.text = "からっぽ"
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
