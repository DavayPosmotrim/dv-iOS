//
//  WarningNotification.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 12.05.24.
//

import UIKit

class CustomWarningNotification: UIView {

    // MARK: - Layout variables

    private lazy var paddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 12
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .textParagraphRegularFont
        label.textColor = .baseText
        label.textAlignment = .center
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .iconPrimary
        return imageView
    }()

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)
        backgroundColor = .whiteBackground
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func setupNotification(
        title: String,
        imageView: UIImage?,
        color: UIColor,
        font: UIFont? = .textParagraphRegularFont
    ) {
        titleLabel.text = title
        paddingView.backgroundColor = color
        titleLabel.font = font

        if let image = imageView {
            iconImageView.image = image
            iconImageView.isHidden = false
        } else {
            iconImageView.isHidden = true
        }

        setupConstraints()
    }

    // MARK: - Private methods

    private func setupSubviews() {
        [paddingView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        [iconImageView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            paddingView.addSubview($0)
        }
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 64),

            paddingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            paddingView.topAnchor.constraint(equalTo: topAnchor),
            paddingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            paddingView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        if iconImageView.isHidden {
            NSLayoutConstraint.activate([
                titleLabel.centerXAnchor.constraint(equalTo: paddingView.centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                iconImageView.widthAnchor.constraint(equalToConstant: 24),
                iconImageView.heightAnchor.constraint(equalToConstant: 24),

                iconImageView.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor),
                iconImageView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 16),

                titleLabel.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10)
            ])
        }
    }
}
