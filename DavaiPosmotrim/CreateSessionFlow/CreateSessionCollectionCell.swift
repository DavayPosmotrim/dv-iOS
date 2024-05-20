//
//  CreateSessionCollectionCell.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 09.05.24.
//

import UIKit

protocol CreateSessionCollectionCellDelegate: AnyObject {
    func collectionCellTitleAdded(id: UUID?)
    func collectionCellTitleRemoved(id: UUID?)
}

final class CreateSessionCollectionCell: UICollectionViewCell {

    // MARK: - Public Properties

    var isSelectedCollectionCell: Bool = false {
        didSet {
            updateCellAppearance(isSelectedCollectionCell)
        }
    }
    private var modelId: UUID?

    // MARK: - Stored Properties

    static let reuseIdentifier = "CreateSessionCollectionCell"
    weak var delegate: CreateSessionCollectionCellDelegate?

    // MARK: - Layout variables

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .captionDarkText
        label.font = .textParagraphRegularFont
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .baseBackground
        contentView.layer.cornerRadius = 16
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
        [titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    private func updateCellAppearance(_ isSelected: Bool) {
        if isSelected {
            delegate?.collectionCellTitleAdded(id: modelId)
            contentView.backgroundColor = .baseSecondaryAccent
            titleLabel.textColor = .baseText
        } else {
            delegate?.collectionCellTitleRemoved(id: modelId)
            contentView.backgroundColor = .baseBackground
            titleLabel.textColor = .captionDarkText
        }
    }
}
