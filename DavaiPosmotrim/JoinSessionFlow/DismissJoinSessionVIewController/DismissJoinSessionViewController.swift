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
        customAlertModel = CustomAlertModel(
            alertTitle: Resources.JoinSession.customLabelUpperText,
            alertMessage: Resources.JoinSession.customLabelLowerText,
            yesAction: { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true)
                self.delegate?.finishJoinSessionFlow()
            },
            noAction: { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true)
            })
    }
}
