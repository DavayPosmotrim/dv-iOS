//
//  CustomMovieDiscriptionCell.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 11.07.2024.
//

import UIKit

final class CustomMovieDescriptionCollectionCell: UICollectionViewCell {

    // MARK: - Stored Properties

    static let reuseIdentifier = "CustomMovieDescriptionCollectionCell"

    // MARK: - Layout variables

    private lazy var descriptionLabel: UILabel = {
        var descriptionLabel = UILabel()
        descriptionLabel.font = .textParagraphRegularFont
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(text: String) {
        descriptionLabel.text = text
    }

    // MARK: - Private Methods

    private func setupCell() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32)
        ])
    }
}
