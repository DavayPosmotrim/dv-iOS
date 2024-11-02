//
//  RouletteUsersCollectionCell.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 25.07.2024.
//

import UIKit

struct RouletteUsersCollectionCellModel: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    var isConnected: Bool
}

final class RouletteUsersCollectionCell: UICollectionViewCell {

    // MARK: - Stored properties

    static let reuseIdentifier = "RouletteUsersCollectionCell"
    private var cellId: String?
    private var isConnected: Bool = false {
        didSet {
            updateBackgroundColor()
        }
    }

    // MARK: - Lazy properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .captionDarkText
        label.font = .textParagraphRegularFont
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .baseBackground
        contentView.layer.cornerRadius = 16

        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func configureCell(with model: RouletteUsersCollectionCellModel) {
        cellId = model.id
        titleLabel.text = model.title
        isConnected = model.isConnected
    }

    func configureConnection(with property: Bool) {
        isConnected = property
    }

    private func updateBackgroundColor() {
        let targetBackgroundColor: UIColor = isConnected ? .baseSecondaryAccent : .baseBackground
        let targetTextColor: UIColor = isConnected ? .baseText : .captionDarkText
        contentView.backgroundColor = targetBackgroundColor
        titleLabel.textColor = targetTextColor
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
