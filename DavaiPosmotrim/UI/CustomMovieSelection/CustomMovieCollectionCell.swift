//
//  CustomMovieCollectionCell.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 02.06.24.
//

import UIKit

final class CustomMovieCollectionCell: UICollectionViewCell {

    // MARK: - Public Properties

    private var modelId: UUID?

    // MARK: - Stored Properties

    static let reuseIdentifier = "CustomMovieCollectionCell"

    // MARK: - Layout variables

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteText
        label.font = .textParagraphRegularFont
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .basePrimaryAccent
        contentView.layer.cornerRadius = 12
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(model: CollectionsCellModel) {
        modelId = model.id
        titleLabel.text = model.title
    }

    // MARK: - Private Methods

    private func setupSubviews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
}
