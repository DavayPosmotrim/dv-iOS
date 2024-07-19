//
//  File.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 19.07.2024.
//

import UIKit

final class RouletteStartViewController: UIViewController {

    weak var delegate: RouletteStartViewControllerDelegate?

    // MARK: - Lazy properties

    private lazy var paddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .textLabelFont
        label.textColor = .headingText
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.text = Resources.RouletteFlow.startTitleLabelText

        return label
    }()

    private lazy var upperLabel: UILabel = {
        let label = UILabel()
        label.font = .textParagraphRegularFont
        label.textColor = .headingText
        label.numberOfLines = 2
        label.textAlignment = .natural
        label.attributedText = adjustTitleLabelText(
            with: Resources.RouletteFlow.startUpperLabelText,
            and: Resources.RouletteFlow.startUpperBoldLabelText
        )

        return label
    }()

    private lazy var lowerLabel: UILabel = {
        let label = UILabel()
        label.font = .textParagraphRegularFont
        label.textColor = .baseText
        label.numberOfLines = 2
        label.textAlignment = .natural
        label.text = Resources.RouletteFlow.startLowerLabelText

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

    private lazy var beginButton: UIView = {
        let button = CustomButtons()
        button.setupView(with: button.purpleButton)
        button.purpleButton.setTitle(Resources.RouletteFlow.beginButtonText, for: .normal)
        button.purpleButton.addTarget(self, action: #selector(didTapBeginButton(sender:)), for: .touchUpInside)

        return button
    }()

    private lazy var cancelButton: UIView = {
        let button = CustomButtons()
        button.setupView(with: button.clearButton)
        button.clearButton.setTitle(Resources.RouletteFlow.cancelButtonText, for: .normal)
        button.clearButton.addTarget(self, action: #selector(didTapCancelButton(sender:)), for: .touchUpInside)

        return button
    }()

    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 16

        return stack
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        setupConstraints()
    }

    // MARK: - Handlers

    @objc private func didTapBeginButton(sender: AnyObject) {
        dismiss(animated: true)
        delegate?.didTapBeginButton()
    }

    @objc private func didTapCancelButton(sender: AnyObject) {
        dismiss(animated: true)
        delegate?.didTapCancelButton()
    }
}

    // MARK: - Private methods

private extension RouletteStartViewController {

    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            paddingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            paddingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            paddingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            paddingView.heightAnchor.constraint(greaterThanOrEqualToConstant: 326),
            paddingView.heightAnchor.constraint(lessThanOrEqualToConstant: 360),

            titleLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 16),

            labelsStack.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 16),
            labelsStack.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -16),
            labelsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            labelsStack.bottomAnchor.constraint(equalTo: buttonsStack.topAnchor, constant: -32),

            buttonsStack.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 16),
            buttonsStack.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -16),
            buttonsStack.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            buttonsStack.heightAnchor.constraint(equalToConstant: 112)
        ])
    }

    func setupSubviews() {
        view.addSubview(paddingView)
        paddingView.translatesAutoresizingMaskIntoConstraints = false

        [titleLabel, labelsStack, buttonsStack].forEach {
            paddingView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [upperLabel, lowerLabel].forEach {
            labelsStack.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [beginButton, cancelButton].forEach {
            buttonsStack.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func adjustTitleLabelText(
        with text: String,
        and boldText: String
    ) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let boldRange = (attributedString.string as NSString).range(of: boldText)
        attributedString.addAttribute(.font, value: UIFont.textParagraphBoldFont as Any, range: boldRange)

        return attributedString
    }
}
