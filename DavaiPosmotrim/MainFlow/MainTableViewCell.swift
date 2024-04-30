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

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "DaysOne-Regular", size: 16)

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

    // MARK: - Lifecycle

    func configureCell(
        titleLabelText: String,
        textColor: UIColor,
        paddingBackgroundColor: UIColor,
        buttonImage: UIImage?,
        buttonColor: UIColor
    ) {
        titleLabel.text = titleLabelText
        titleLabel.textColor = textColor
        menuButton.setImage(buttonImage, for: .normal)
        menuButton.tintColor = buttonColor
        paddingView.backgroundColor = paddingBackgroundColor
        addSubViews()
        applyConstraints()
        selectionStyle = .none
    }

    // MARK: - IBAction

    @objc func didTapMenuButton() {
        guard let tableView = superview as? UITableView,
              let indexPath = tableView.indexPath(for: self),
              let mainViewController = tableView.delegate as? MainViewController else {
            return
        }

        switch indexPath.row {
        case 0:
            mainViewController.navigateTo(screen: "CreateSessionViewController")
        case 1:
            mainViewController.navigateTo(screen: "FavoriteMoviesViewController")
        case 2:
            mainViewController.navigateTo(screen: "JoinSessionViewController")
        default:
            break
        }
    }

    // MARK: - Private Methods

    private func addSubViews() {
        [paddingView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        [titleLabel, menuButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            paddingView.addSubview($0)
        }
    }

    private func applyConstraints() {
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
