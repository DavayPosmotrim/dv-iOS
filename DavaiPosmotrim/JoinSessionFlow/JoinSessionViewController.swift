//
//  JoinSessionViewController.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import UIKit

final class JoinSessionViewController: UIViewController {

    // MARK: - Stored properties

    var presenter: JoinSessionPresenterProtocol?

    private let collectionModel = ReusableCollectionModel(
        image: UIImage.addUserPlug,
        upperText: Resources.JoinSession.upperLabelText,
        lowerText: Resources.JoinSession.lowerLabelText
    )

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

        var combinedString = ""
        if let presenter {
            combinedString = Resources.JoinSession.sessionNameLabelText + presenter.checkCreatedCodeProperty()
        }

        label.text = combinedString
        label.textAlignment = .center

        return label
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

        presenter?.downloadNamesArrayFromServer()
    }

    // MARK: - Initializers

    init(presenter: JoinSessionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupSubViews() {
        [
            upperPaddingView,
            sessionNameLabel,
            lowerPaddingView,
            enterButton,
            collectionView
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
            enterButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),

            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: upperPaddingView.bottomAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: lowerPaddingView.topAnchor, constant: -16)
        ])
    }

    // MARK: - Handlers

    @objc private func didTapEnterButton(sender: AnyObject) {
        guard let navigationController else { return }
        let viewController = DismissJoinSessionViewController()
        viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        navigationController.present(viewController, animated: true)
    }
}

    // MARK: - UICollectionViewDataSource

extension JoinSessionViewController: UICollectionViewDataSource {
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

    // MARK: - JoinSessionViewProtocol

extension JoinSessionViewController: JoinSessionViewProtocol {
// TODO: - add code to use viewController's methods in presenter
}

    // MARK: - DismissJoinSessionDelegate

extension JoinSessionViewController: DismissJoinSessionDelegate {
    func finishJoinSessionFlow() {
        guard let presenter else { return }
        presenter.joinSessionFinish()
    }
}
