//
//  CustomRolesCollectionCell.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 02.07.2024.
//

import UIKit

final class CustomRolesCollectionCell: UICollectionViewCell {

    // MARK: - Stored Properties

    static let reuseIdentifier = "CustomRolesCollectionCell"

    // MARK: - Layout variables

    private lazy var roleLabel: UILabel = {
        let roleLabel = UILabel()
        roleLabel.textColor = .whiteText
        roleLabel.font = .textParagraphRegularFont
        return roleLabel
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

    func configure(name: String) {
        roleLabel.text = name
    }

    // MARK: - Private Methods

    private func setupSubviews() {
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(roleLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            roleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            roleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            roleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            roleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
}

