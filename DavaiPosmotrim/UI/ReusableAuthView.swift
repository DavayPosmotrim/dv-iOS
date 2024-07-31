//
//  ReusableAuthView.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import UIKit

struct ReusableAuthViewModel {
    let enterButtonAction: (() -> Void)?
    let textFieldAction: (() -> Void)?
    let userNameAction: (() -> String)?
    let setupAction: (() -> Void)?
    let finishFlowAction: (() -> Void)?
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

    private var userName = String()
    private var sessionEnterCode = String()
    private let authEvent: AuthEvent

    private var enterButtonAction: (() -> Void)?
    private var textFieldAction: (() -> Void)?
    private var userNameAction: (() -> String)?
    private var setupAction: (() -> Void)?
    private var finishFlowAction: (() -> Void)?

    // MARK: - Lazy properties

    private lazy var upperLabel: UILabel = {
        let label = UILabel()
        label.font = .textCaptionRegularFont
        label.textColor = .captionDarkText
        label.text = authEvent.titleText
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.text = authEvent == .joinSession ? sessionEnterCode : userName
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
        textFieldAction = model.textFieldAction
        userNameAction = model.userNameAction
        setupAction = model.setupAction
        finishFlowAction = model.finishFlowAction
    }

    func updateUIElements(
        text: String?,
        font: UIFont?,
        labelProperty: Bool,
        buttonProperty: Bool
    ) {
        lowerLabel.text = text ?? ""
        lowerLabel.isHidden = labelProperty
        enterButton.isEnabled = buttonProperty
        if let font {
            nameTextField.font = font
        }
    }
}

private extension ReusableAuthView {

    // MARK: - Handlers

    @objc func enterButtonDidTap(sender: AnyObject) {
        guard let text = nameTextField.text else { return }
        if authEvent != .joinSession {
            userName = text
            enterButtonAction?()
        }

        nameTextField.resignFirstResponder()

        enterButtonAction?()

        DispatchQueue.main.async {
            self.finishFlowAction?()
        }
    }

    @objc func textFieldDidChange(sender: UITextField) {
        guard let text = sender.text else { return }
        if authEvent != .joinSession {
            textFieldAction?()
        } else {
            sessionEnterCode = text
            textFieldAction?()
        }
    }

    // MARK: - Private methods

    func setupSubviews() {
        [
            upperLabel,
            nameTextField,
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

            nameTextField.topAnchor.constraint(equalTo: upperLabel.bottomAnchor, constant: 12),
            nameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),

            lowerLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            lowerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            lowerLabel.heightAnchor.constraint(equalToConstant: 16),

            enterButton.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor),
            enterButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor),
            enterButton.topAnchor.constraint(equalTo: toolbar.topAnchor),
            enterButton.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor)
        ])
    }

    func setupTextFieldProperties() {
        if authEvent != .joinSession {
            guard let userNameAction else { return }
            userName = userNameAction()
        }
        setupAction?()
    }
}

    // MARK: - UITextFieldDelegate

extension ReusableAuthView: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let maximumLength = authEvent == .joinSession ? 7 : 17
        let currentString = (textField.text ?? "") as NSString
        let updatedString = currentString.replacingCharacters(in: range, with: string)
        if authEvent != .joinSession {
            if updatedString.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
                updateUIElements(
                    text: Resources.Authentication.lowerLabelNumbersWarningText,
                    font: nil,
                    labelProperty: false,
                    buttonProperty: false
                )
                return false
            } else if updatedString.count == maximumLength {
                updateUIElements(
                    text: Resources.Authentication.lowerLabelMaxCharactersText,
                    font: nil,
                    labelProperty: false,
                    buttonProperty: false
                )
                return false
            }
        } else if authEvent == .joinSession {
            if updatedString.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
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
