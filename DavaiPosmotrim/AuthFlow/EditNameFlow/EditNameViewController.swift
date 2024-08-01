//
//  EditNameViewController.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import UIKit

final class EditNameViewController: UIViewController {

    // MARK: - Stored properties

    var presenter: EditNamePresenterProtocol

    private var reusableAuthModel: ReusableAuthViewModel?

    // MARK: - Lazy properties

    private lazy var editNameView: ReusableAuthView = {
        let view = ReusableAuthView(frame: .zero, authEvent: .edit)
        let name = presenter.checkUserNameProperty()
        view.setupView(with: reusableAuthModel)
        view.updateTextField(with: name)
        view.calculateCharactersNumber(with: name)
        return view
    }()

    // MARK: - Initializers

    init(presenter: EditNamePresenterProtocol) {
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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        presenter.finishEdit()
    }

    // MARK: - Private methods

    private func setupView() {
        view.addSubview(editNameView)
        editNameView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            editNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editNameView.topAnchor.constraint(equalTo: view.topAnchor),
            editNameView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupModel() {
        reusableAuthModel = ReusableAuthViewModel(
            enterButtonAction: { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true)
                self.presenter.finishEdit()
            },
            checkSessionCodeAction: nil,
            userNameAction: { [weak self] text in
                guard let self else { return "" }
                self.presenter.authDidFinishNotification(userName: text)
                return self.presenter.handleEnterButtonTap(with: text)
            }
        )
    }
}

extension EditNameViewController : EditNameViewProtocol {
    
    func updateUIElements(
        text: String?,
        font: UIFont?,
        labelIsHidden: Bool,
        buttonIsEnabled: Bool
    ) {
        editNameView.updateUIElements(
            text: text,
            font: font,
            labelIsHidden: labelIsHidden,
            buttonIsEnabled: buttonIsEnabled
        )
    }
}
