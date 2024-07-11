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

    private lazy var discriptionLabel: UILabel = {
        var discriptionLabel = UILabel()
        discriptionLabel.font = .textParagraphRegularFont
        discriptionLabel.numberOfLines = 0
        return discriptionLabel
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
        discriptionLabel.text = text
    }

    // MARK: - Private Methods

    private func setupCell() {
        discriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(discriptionLabel)

        NSLayoutConstraint.activate([
            discriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            discriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            discriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            discriptionLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width - 32)
        ])
    }
}
