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
        roleLabel.textColor = .baseText
        roleLabel.font = .textParagraphRegularFont
        roleLabel.backgroundColor = .baseBackground
        roleLabel.layer.cornerRadius = 12
        return roleLabel
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

    func configure(name: String) {
        roleLabel.text = name
    }

    // MARK: - Private Methods

    private func setupCell() {
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .baseBackground

        roleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(roleLabel)

        NSLayoutConstraint.activate([
            roleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            roleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            roleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            roleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
}
