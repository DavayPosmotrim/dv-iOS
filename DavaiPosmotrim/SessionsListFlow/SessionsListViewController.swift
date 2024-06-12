//
//  SessionsListViewController.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 07.06.2024.
//

import UIKit

final class SessionsListViewController: UIViewController {
    
    private lazy var customNavBar: UIView = {
        let customNavBar = CustomNavigationBar(title: Resources.SessionsList.title, subtitle: "")
        customNavBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        customNavBar.layer.cornerRadius = .radiusLarge
        // customNavBar.delegate = self
        return customNavBar
    }()

    private lazy var backgroundView = UIView()
    private lazy var sessionsListEmptyView = SessionsListEmptyView()

    private var sessions: [SessionModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension SessionsListViewController {

    func setupUI() {
        view.backgroundColor = .whiteBackground
        backgroundView.backgroundColor = .baseBackground
        sessionsListEmptyView.isHidden = !sessions.isEmpty

        [backgroundView, customNavBar, sessionsListEmptyView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            sessionsListEmptyView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            sessionsListEmptyView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            sessionsListEmptyView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: .spacingMedium),
            sessionsListEmptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
