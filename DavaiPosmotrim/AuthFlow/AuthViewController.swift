//
//  AuthViewController.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import UIKit

final class AuthViewController: UIViewController {

    // MARK: - Stored properties

    var presenter: AuthPresenterProtocol

    private var reusableAuthModel: ReusableAuthViewModel?

    // MARK: - Lazy properties

    private lazy var createNameView: ReusableAuthView = {
        let view = ReusableAuthView(frame: .zero, authEvent: .edit)
        let name = presenter.checkUserNameProperty()
        view.setupView(with: reusableAuthModel)
        view.updateTextField(with: name)
        view.calculateCharactersNumber(with: name)
        return view
    }()

    // MARK: - Initializers

    init(presenter: AuthPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupModel()
        setupView()
    }

    // MARK: - Private methods

    private func setupView() {
        view.addSubview(createNameView)
        createNameView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            createNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            createNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            createNameView.topAnchor.constraint(equalTo: view.topAnchor),
            createNameView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupModel() {
        reusableAuthModel = ReusableAuthViewModel(
            enterButtonAction: { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true)
                self.presenter.authFinish()
            },
            checkSessionCodeAction: nil,
            userNameAction: { [weak self] text in
                guard let self else { return }
                self.presenter.authDidFinishNotification(userName: text)
                self.presenter.handleEnterButtonTap(with: text)
            }
        )
    }
}

    // MARK: - AuthViewProtocol

extension AuthViewController: AuthViewProtocol {

    func updateUIElements(
        text: String?,
        font: UIFont?,
        labelIsHidden: Bool,
        buttonIsEnabled: Bool
    ) {
        createNameView.updateUIElements(
            text: text,
            font: font,
            labelIsHidden: labelIsHidden,
            buttonIsEnabled: buttonIsEnabled
        )
    }
}
