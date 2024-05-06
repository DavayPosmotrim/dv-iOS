//
//  AuthViewController.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import UIKit

final class AuthViewController: UIViewController {

    // MARK: - Stored properties

    var presenter: AuthPresenter?

    private var userName: String
    private var enterButtonBottomAnchor = NSLayoutConstraint()

    // MARK: - Lazy properties

    private lazy var upperLabel: UILabel = {
        let label = UILabel()
        label.font = .textCaptionRegularFont
        label.textColor = .captionDarkText
        label.text = Resources.Authentication.upperLabelText
        return label
    }()

    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.text = userName
        textField.tintColor = .basePrimaryAccent
        textField.textColor = .headingText
        textField.backgroundColor = .clear
        textField.font = .textHeadingFont
        textField.textAlignment = .center
        textField.becomeFirstResponder()
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
        button.setTitle(Resources.Authentication.enterButtonLabelText, for: .normal)
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

        setupSubviews()
        setupConstraints()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    // MARK: - Initializers

    init(presenter: AuthPresenter, userName: String) {
        self.presenter = presenter
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
        enterButtonBottomAnchor = enterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

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
            enterButtonBottomAnchor
        ])
    }

    func updateUIElements(
        text: String?,
        font: UIFont?,
        labelProperty: Bool?,
        buttonProperty: Bool?
    ) {
        lowerLabel.text = text ?? ""
        lowerLabel.isHidden = labelProperty ?? true
        enterButton.isEnabled = buttonProperty ?? false
        if let font {
            nameTextField.font = font
        }
    }

    // MARK: - Handlers

    @objc func textFieldDidChange(sender: UITextField) {
        guard let text = sender.text else { return }
        presenter?.calculateCharactersNumber(with: text)
    }

    @objc func enterButtonDidTap(sender: AnyObject) {

        // TODO: - add code to pass userName to MainViewController and save it on server
        
        if let name = nameTextField.text {
            if name.isEmpty {
                updateUIElements(
                    text: Resources.Authentication.lowerLabelInputNameWarningText,
                    font: nil,
                    labelProperty: false,
                    buttonProperty: nil
                )
            } else {
                userName = name
                DispatchQueue.main.async {
                    self.presenter?.authFinish()
                }
            }
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let safeAreaBottom = view.safeAreaInsets.bottom
            var newButtonOffset = keyboardHeight - safeAreaBottom
            newButtonOffset = max(0, newButtonOffset)
            enterButtonBottomAnchor.constant = -newButtonOffset
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
        let maximumLength = 16
        let currentString = (textField.text ?? "") as NSString
        let updatedString = currentString.replacingCharacters(in: range, with: string)
        if updatedString.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
            updateUIElements(
                text: Resources.Authentication.lowerLabelNumbersWarningText,
                font: nil,
                labelProperty: false,
                buttonProperty: true
            )
            return false
        }
        return updatedString.count <= maximumLength
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return false
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
    // TODO: - add code to use viewControllers method in presenter
}
