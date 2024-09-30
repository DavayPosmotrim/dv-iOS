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
    private var loadingVC: CustomLoadingViewController?
    private var isDismissedManually = true
    private var isServerReachable: Bool?
    private var networkReachabilityHandler: NetworkReachabilityHandler

    // MARK: - Lazy properties

    private lazy var joinSessionAuthView: ReusableAuthView = {
        let view = ReusableAuthView(frame: .zero, authEvent: .joinSession)
        view.setupView(with: reusableAuthModel)
        return view
    }()

    // MARK: - Initializers

    init(
        presenter: JoinSessionAuthPresenterProtocol,
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

        if isDismissedManually {
            presenter.finishSessionAuth()
        }
        networkReachabilityHandler.stopListening()
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
            enterButtonAction: { [weak self] code, completion in
                guard let self else { return }
                self.presenter.connectUserToSession(with: code) { isSuccess in
                    self.isServerReachable = isSuccess
                    completion(isSuccess)
                    if isSuccess {
                        self.presenter.saveSessionCode(code: code)
                        print(code)
                    }
                }
            },
            proceedAction: { [weak self] in
                guard let self else { return }
                self.isDismissedManually = false
                self.presentingViewController?.dismiss(animated: true) {
                    self.presenter.showJoinSession()
                }
            }
        )
    }
}

    // MARK: - JoinSessionAuthViewProtocol

extension JoinSessionAuthViewController: JoinSessionAuthViewProtocol {

    func showLoader() {
        loadingVC = CustomLoadingViewController.show(in: self)
    }

    func hideLoader() {
        loadingVC?.hide()
    }

    func showNetworkError() {
        joinSessionAuthView.updateUIElements(
            text: Resources.Authentication.lowerLabelNetworkError,
            font: nil,
            labelIsHidden: false,
            buttonIsEnabled: true
        )
    }

    func showSessionCodeError() {
        joinSessionAuthView.updateUIElements(
            text: Resources.Authentication.lowerLabelSessionNotFound,
            font: nil,
            labelIsHidden: false,
            buttonIsEnabled: true
        )
    }
}

    // MARK: - NetworkReachabilityHandlerDelegate

extension JoinSessionAuthViewController: NetworkReachabilityHandlerDelegate {

    func didChangeNetworkStatus(isReachable: Bool?) {
        isServerReachable = isReachable
    }
}
