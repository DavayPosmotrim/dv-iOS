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

    // MARK: - Private Properties

    private struct Keys {
        static let createSessionViewController = "CreateSessionViewController"
        static let favoriteMoviesViewController = "FavoriteMoviesViewController"
        static let joinSessionViewController = "JoinSessionViewController"
    }

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

    private lazy var menuButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(
            self,
            action: #selector(didTapMenuButton),
            for: .touchUpInside
        )
        return button
    }()

    // MARK: - Actions

    @objc func didTapMenuButton() {
        guard let tableView = superview as? UITableView,
              let indexPath = tableView.indexPath(for: self),
              let mainViewController = tableView.delegate as? MainViewController else {
            return
        }

        switch indexPath.row {
        case 0:
            mainViewController.nameButtonPressed(screen: Keys.createSessionViewController)
        case 1:
            mainViewController.nameButtonPressed(screen: Keys.favoriteMoviesViewController)
        case 2:
            mainViewController.nameButtonPressed(screen: Keys.joinSessionViewController)
        default:
            break
        }
    }

    // MARK: - Public Methods

    func configureCell(model: MainCellModel) {
        titleLabel.text = model.title
        titleLabel.textColor = model.textColor
        menuButton.setImage(model.buttonImage, for: .normal)
        menuButton.tintColor = model.buttonColor
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

        [titleLabel, menuButton].forEach {
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

            menuButton.heightAnchor.constraint(equalToConstant: 40),
            menuButton.widthAnchor.constraint(equalToConstant: 40),
            menuButton.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 20),
            menuButton.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -16),
            menuButton.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor, constant: -20)
        ])
    }
}
