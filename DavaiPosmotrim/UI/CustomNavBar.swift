//
//  CustomNavBar.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 21.06.2024.
//

import UIKit

struct CustomNavBarModel {
    let titleText: String
    let subtitleText: String?
    let leftButtonImage: UIImage?
    let leftAction: (() -> Void)?
}

struct CustomNavBarRightButtonModel {
    let rightButtonImage: UIImage?
    let isRightButtonLabelHidden: Bool
    let rightButtonLabelText: String?
    let rightAction: (() -> Void)?
}

final class CustomNavBar: UIView {

    // MARK: - Stored properties

    private var leftButtonAction: (() -> Void)?
    private var rightButtonAction: (() -> Void)?

    // MARK: - Lazy properties

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

    private lazy var leftButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
        return button
    }()

    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private lazy var rightButtonLabel: UILabel = {
        let label = UILabel()
        label.font = .textCaptionRegularFont
        label.textAlignment = .center
        label.textColor = .whiteText
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Handlers

    @objc private func didTapLeftButton() {
        leftButtonAction?()
    }

    @objc private func didTapRightButton() {
        rightButtonAction?()
    }

    // MARK: - Public methods

    func setupCustomNavBar(with model: CustomNavBarModel?) {
        guard let model else { return }
        titleLabel.text = model.titleText
        subtitleLabel.text = model.subtitleText
        leftButton.setImage(model.leftButtonImage, for: .normal)
        leftButtonAction = model.leftAction
    }

    func setupRightButton(with model: CustomNavBarRightButtonModel?) {
        guard let model else { return }
        rightButton.isHidden = false
        rightButton.setImage(model.rightButtonImage, for: .normal)
        rightButtonLabel.isHidden = model.isRightButtonLabelHidden
        rightButtonLabel.text = model.rightButtonLabelText
        rightButtonAction = model.rightAction
    }

    // MARK: - Private methods

    private func setupView() {
        backgroundColor = .whiteBackground
        layer.cornerRadius = 24
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.masksToBounds = true
    }

    private func setupSubviews() {
        [
            titleLabel,
            subtitleLabel,
            leftButton,
            rightButton
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        rightButton.addSubview(rightButtonLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),

            leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            leftButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            rightButton.bottomAnchor.constraint(equalTo: leftButton.bottomAnchor),

            rightButtonLabel.centerXAnchor.constraint(equalTo: rightButton.centerXAnchor),
            rightButtonLabel.centerYAnchor.constraint(equalTo: rightButton.centerYAnchor)
        ])
    }
}
