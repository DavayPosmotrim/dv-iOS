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
    private var checkProperty: Bool?
    private var networkReachabilityManager: NetworkReachabilityManager?

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
        setupNetworkReachability()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        presenter.finishEdit()
        stopNetworkReachability()
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
                    self.presentingViewController?.dismiss(animated: true) {
                        self.presenter.finishEdit()
                    }
                }
            },
            checkSessionCodeAction: nil,
            userNameAction: { [weak self] text in
                guard let self else { return }
                self.presenter.updateUser(name: text) { isSuccess in
                    if isSuccess {
                        self.checkProperty = isSuccess
                        self.presenter.authDidFinishNotification(userName: text)
                    }
                }
            }
        )
    }
}

extension EditNameViewController : EditNameViewProtocol {

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
