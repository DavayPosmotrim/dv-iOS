//
//  MainTableViewCell.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 28.04.24.
//

import UIKit

final class MainTableViewCell: UITableViewCell {

    // MARK: - Stored Properties

    static let reuseIdentifier = "MainTableViewCell"

    // MARK: - Layout variables

    private lazy var paddingView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .textLabelFont
        return label
    }()

    private lazy var menuImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    // MARK: - Public Methods

    func configureCell(model: MainCellModel) {
        titleLabel.text = model.title
        titleLabel.textColor = model.textColor
        menuImageView.image = model.menuImage
        menuImageView.tintColor = model.menuImageColor
        paddingView.backgroundColor = model.paddingBackgroundColor
        setupSubviews()
        setupConstraints()
        selectionStyle = .none
    }

    // MARK: - Private Methods

    private func setupSubviews() {
        [paddingView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        [titleLabel, menuImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            paddingView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            paddingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            paddingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            paddingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            paddingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),

            titleLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 16),

            menuImageView.heightAnchor.constraint(equalToConstant: 40),
            menuImageView.widthAnchor.constraint(equalToConstant: 40),
            menuImageView.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 20),
            menuImageView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -16),
            menuImageView.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor, constant: -20)
        ])
    }
}
