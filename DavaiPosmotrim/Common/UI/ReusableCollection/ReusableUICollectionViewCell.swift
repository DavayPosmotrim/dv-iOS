//
//  ReusableUICollectionViewCell.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 24.05.2024.
//

import UIKit

struct ReusableCollectionCellModel: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
}

final class ReusableUICollectionViewCell: UICollectionViewCell {

    // MARK: - Stored properties

    static let reuseIdentifier = "ReusableUICollectionViewCell"
    private var cellId: String?

    // MARK: - Lazy properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .baseText
        label.font = .textParagraphRegularFont
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .baseSecondaryAccent
        contentView.layer.cornerRadius = 16

        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func configureCell(with model: ReusableCollectionCellModel) {
        titleLabel.text = model.title
        cellId = model.id
    }

    // MARK: - Private methods

    private func setupCell() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
