//
//  CustomNavigationBarTwoButtons.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 30.05.24.
//

import UIKit

protocol CustomNavigationBarTwoButtonsDelegate: AnyObject {
    func backButtonTapped()
    func matchRightButtonTapped()
}

class CustomNavigationBarTwoButtons: UIView {

    // MARK: - Stored Properties

    weak var delegate: CustomNavigationBarTwoButtonsDelegate?
    private var matchCount: Int = 0

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
        button.setImage(UIImage.customCloseIcon, for: .normal)
        button.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    // TODO: - вернуть private после написания метода для расчета координат Button
     lazy var matchRightButton: UIButton = {
        let button = UIButton()
        button.addTarget(
            self,
            action: #selector(matchRightButtonTapped),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var matchCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(matchCount)"
        label.font = .textCaptionRegularFont
        label.textAlignment = .center
        label.textColor = .whiteText
        return label
    }()

    // MARK: - Initializers

    init(title: String, imageButton: String) {
        super.init(frame: .zero)
        backgroundColor = .whiteBackground
        setupSubviews()
        setupConstraints()
        titleLabel.text = title
        matchRightButton.setImage(UIImage(named: imageButton), for: .normal)
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 24
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func updateMatchCountLabel(withRandomCount count: Int) {
        matchCountLabel.text = "\(count)"
    }

    // MARK: - Actions

    @objc private func backButtonTapped() {
        delegate?.backButtonTapped()
    }

    @objc private func matchRightButtonTapped() {
        delegate?.matchRightButtonTapped()
    }

    // MARK: - Private methods

    private func setupSubviews() {
        [
            titleLabel,
            backButton,
            matchRightButton,
            matchCountLabel
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

            matchRightButton.widthAnchor.constraint(equalToConstant: 32),
            matchRightButton.heightAnchor.constraint(equalToConstant: 32),
            matchRightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            matchRightButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),

            matchCountLabel.centerXAnchor.constraint(equalTo: matchRightButton.centerXAnchor),
            matchCountLabel.centerYAnchor.constraint(equalTo: matchRightButton.centerYAnchor)
        ])
    }
}
