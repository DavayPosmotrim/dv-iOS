//
//  ReusableAuthView.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import UIKit

struct ReusableAuthViewModel {
    let enterButtonAction: (() -> Void)?
    let checkSessionCodeAction: ((String) -> Void)?
    let userNameAction: ((String) -> Void)?
}

enum AuthEvent {
    case auth
    case edit
    case joinSession

    var titleText: String {
        switch self {
        case .auth, .edit:
            return Resources.Authentication.upperLabelText
        case .joinSession:
            return Resources.Authentication.joinSessionUpperText
        }
    }

    var buttonLabelText: String {
        switch self {
        case .auth:
            return Resources.Authentication.enterButtonLabelText
        case .edit:
            return Resources.Authentication.editButtonLabelText
        case .joinSession:
            return Resources.Authentication.joinSessionButtonLabelText
        }
    }
}

final class ReusableAuthView: UIView {

    // MARK: - Stored properties

    private let charactersMinNumber = 2
    private let charactersBarrierNumber = 12
    private let charactersMaxNumber = 17
    private let authCodeMaxNumber = 7

    private let authEvent: AuthEvent

    private var enterButtonAction: (() -> Void)?
    private var checkSessionCodeAction: ((String) -> Void)?
    private var userNameAction: ((String) -> Void)?

    // MARK: - Lazy properties

    private lazy var upperLabel: UILabel = {
        let label = UILabel()
        label.font = .textCaptionRegularFont
        label.textColor = .captionDarkText
        label.text = authEvent.titleText
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.tintColor = .basePrimaryAccent
        textField.textColor = .headingText
        textField.backgroundColor = .clear
        textField.font = .textHeadingFont
        textField.textAlignment = .center
        textField.becomeFirstResponder()
        textField.inputAccessoryView = toolbar
        textField.addTarget(
            self,
            action: #selector(textFieldDidChange(sender:)),
            for: .editingChanged
        )
        textField.delegate = self
        return textField
    }()

    private lazy var lowerLabel: UILabel = {
        let label = UILabel()
        label.font = .textCaptionRegularFont
        label.textColor = .errorAdditional
        return label
    }()

    private lazy var toolbar = UIToolbar(
        frame: CGRect(
            x: 0,
            y: bounds.height - 64,
            width: bounds.width,
            height: 64
        )
    )

    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .basePrimaryAccent
        button.titleLabel?.font = .textButtonMediumFont
        button.setTitle(authEvent.buttonLabelText, for: .normal)
        button.setTitleColor(.whiteText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(
            self,
            action: #selector(enterButtonDidTap(sender:)),
            for: .touchUpInside
        )
        return button
    }()

    // MARK: - Initializers

    init(frame: CGRect, authEvent: AuthEvent) {
        self.authEvent = authEvent
        super.init(frame: frame)

        backgroundColor = .whiteBackground

        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func setupView(with model: ReusableAuthViewModel?) {
        guard let model else { return }
        enterButtonAction = model.enterButtonAction
        checkSessionCodeAction = model.checkSessionCodeAction
        userNameAction = model.userNameAction
    }

    func updateUIElements(
        text: String?,
        font: UIFont?,
        labelIsHidden: Bool,
        buttonIsEnabled: Bool
    ) {
        lowerLabel.text = text ?? ""
        lowerLabel.isHidden = labelIsHidden
        enterButton.isEnabled = buttonIsEnabled
        if let font {
            textField.font = font
        }
    }

    func calculateCharactersNumber(with text: String) {
        switch (text.isEmpty, text.count) {
        case (true, _):
            updateUIElements(
                text: Resources.Authentication.lowerLabelInputNameWarningText,
                font: nil,
                labelIsHidden: false,
                buttonIsEnabled: false
            )
        case (false, 0..<charactersMinNumber):
            updateUIElements(
                text: Resources.Authentication.lowerLabelLengthWarningText,
                font: nil,
                labelIsHidden: false,
                buttonIsEnabled: false
            )
        case (false, charactersBarrierNumber...):
            updateUIElements(
                text: nil,
                font: .textLabelFont,
                labelIsHidden: true,
                buttonIsEnabled: true
            )
        default:
            updateUIElements(
                text: nil,
                font: .textHeadingFont,
                labelIsHidden: true,
                buttonIsEnabled: true
            )
        }
    }

    func updateTextField(with text: String) {
        textField.text = text
    }
}

private extension ReusableAuthView {

    // MARK: - Handlers

    @objc func enterButtonDidTap(sender: AnyObject) {
        guard let text = textField.text else { return }
        if authEvent != .joinSession {
            userNameAction?(text)
        }

        textField.resignFirstResponder()
        enterButtonAction?()
    }

    @objc func textFieldDidChange(sender: UITextField) {
        guard let text = sender.text else { return }
        if authEvent != .joinSession {
            calculateCharactersNumber(with: text)
        } else {
            checkSessionCodeAction?(text)
        }
    }

    // MARK: - Private methods

    func setupSubviews() {
        [
            upperLabel,
            textField,
            lowerLabel
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        toolbar.addSubview(enterButton)
        enterButton.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            upperLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 159),
            upperLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            upperLabel.heightAnchor.constraint(equalToConstant: 16),

            textField.topAnchor.constraint(equalTo: upperLabel.bottomAnchor, constant: 12),
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),

            lowerLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 12),
            lowerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            lowerLabel.heightAnchor.constraint(equalToConstant: 16),

            enterButton.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor),
            enterButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor),
            enterButton.topAnchor.constraint(equalTo: toolbar.topAnchor),
            enterButton.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor)
        ])
    }
}

    // MARK: - UITextFieldDelegate

extension ReusableAuthView: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let maximumLength = authEvent == .joinSession ? authCodeMaxNumber : charactersMaxNumber
        let currentString = (textField.text ?? "") as NSString
        let updatedString = currentString.replacingCharacters(in: range, with: string)
        
        switch authEvent {
        case .joinSession:
            if updatedString.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
                return false
            }
        default:
            if updatedString.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
                updateUIElements(
                    text: Resources.Authentication.lowerLabelNumbersWarningText,
                    font: nil,
                    labelIsHidden: false,
                    buttonIsEnabled: false
                )
                return false
            } else if updatedString.count == maximumLength {
                updateUIElements(
                    text: Resources.Authentication.lowerLabelMaxCharactersText,
                    font: nil,
                    labelIsHidden: false,
                    buttonIsEnabled: false
                )
                return false
            }
        }
        return updatedString.count <= maximumLength
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if enterButton.isEnabled {
            enterButtonDidTap(sender: textField)
        }
        return true
    }
}
