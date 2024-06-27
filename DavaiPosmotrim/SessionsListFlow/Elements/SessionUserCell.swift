//
//  SessionUserCell.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 22.06.2024.
//

import UIKit

final class SessionUserCell: UICollectionViewCell {

    // MARK: - Type properties
    static let cellID = "SessionUserCell"

    // MARK: - View properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .baseText
        label.font = .textParagraphRegularFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods
    func configureCell(for model: User) {
        titleLabel.text = model.name
    }
}
    // MARK: - Private methods
private extension SessionUserCell {
    func setupUI() {
        contentView.backgroundColor = .baseSecondaryAccent
        contentView.layer.cornerRadius = 16
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
