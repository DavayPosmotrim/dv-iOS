//
//  DismissSelectionMoviesViewController.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 29.06.24.
//

import UIKit

enum AlertType {
    case twoButtons
    case oneButton
}

final class DismissSelectionMoviesViewController: UIViewController {

    // MARK: - Stored properties

    private var customAlertOneButtonModel: CustomAlertOneButtonModel?
    private var customAlertModel: CustomAlertModel?
    private var alertTitle: String?
    private var alertMessage: String?
    private var alertType: AlertType
    weak var delegate: DismissSelectionMoviesDelegate?

    // MARK: - Lazy properties

    private lazy var customAlert: UIView = {
        switch alertType {
        case .twoButtons:
            let view = CustomAlertView()
            view.setupCustomAlert(with: customAlertModel)
            return view
        case .oneButton:
            let view = CustomAlertOneButtonView()
            view.setupCustomAlertOneButton(with: customAlertOneButtonModel)
            return view
        }
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlert()
        setupView()
    }

    init(alertType: AlertType) {
        self.alertType = alertType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        switch alertType {
        case .twoButtons:
            customAlertModel = CustomAlertModel(
                alertTitle: Resources.SelectionMovies.customLabelUpperText,
                alertMessage: Resources.SelectionMovies.customLabelLowerText,
                yesAction: { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.finishSelectionMoviesFlow()
                    self.dismiss(animated: true)
                },
                noAction: { [weak self] in
                    guard let self = self else { return }
                    self.dismiss(animated: true)
                })
            (customAlert as? CustomAlertView)?.setupCustomAlert(with: customAlertModel)

        case .oneButton:
            customAlertOneButtonModel = CustomAlertOneButtonModel(
                alertTitle: Resources.SelectionMovies.customOneButtonLabelUpperText,
                alertMessage: Resources.SelectionMovies.customOneButtonLabelLowerText,
                progressAction: { [weak self] in
                    guard let self = self else { return }

                    self.delegate?.finishSelectionMoviesFlow()
                    self.dismiss(animated: true)
                })
            (customAlert as? CustomAlertOneButtonView)?.setupCustomAlertOneButton(with: customAlertOneButtonModel)
        }
    }
}
