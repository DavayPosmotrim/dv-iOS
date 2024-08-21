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
    private var checkProperty: Bool?
    private var networkReachabilityManager: NetworkReachabilityManager?

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
        setupNetworkReachability()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopNetworkReachability()
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

    private func setupNetworkReachability() {
        networkReachabilityManager = NetworkReachabilityManager()
        networkReachabilityManager?.startListening(onUpdatePerforming: { [weak self] status in
            guard let self else { return }
            print("Network status changed: \(status)")
            switch status {
            case .notReachable:
                self.checkProperty = false
            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                self.checkProperty = true
            case .unknown:
                self.checkProperty = nil
            }
        })
    }

    private func stopNetworkReachability() {
        networkReachabilityManager?.stopListening()
    }

    private func setupModel() {
        reusableAuthModel = ReusableAuthViewModel(
            enterButtonAction: { [weak self] in
                guard let self else { return }
                if self.checkProperty == true {
                    self.dismiss(animated: true) {
                        self.presenter.authFinish()
                    }
                }
            },
            checkSessionCodeAction: nil,
            userNameAction: { [weak self] text in
                guard let self else { return }
                self.presenter.createUser(name: text) { isSuccess in
                    if isSuccess {
                        self.checkProperty = isSuccess
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
