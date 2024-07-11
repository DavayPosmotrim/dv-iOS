//
//  CustomMovieDetailsCollectionHeader.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 10.07.2024.
//

import UIKit

final class CustomMovieDetailsCollectionHeader: UICollectionReusableView {

    static let identifier = "CustomMovieDetailsCollectionHeader"

    private let label: UILabel = {
        var label = UILabel()
        label.font = .textLabelFont
        label.textAlignment = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: topAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(text: String) {
        label.text = text
    }

}
