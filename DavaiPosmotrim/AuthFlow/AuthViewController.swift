//
//  AuthViewController.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import UIKit

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

final class AuthViewController: UIViewController {

    // MARK: - Stored properties

    var presenter: AuthPresenterProtocol?

    private var userName = String()
    private var sessionEnterCode = String()
    private let authEvent: AuthEvent

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
        textField.inputAccessoryView = enterButton
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

    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .basePrimaryAccent
        button.titleLabel?.font = .textButtonMediumFont
        button.setTitle(authEvent.buttonLabelText, for: .normal)
        button.setTitleColor(.whiteText, for: .normal)
        button.addTarget(
            self,
            action: #selector(enterButtonDidTap(sender:)),
            for: .touchUpInside
        )
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteBackground

        setupTextFieldProperties()
        setupSubviews()
        setupConstraints()
    }

    // MARK: - Initializers

    init(presenter: AuthPresenter, authEvent: AuthEvent) {
        self.presenter = presenter
        self.authEvent = authEvent
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupSubviews() {
        [
            upperLabel,
            nameTextField,
            lowerLabel,
            enterButton
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            upperLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 159),
            upperLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            upperLabel.heightAnchor.constraint(equalToConstant: 16),

            nameTextField.topAnchor.constraint(equalTo: upperLabel.bottomAnchor, constant: 12),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            lowerLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            lowerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lowerLabel.heightAnchor.constraint(equalToConstant: 16),

            enterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            enterButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            enterButton.heightAnchor.constraint(equalToConstant: 64),
            enterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupTextFieldProperties() {
        guard let presenter else { return }
        if authEvent != .joinSession {
            userName = presenter.checkUserNameProperty()
            presenter.calculateCharactersNumber(with: userName)
        } else {
            presenter.checkSessionCode(with: sessionEnterCode)
        }
    }

    // MARK: - Handlers

    @objc func textFieldDidChange(sender: UITextField) {
        guard let text = sender.text, let presenter else { return }
        if authEvent != .joinSession {
            presenter.calculateCharactersNumber(with: text)
        } else {
            sessionEnterCode = text
            presenter.checkSessionCode(with: sessionEnterCode)
        }
    }

    @objc func enterButtonDidTap(sender: AnyObject) {

        // TODO: - add code to save userName on server

        guard let presenter, let text = nameTextField.text else { return }
        if authEvent != .joinSession {
            userName = presenter.handleEnterButtonTap(with: text)
            presenter.authDidFinishNotification(userName: userName)
        } else {
            presenter.startJoinSessionFlowNotification()
        }

        nameTextField.resignFirstResponder()
        self.dismiss(animated: true)

        DispatchQueue.main.async {
            presenter.authFinish()
        }
    }
}

    // MARK: - UITextFieldDelegate

extension AuthViewController: UITextFieldDelegate {

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

    // MARK: - AuthViewProtocol

extension AuthViewController: AuthViewProtocol {

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
