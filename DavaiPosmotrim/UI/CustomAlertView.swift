//
//  CustomAlertView.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.05.2024.
//

struct CustomAlertModel {
    let alertTitle: String?
    let alertMessage: String?
    let yesAction: (() -> Void)?
    let noAction: (() -> Void)?
}

import UIKit

final class CustomAlertView: UIView {

    // MARK: - Stored properties

    private var yesButtonAction: (() -> Void)?
    private var noButtonAction: (() -> Void)?

    // MARK: - Lazy properties

    private lazy var blurredView: UIVisualEffectView = {
        return UIVisualEffectView(
            effect: UIBlurEffect(
                style: .systemUltraThinMaterialDark
            )
        )
    }()

    private lazy var paddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true

        return view
    }()

    private lazy var upperLabel: UILabel = {
        let label = UILabel()
        label.font = .textHeadingFont
        label.textColor = .headingText
        label.textAlignment = .left

        return label
    }()

    private lazy var lowerLabel: UILabel = {
        let label = UILabel()
        label.font = .textParagraphRegularFont
        label.textColor = .baseText
        label.numberOfLines = 5
        label.textAlignment = .left

        return label
    }()

    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 12

        return stack
    }()

    private lazy var yesButton: UIView = {
        let button = CustomButtons()
        button.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        button.setupView(with: button.grayButton)
        button.grayButton.setTitle(Resources.JoinSession.customLabelYesButtonText, for: .normal)
        button.grayButton.addTarget(self, action: #selector(didTapYesButton(sender:)), for: .touchUpInside)

        return button
    }()

    private lazy var noButton: UIView = {
        let button = CustomButtons()
        button.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        button.setupView(with: button.purpleButton)
        button.purpleButton.setTitle(Resources.JoinSession.customLabelNoButtonText, for: .normal)
        button.purpleButton.addTarget(self, action: #selector(didTapNoButton(sender:)), for: .touchUpInside)

        return button
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func setupCustomAlert(with model: CustomAlertModel?) {
        guard let model else { return }
        upperLabel.text = model.alertTitle
        lowerLabel.text = model.alertMessage
        yesButtonAction = model.yesAction
        noButtonAction = model.noAction
    }

    // MARK: - Handlers

    @objc private func didTapYesButton(sender: AnyObject) {
        yesButtonAction?()
    }

    @objc private func didTapNoButton(sender: AnyObject) {
        noButtonAction?()
    }

    // MARK: - Private methods

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            blurredView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurredView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurredView.topAnchor.constraint(equalTo: topAnchor),
            blurredView.bottomAnchor.constraint(equalTo: bottomAnchor),

            paddingView.centerYAnchor.constraint(equalTo: blurredView.centerYAnchor),
            paddingView.leadingAnchor.constraint(equalTo: blurredView.leadingAnchor, constant: 16),
            paddingView.trailingAnchor.constraint(equalTo: blurredView.trailingAnchor, constant: -16),
            paddingView.bottomAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 16),

            upperLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 16),
            upperLabel.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -16),
            upperLabel.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 16),
            upperLabel.heightAnchor.constraint(equalToConstant: 28),

            lowerLabel.leadingAnchor.constraint(equalTo: upperLabel.leadingAnchor),
            lowerLabel.trailingAnchor.constraint(equalTo: upperLabel.trailingAnchor),
            lowerLabel.topAnchor.constraint(equalTo: upperLabel.bottomAnchor, constant: 24),
            lowerLabel.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -32),

            buttonStack.leadingAnchor.constraint(equalTo: upperLabel.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: upperLabel.trailingAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 44),

            yesButton.leadingAnchor.constraint(equalTo: buttonStack.leadingAnchor),
            yesButton.topAnchor.constraint(equalTo: buttonStack.topAnchor),
            yesButton.bottomAnchor.constraint(equalTo: buttonStack.bottomAnchor),

            noButton.trailingAnchor.constraint(equalTo: buttonStack.trailingAnchor),
            noButton.topAnchor.constraint(equalTo: buttonStack.topAnchor),
            noButton.bottomAnchor.constraint(equalTo: buttonStack.bottomAnchor)
        ])
    }

    private func setupSubviews() {
        [blurredView, paddingView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [
            upperLabel,
            lowerLabel,
            buttonStack
        ].forEach {
            paddingView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [yesButton, noButton].forEach {
            buttonStack.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
