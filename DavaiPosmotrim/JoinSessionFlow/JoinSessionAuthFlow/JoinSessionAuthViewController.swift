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

    // MARK: - Lazy properties

    private lazy var editNameView: ReusableAuthView = {
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

//        presenter.finishSessionAuth()
//        print("finish join auth")
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
                self.presenter.showJoinSession()
            },
            textFieldAction: nil,
            userNameAction: nil,
            setupAction: nil,
            finishFlowAction: nil)
    }
}

extension JoinSessionAuthViewController: JoinSessionAuthViewProtocol {}
