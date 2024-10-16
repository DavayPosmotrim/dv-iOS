//
//  DismissSelectionMoviesViewController.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 29.06.24.
//

import UIKit

final class DismissSelectionMoviesViewController: UIViewController {

    // MARK: - Stored properties

    private var customAlertModel: CustomAlertModel?
    private var alertType: AlertType
    weak var delegate: DismissSelectionMoviesDelegate?

    // MARK: - Lazy properties

    private lazy var customAlert: CustomAlertView = {
        return CustomAlertView()
    }()

    // MARK: - Initializers

    init(alertType: AlertType) {
        self.alertType = alertType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlert()
        setupView()
    }

    // MARK: - Private methods

    private func setupView() {
        view.addSubview(customAlert)
        customAlert.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            customAlert.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            customAlert.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            customAlert.topAnchor.constraint(equalTo: view.topAnchor),
            customAlert.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupAlert() {
        let alertTitle: String
        let alertMessage: String
        switch alertType {
        case .twoButtons:
            alertTitle = Resources.SelectionMovies.customLabelUpperText
            alertMessage = Resources.SelectionMovies.customLabelLowerText
        case .oneButton:
            alertTitle = Resources.SelectionMovies.customOneButtonLabelUpperText
            alertMessage = Resources.SelectionMovies.customOneButtonLabelLowerText
        }

        customAlertModel = CustomAlertModel(
            alertTitle: alertTitle,
            alertMessage: alertMessage,
            yesAction: { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true)
                self.delegate?.closeAlertTypeTwoButtons()
            },
            noAction: { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true)
            },
            progressAction: { [weak self] in
                guard let self else { return }
                self.delegate?.closeAlertTypeOneButton()
                self.dismiss(animated: true)
            },
            alertType: alertType
        )
        customAlert.setupCustomAlert(with: customAlertModel)
    }
}
