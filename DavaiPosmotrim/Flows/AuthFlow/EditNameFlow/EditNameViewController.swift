//
//  EditNameViewController.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import UIKit
import Alamofire

final class EditNameViewController: UIViewController {

    // MARK: - Stored properties

    var presenter: EditNamePresenterProtocol

    private var reusableAuthModel: ReusableAuthViewModel?
    private var loadingVC: CustomLoadingViewController?
    private var isServerReachable: Bool?
    private var networkReachabilityHandler: NetworkReachabilityHandler

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

    init(
        presenter: EditNamePresenterProtocol,
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

        presenter.finishEdit()
        networkReachabilityHandler.stopListening()
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
            enterButtonAction: { [weak self] text, completion in
                guard let self else { return }
                self.presenter.updateUser(name: text) { isSuccess in
                    self.isServerReachable = isSuccess
                    completion(isSuccess)
                    if isSuccess {
                        self.presenter.authDidFinishNotification(userName: text)
                    }
                }
            },
            proceedAction: { [weak self] in
                guard let self else { return }
                if self.isServerReachable == true {
                    self.presentingViewController?.dismiss(animated: true) {
                        self.presenter.finishEdit()
                    }
                }
            }
        )
    }
}

    // MARK: - EditNameViewProtocol

extension EditNameViewController: EditNameViewProtocol {

    func showLoader() {
        loadingVC = CustomLoadingViewController.show(in: self)
    }

    func hideLoader() {
        loadingVC?.hide()
    }

    func showError() {
        editNameView.updateUIElements(
            text: Resources.Authentication.lowerLabelNetworkError,
            font: nil,
            labelIsHidden: false,
            buttonIsEnabled: false
        )
    }
}

    // MARK: - NetworkReachabilityHandlerDelegate

extension EditNameViewController: NetworkReachabilityHandlerDelegate {

    func didChangeNetworkStatus(isReachable: Bool?) {
        isServerReachable = isReachable
    }
}
