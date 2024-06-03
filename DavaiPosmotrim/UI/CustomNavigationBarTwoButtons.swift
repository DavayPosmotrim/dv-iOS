//
//  CustomNavigationBarTwoButtons.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 30.05.24.
//

import UIKit

class CustomNavigationBarTwoButtons: UIView {

    // MARK: - Stored Properties

    weak var delegate: CustomNavigationBarDelegate?
    private var likeCount: Int = 0

    // MARK: - Layout variables

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .textLabelFont
        label.textAlignment = .center
        label.textColor = .headingText
        return label
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "customCloseIcon"), for: .normal)
        button.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var rightLikeButton: UIButton = {
        let button = UIButton()
        button.addTarget(
            self,
            action: #selector(rightButtonLikeTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(likeCount)"
        label.font = .textCaptionRegularFont
        label.textAlignment = .center
        label.textColor = .whiteText
        return label
    }()

    // MARK: - Initializers

    init(title: String, imageBatton: String) {
        super.init(frame: .zero)
        backgroundColor = .whiteBackground
        setupSubviews()
        setupConstraints()
        titleLabel.text = title
        rightLikeButton.setImage(UIImage(named: imageBatton), for: .normal)
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 24
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func backButtonTapped() {
        delegate?.backButtonTapped()
    }

    @objc private func rightButtonLikeTapped() {
//        delegate?.rightButtonLikeTapped()
        likeCount += 1
        likeCountLabel.text = "\(likeCount)"
        }

    // MARK: - Private methods

    private func setupSubviews() {
        [
            titleLabel,
            backButton,
            rightLikeButton,
            likeCountLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 64),

            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            rightLikeButton.widthAnchor.constraint(equalToConstant: 32),
            rightLikeButton.heightAnchor.constraint(equalToConstant: 32),
            rightLikeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            rightLikeButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),

            likeCountLabel.centerXAnchor.constraint(equalTo: rightLikeButton.centerXAnchor),
            likeCountLabel.centerYAnchor.constraint(equalTo: rightLikeButton.centerYAnchor)
        ])
    }
}
