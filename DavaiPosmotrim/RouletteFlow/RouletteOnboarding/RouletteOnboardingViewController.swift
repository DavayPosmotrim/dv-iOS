//
//  RouletteOnboardingViewController.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 08.07.2024.
//

import UIKit

final class RouletteOnboardingViewController: UIViewController {

    // MARK: - Lazy properties

    private lazy var blurredView: UIVisualEffectView = {
        return UIVisualEffectView(
            effect: UIBlurEffect(
                style: .systemUltraThinMaterialDark
            )
        )
    }()

    private lazy var arrowImageView = UIImageView(image: .rouletteOnboardingArrow)

    private lazy var cutoutPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear

        return view
    }()

    private lazy var paddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .textTitleFont
        label.textColor = .headingText
        label.numberOfLines = 2
        label.textAlignment = .natural
        label.text = Resources.RouletteFlow.titleLabelText

        return label
    }()

    private lazy var upperLabel: UILabel = {
        let label = UILabel()
        label.font = .textParagraphBoldFont
        label.textColor = .headingText
        label.numberOfLines = 2
        label.textAlignment = .natural
        label.text = Resources.RouletteFlow.upperLabelText

        return label
    }()

    private lazy var lowerLabel: UILabel = {
        let label = UILabel()
        label.font = .textParagraphRegularFont
        label.textColor = .baseText
        label.numberOfLines = 2
        label.textAlignment = .natural
        label.text = Resources.RouletteFlow.lowerLabelText

        return label
    }()

    private lazy var labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 12

        return stack
    }()

    private lazy var proceedButton: UIView = {
        let button = CustomButtons()
        button.frame = CGRect(x: 0, y: 0, width: 0, height: 44)
        button.setupView(with: button.purpleButton)
        button.purpleButton.setTitle(Resources.RouletteFlow.proceedButtonText, for: .normal)
        button.purpleButton.addTarget(self, action: #selector(didTapProceedButton(sender:)), for: .touchUpInside)

        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateCutout()
    }

    // MARK: - Handlers

    @objc private func didTapProceedButton(sender: AnyObject) {
        UserDefaults.standard.setValue(true, forKey: Resources.RouletteFlow.isRouletteOnboardingShown)
        dismiss(animated: true)
    }
}

    // MARK: - Private methods

private extension RouletteOnboardingViewController {

    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            blurredView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            blurredView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            blurredView.topAnchor.constraint(equalTo: view.topAnchor),
            blurredView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            paddingView.leadingAnchor.constraint(equalTo: blurredView.leadingAnchor),
            paddingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            paddingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            paddingView.heightAnchor.constraint(greaterThanOrEqualToConstant: 326),
            paddingView.heightAnchor.constraint(lessThanOrEqualToConstant: 360),

            titleLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 16),

            labelsStack.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 16),
            labelsStack.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -16),
            labelsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            labelsStack.bottomAnchor.constraint(equalTo: proceedButton.topAnchor, constant: -32),

            proceedButton.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 16),
            proceedButton.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -16),
            proceedButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
            proceedButton.heightAnchor.constraint(equalToConstant: 48),

            cutoutPaddingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            cutoutPaddingView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            cutoutPaddingView.heightAnchor.constraint(equalToConstant: 48),
            cutoutPaddingView.widthAnchor.constraint(equalTo: cutoutPaddingView.heightAnchor),

            arrowImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -48),
            arrowImageView.topAnchor.constraint(equalTo: cutoutPaddingView.bottomAnchor, constant: 16),
            arrowImageView.bottomAnchor.constraint(equalTo: paddingView.topAnchor, constant: -32),
            arrowImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.7)
        ])
    }

    func setupSubviews() {
        [
            blurredView,
            paddingView,
            cutoutPaddingView,
            arrowImageView
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [titleLabel, labelsStack, proceedButton].forEach {
            paddingView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [upperLabel, lowerLabel].forEach {
            labelsStack.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func updateCutout() {
        let elementSize = CGSize(width: 48, height: 48)
        let cutoutFrame = CGRect(
            x: view.bounds.width - elementSize.width - 16,
            y: view.safeAreaInsets.top + 8,
            width: elementSize.width,
            height: elementSize.height
        )

        let path = UIBezierPath(rect: blurredView.bounds)
        let cutoutPath = UIBezierPath(roundedRect: cutoutFrame, cornerRadius: 24)
        path.append(cutoutPath)
        path.usesEvenOddFillRule = true

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd

        blurredView.layer.mask = maskLayer
    }
}
