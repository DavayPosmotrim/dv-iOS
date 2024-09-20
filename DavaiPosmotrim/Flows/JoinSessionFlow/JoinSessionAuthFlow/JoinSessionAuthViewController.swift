//
//  JoinSessionAuthViewController.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import UIKit

final class JoinSessionAuthViewController: UIViewController {

    // MARK: - Stored properties

    var presenter: JoinSessionAuthPresenterProtocol

    private var reusableAuthModel: ReusableAuthViewModel?
    private var isDismissedManually = true

    // MARK: - Lazy properties

    private lazy var joinSessionAuthView: ReusableAuthView = {
        let view = ReusableAuthView(frame: .zero, authEvent: .joinSession)
        view.setupView(with: reusableAuthModel)
        return view
    }()

    // MARK: - Initializers

    init(presenter: JoinSessionAuthPresenterProtocol) {
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

        if isDismissedManually {
            presenter.finishSessionAuth()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.downloadSessionCode()
    }

    // MARK: - Private methods

    private func setupView() {
        view.addSubview(joinSessionAuthView)
        joinSessionAuthView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            joinSessionAuthView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            joinSessionAuthView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            joinSessionAuthView.topAnchor.constraint(equalTo: view.topAnchor),
            joinSessionAuthView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupModel() {
        reusableAuthModel = ReusableAuthViewModel(
            userNameAction: nil,
            enterButtonAction: { [weak self] in
                guard let self else { return }
                self.isDismissedManually = false
                self.dismiss(animated: true)
                self.presenter.showJoinSession()
            },
            checkSessionCodeAction: { [weak self] code in
                guard let self else { return }
                self.presenter.checkSessionCode(with: code)
            }
        )
    }
}

extension JoinSessionAuthViewController: JoinSessionAuthViewProtocol {

    func updateUIElements(
        text: String?,
        font: UIFont?,
        labelIsHidden: Bool,
        buttonIsEnabled: Bool
    ) {
        joinSessionAuthView.updateUIElements(
            text: text,
            font: font,
            labelIsHidden: labelIsHidden,
            buttonIsEnabled: buttonIsEnabled
        )
    }
}
