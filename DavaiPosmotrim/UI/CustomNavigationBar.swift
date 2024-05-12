//
//  CustomNavigationBar.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 06.05.24.
//

import UIKit

protocol CustomNavigationBarDelegate: AnyObject {
    func backButtonTapped()
}

class CustomNavigationBar: UIView {

    // MARK: - Stored Properties

    weak var delegate: CustomNavigationBarDelegate?

    // MARK: - Layout variables

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .textLabelFont
        label.textAlignment = .center
        label.textColor = .headingText
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .textCaptionRegularFont
        label.textAlignment = .center
        label.textColor = .captionLightText
        return label
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "customBackIcon"), for: .normal)
        button.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    // MARK: - Initializers

    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        backgroundColor = .whiteBackground
        setupSubviews()
        setupConstraints()
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func backButtonTapped() {
        delegate?.backButtonTapped()
    }

    // MARK: - Private methods

    private func setupSubviews() {
        [titleLabel,
         subtitleLabel,
         backButton
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

            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }

}
