//
//  JoinSessionViewController.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import UIKit

final class JoinSessionViewController: UIViewController {

    // MARK: - Lazy properties

    private lazy var upperPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        return view
    }()

    private lazy var sessionNameLabel: UILabel = {
        let label = UILabel()
        label.font = .textLabelFont
        label.textColor = .headingText
        label.text = "Сеанс AAaa567"
        // TODO: rewrite code here to get session name from UserDefaults
        label.textAlignment = .center

        return label
    }()

    private lazy var lowerPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return view
    }()

    private lazy var enterButton: UIView = {
        let button = CustomButtons()
        button.setupView(with: button.blackButton)
        button.blackButton.setTitle(Resources.JoinSession.enterButtonLabelText, for: .normal)
        button.blackButton.addTarget(self, action: #selector(didTapEnterButton(sender:)), for: .touchUpInside)

        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .baseBackground

        setupSubViews()
        setupConstraints()
    }

    // MARK: - Private methods

    private func setupSubViews() {
        [
            upperPaddingView,
            sessionNameLabel,
            lowerPaddingView,
            enterButton
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            upperPaddingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            upperPaddingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            upperPaddingView.topAnchor.constraint(equalTo: view.topAnchor),
            upperPaddingView.bottomAnchor.constraint(equalTo: safeArea.topAnchor, constant: 64),

            sessionNameLabel.leadingAnchor.constraint(equalTo: upperPaddingView.leadingAnchor),
            sessionNameLabel.trailingAnchor.constraint(equalTo: upperPaddingView.trailingAnchor),
            sessionNameLabel.bottomAnchor.constraint(equalTo: upperPaddingView.bottomAnchor, constant: -20),
            sessionNameLabel.heightAnchor.constraint(equalToConstant: 24),

            lowerPaddingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            lowerPaddingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            lowerPaddingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            lowerPaddingView.topAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -84),

            enterButton.leadingAnchor.constraint(equalTo: lowerPaddingView.leadingAnchor, constant: 16),
            enterButton.trailingAnchor.constraint(equalTo: lowerPaddingView.trailingAnchor, constant: -16),
            enterButton.topAnchor.constraint(equalTo: lowerPaddingView.topAnchor, constant: 16),
            enterButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Handlers

    @objc private func didTapEnterButton(sender: AnyObject) {
        // TODO: - add code to handle enterButton tap
    }
}

extension JoinSessionViewController: JoinSessionViewProtocol {
    // TODO: - add code to use viewController's methods in presenter
}
