//
//  InvitingUsersPresenter.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 28.05.2024.
//

import UIKit

final class InvitingUsersViewController: UIViewController, InvitingUsersViewProtocol {

    // MARK: - Public Properties

    var presenter: InvitingUsersPresenterProtocol?

    // MARK: - Private properties

    private lazy var upperPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        return view
    }()

    private lazy var usersLabel: UILabel = {
        let label = UILabel()
        label.font = .textLabelFont
        label.textColor = .headingText
        label.text = "Участники"
        label.textAlignment = .center

        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupSubViews()
        setupConstraints()
    }

    // MARK: - Initializers

    init(presenter: InvitingUsersPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupSubViews() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        [
            upperPaddingView,
            usersLabel
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
            upperPaddingView.bottomAnchor.constraint(equalTo: safeArea.topAnchor, constant: 64 + 88),

            usersLabel.centerXAnchor.constraint(equalTo: upperPaddingView.centerXAnchor),
            usersLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20)
        ])
    }
}
