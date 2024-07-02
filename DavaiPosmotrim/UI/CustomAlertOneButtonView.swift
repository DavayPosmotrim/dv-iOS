//
//  CustomAlertViewOneButton.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 28.06.24.
//

import UIKit

struct CustomAlertOneButtonModel {
    let alertTitle: String?
    let alertMessage: String?
    let progressAction: (() -> Void)?
}

final class CustomAlertOneButtonView: UIView {

    // MARK: - Stored properties

    private var progressAction: (() -> Void)?

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

    private lazy var progressButton: CustomButtons = {
        let button = CustomButtons()
        button.setupView(with: button.progressButton)
        button.progressButton.setTitle(Resources.SelectionMovies.customOneButtonText, for: .normal)
        button.progressButton.addTarget(
            self,
            action: #selector(didTapProgressButton),
            for: .touchUpInside
        )
        button.onProgressComplete = { [weak self] in
            self?.closeViewController()
        }
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

    func setupCustomAlertOneButton(with model: CustomAlertOneButtonModel?) {
        guard let model = model else { return }
        upperLabel.text = model.alertTitle
        lowerLabel.text = model.alertMessage
        progressAction = model.progressAction
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        startProgress()
    }

    // MARK: - Handlers

    @objc private func didTapProgressButton() {
        closeViewController()
    }

    // MARK: - Private methods

    private func closeViewController() {
        progressAction?()
    }

    private func startProgress() {
        progressButton.startProgress(duration: 4)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            blurredView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurredView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurredView.topAnchor.constraint(equalTo: topAnchor),
            blurredView.bottomAnchor.constraint(equalTo: bottomAnchor),

            paddingView.centerYAnchor.constraint(equalTo: blurredView.centerYAnchor),
            paddingView.leadingAnchor.constraint(equalTo: blurredView.leadingAnchor, constant: 16),
            paddingView.trailingAnchor.constraint(equalTo: blurredView.trailingAnchor, constant: -16),
            paddingView.bottomAnchor.constraint(equalTo: progressButton.bottomAnchor, constant: 16),

            upperLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 16),
            upperLabel.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -16),
            upperLabel.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 16),
            upperLabel.heightAnchor.constraint(equalToConstant: 28),

            lowerLabel.leadingAnchor.constraint(equalTo: upperLabel.leadingAnchor),
            lowerLabel.trailingAnchor.constraint(equalTo: upperLabel.trailingAnchor),
            lowerLabel.topAnchor.constraint(equalTo: upperLabel.bottomAnchor, constant: 24),
            lowerLabel.bottomAnchor.constraint(equalTo: progressButton.topAnchor, constant: -32),

            progressButton.leadingAnchor.constraint(equalTo: upperLabel.leadingAnchor),
            progressButton.trailingAnchor.constraint(equalTo: upperLabel.trailingAnchor),
            progressButton.heightAnchor.constraint(equalToConstant: 44)
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
            progressButton
        ].forEach {
            paddingView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
