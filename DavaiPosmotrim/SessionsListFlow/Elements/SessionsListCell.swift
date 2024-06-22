//
//  SessionsListMovieCell.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 07.06.2024.
//

import UIKit

final class SessionsListCell: UITableViewCell {

    // MARK: - Type properties
    static let cellID = "SessionsListCell"

    // MARK: - Private properties
    private enum CellSpace {
        static let xxSmall: CGFloat = 2.0
        static let xSmall: CGFloat = 4.0
        static let small: CGFloat = 8.0
        static let medium: CGFloat = 12.0
        static let large: CGFloat = 16.0
        static let xLarge: CGFloat = 20.0
    }
    private let placeholderImage = UIImage(resource: .noImagePlug)
    private var isFirstCell = false

    // MARK: - View properties
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.textColor = .headingText
        label.font = .textLabelFont
        return label
    }()
    private lazy var matchStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = CellSpace.xSmall
        stack.backgroundColor = .basePrimaryAccent
        stack.layer.cornerRadius = .radiusBase
        stack.layer.masksToBounds = true
        stack.layoutMargins = UIEdgeInsets(
            top: CellSpace.xxSmall,
            left: .spacingBase,
            bottom: CellSpace.xxSmall,
            right: .spacingBase
        )
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    private lazy var matchTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteText
        label.font = .textParagraphRegularFont
        label.text = Resources.SessionsList.Sessions.matchesTitle
        return label
    }()
    private lazy var matchCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteText
        label.font = .textParagraphRegularFont
        return label
    }()
    private lazy var usersListLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.textColor = .headingText
        label.font = .textParagraphRegularFont
        return label
    }()
    private lazy var cellBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = .radiusLarge
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var cellBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = .radiusMedium
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var movieBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .baseBackground
        view.layer.cornerRadius = .radiusMedium
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = .radiusMedium
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private lazy var placeholderStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = .spacingBase
        return stack
    }()
    private lazy var placeholderTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .captionLightText
        label.font = .textParagraphRegularFont
        label.text = Resources.SessionsList.Sessions.noImageTitle
        return label
    }()
    private lazy var placeholderImageView = UIImageView(image: placeholderImage)

    // MARK: - Public Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        let topInset: CGFloat = isFirstCell ? .spacingMedium * 3 : .spacingMedium
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0))
    }

    func configureCell(for viewModel: SessionsListViewModel) {
        isFirstCell = viewModel.isFirstCell
        dateLabel.text = viewModel.date
        usersListLabel.text = viewModel.users
        matchCountLabel.text = viewModel.matches

        if let imageName = viewModel.imageName {
            movieImageView.image = UIImage(named: imageName)
            hidePlaceholder(true)
        } else {
            hidePlaceholder(false)
        }

        setupUI()
        contentView.layoutIfNeeded()
    }
}

// MARK: - Private methods
private extension SessionsListCell {

    func setupUI() {
        backgroundColor = .baseBackground

        [
            cellBackgroundView,
            dateLabel,
            matchStackView,
            usersListLabel,
            movieBackgroundView,
            movieImageView,
            placeholderStackView
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [matchTitleLabel, matchCountLabel].forEach {
            matchStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [placeholderImageView, placeholderTitleLabel].forEach {
            placeholderStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            cellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            matchStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingBase),
            matchStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CellSpace.medium),
            matchStackView.heightAnchor.constraint(equalToConstant: .textLabelHeight),

            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingBase),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CellSpace.large),
            dateLabel.heightAnchor.constraint(equalToConstant: .textLabelHeight),

            usersListLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: .spacingBase),
            usersListLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CellSpace.large),
            usersListLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CellSpace.medium),
            usersListLabel.heightAnchor.constraint(equalToConstant: .textParagraphHeightOneLine),

            movieBackgroundView.topAnchor.constraint(equalTo: usersListLabel.bottomAnchor, constant: .spacingBase),
            movieBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CellSpace.small),
            movieBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CellSpace.small),
            movieBackgroundView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -CellSpace.small
            ),

            movieImageView.topAnchor.constraint(equalTo: usersListLabel.bottomAnchor, constant: .spacingBase),
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CellSpace.small),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -CellSpace.small),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CellSpace.small),

            placeholderStackView.centerXAnchor.constraint(equalTo: movieBackgroundView.centerXAnchor),
            placeholderStackView.centerYAnchor.constraint(equalTo: movieBackgroundView.centerYAnchor)
        ])
    }

    func hidePlaceholder(_ isShowing: Bool) {
        movieImageView.isHidden = !isShowing
        placeholderStackView.isHidden = isShowing
    }
}
