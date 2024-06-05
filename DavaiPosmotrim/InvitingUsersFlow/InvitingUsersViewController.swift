//
//  InvitingUsersPresenter.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 28.05.2024.
//

import UIKit

final class InvitingUsersViewController: UIViewController {

    // MARK: - Public Properties

    var presenter: InvitingUsersPresenterProtocol?

    // MARK: - Private properties

    private let collectionModel = ReusableCollectionModel(
        image: UIImage.addUserPlug,
        upperText: nil,
        lowerText: Resources.InvitingSession.lowerLabelText
    )

    private lazy var upperPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        return view
    }()

    private lazy var customWarningNotification: CustomWarningNotification = {
        let view = CustomWarningNotification()
        view.setupNotification(
            title: Resources.InvitingSession.usersLabelText,
            imageView: nil,
            color: .whiteBackground,
            font: .textLabelFont
        )
        return view
    }()

    private lazy var codeButton: UIView = {
        let button = CustomButtons()
        button.setupView(with: button.grayButton)
        button.grayButton.setTitle("code", for: .normal)
        //        button.purpleButton.addTarget(self, action: #selector(didTapNextButton(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var inviteButton: UIView = {
        let button = CustomButtons()
        button.setupView(with: button.blackButton)
        button.blackButton.setTitle(Resources.InvitingSession.inviteButtonLabelText, for: .normal)
        //        button.purpleButton.addTarget(self, action: #selector(didTapNextButton(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var collectionView: UIView = {
        let collectionView = ReusableUICollectionView()
        collectionView.setupCollectionView(
            with: self,
            cell: ReusableUICollectionViewCell.self,
            cellIdentifier: ReusableUICollectionViewCell.reuseIdentifier,
            and: collectionModel
        )

        return collectionView
    }()

    private lazy var headerButtonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually

        return stackView
    }()

    private lazy var lowerPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return view
    }()

    private lazy var startButton: UIView = {
        let button = CustomButtons()
        button.setupView(with: button.blackButton)
        button.blackButton.setTitle(Resources.InvitingSession.startButtonLabelText, for: .normal)
        button.blackButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)

        return button
    }()

    private lazy var cancelButton: UIView = {
        let button = CustomButtons()
        button.grayButton.backgroundColor = .whiteBackground
        button.setupView(with: button.grayButton)
        button.grayButton.setTitle(Resources.InvitingSession.cancelButtonLabelText, for: .normal)
        //        button.blackButton.addTarget(self, action: #selector(didTapEnterButton(sender:)), for: .touchUpInside)

        return button
    }()

    private lazy var footerButtonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually

        return stackView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .baseBackground
        setupSubViews()
        setupButtonsStacksView()
        setupConstraints()
        presenter?.viewDidLoad()
    }

    // MARK: - Initializers

    init(presenter: InvitingUsersPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Handlers

    @objc func startButtonTapped() {
        presenter?.startButtonTapped()
    }

    // MARK: - Private methods

    private func setupButtonsStacksView() {
        [
            codeButton,
            inviteButton
        ].forEach {
            headerButtonsStack.addArrangedSubview($0)
        }

        [
            startButton,
            cancelButton
        ].forEach {
            footerButtonsStack.addArrangedSubview($0)
        }
    }

    private func setupSubViews() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        [
            upperPaddingView,
            collectionView,
            lowerPaddingView,
            //            usersLabel,
            headerButtonsStack,
            footerButtonsStack,
            customWarningNotification
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

            customWarningNotification.topAnchor.constraint(equalTo: safeArea.topAnchor),
            customWarningNotification.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            customWarningNotification.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            customWarningNotification.bottomAnchor.constraint(equalTo: headerButtonsStack.topAnchor, constant: -20),

            headerButtonsStack.heightAnchor.constraint(equalToConstant: 48),
            headerButtonsStack.bottomAnchor.constraint(equalTo: upperPaddingView.bottomAnchor, constant: -16),
            headerButtonsStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            headerButtonsStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),

            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: upperPaddingView.bottomAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: lowerPaddingView.topAnchor, constant: -16),

            lowerPaddingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            lowerPaddingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            lowerPaddingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            lowerPaddingView.topAnchor.constraint(equalTo: footerButtonsStack.topAnchor, constant: -16),

            footerButtonsStack.heightAnchor.constraint(equalToConstant: 48+48+16),
            footerButtonsStack.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            footerButtonsStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            footerButtonsStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension InvitingUsersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let presenter else { return .zero}
        return presenter.getNamesCount()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let presenter,
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ReusableUICollectionViewCell.reuseIdentifier,
                for: indexPath
              ) as? ReusableUICollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(with: presenter.getNamesAtIndex(index: indexPath.item))
        return cell
    }
}

// MARK: - InvitingUsersViewProtocol

extension InvitingUsersViewController: InvitingUsersViewProtocol {
    func showFewUsersWarning() {
        UIView.transition(with: self.customWarningNotification, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.customWarningNotification.setupNotification(
                title: "Должно быть хотя бы два участника",
                imageView: .infoIcon,
                color: .attentionAdditional
            )}) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    UIView.transition(with: self.customWarningNotification, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        self.customWarningNotification.setupNotification(
                            title: "Участники",
                            imageView: nil,
                            color: .whiteBackground,
                            font: .textLabelFont
                        )}, completion: nil)
                }
            }
    }
}
