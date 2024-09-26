//
//  AuthViewController.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import UIKit
import Alamofire

final class AuthViewController: UIViewController {

    // MARK: - Stored properties

    var presenter: AuthPresenterProtocol

    private var reusableAuthModel: ReusableAuthViewModel?
    private var loadingVC: CustomLoadingViewController?
    private var isServerReachable: Bool?
    private var networkReachabilityHandler: NetworkReachabilityHandler

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

    init(
        presenter: AuthPresenterProtocol,
        networkReachabilityHandler: NetworkReachabilityHandler = NetworkReachabilityHandler()
    ) {
        self.presenter = presenter
        self.networkReachabilityHandler = networkReachabilityHandler
        super.init(nibName: nil, bundle: nil)
        self.networkReachabilityHandler.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupModel()
        setupView()
        networkReachabilityHandler.setupNetworkReachability()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        networkReachabilityHandler.stopListening()
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
            enterButtonAction: { [weak self] text, completion in
                guard let self else { return }
                self.presenter.createUser(name: text) { isSuccess in
                    self.isServerReachable = isSuccess
                    completion(isSuccess)
                }
            },
            proceedAction: { [weak self] in
                guard let self else { return }
                if self.isServerReachable == true {
                    self.dismiss(animated: true) {
                        self.presenter.authFinish()
                    }
                }
            }
        )
    }
}

    // MARK: - AuthViewProtocol

extension AuthViewController: AuthViewProtocol {

    func showLoader() {
        loadingVC = CustomLoadingViewController.show(in: self)
    }

    func hideLoader() {
        loadingVC?.hide()
    }

    func showError() {
        createNameView.updateUIElements(
            text: Resources.Authentication.lowerLabelNetworkError,
            font: nil,
            labelIsHidden: false,
            buttonIsEnabled: false
        )
    }
}

    // MARK: - NetworkReachabilityHandlerDelegate

extension AuthViewController: NetworkReachabilityHandlerDelegate {

    func didChangeNetworkStatus(isReachable: Bool?) {
        isServerReachable = isReachable
    }
}
