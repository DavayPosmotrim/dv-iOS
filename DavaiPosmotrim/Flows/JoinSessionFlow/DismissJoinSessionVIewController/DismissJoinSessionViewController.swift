//
//  DismissJoinSessionViewController.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.05.2024.
//

import UIKit

final class DismissJoinSessionViewController: UIViewController {

    // MARK: - Stored properties

    private var customAlertModel: CustomAlertModel?
    private var alertTitle: String?
    private var alertMessage: String?
    weak var delegate: DismissJoinSessionDelegate?

    // MARK: - Lazy properties

    private lazy var customAlert: UIView = {
        let view = CustomAlertView()
        view.setupCustomAlert(with: customAlertModel)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAlert()
        setupView()
    }

    init(alertTitle: String? = nil, alertMessage: String? = nil) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupView() {
        view.addSubview(customAlert)

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            customAlert.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            customAlert.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            customAlert.topAnchor.constraint(equalTo: view.topAnchor),
            customAlert.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupAlert() {
        let title = alertTitle ?? Resources.JoinSession.customLabelUpperText
        let alertMessage = alertMessage ?? Resources.JoinSession.customLabelLowerText

        customAlertModel = CustomAlertModel(
            alertTitle: title,
            alertMessage: alertMessage,
            yesAction: { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true)
                self.delegate?.finishJoinSessionFlow()
            },
            noAction: { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true)
            },
            progressAction: nil,
            alertType: .twoButtons
        )
    }
}
