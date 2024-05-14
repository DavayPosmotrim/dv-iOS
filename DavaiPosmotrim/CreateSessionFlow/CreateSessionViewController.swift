//
//  CreateSessionViewController.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import UIKit

final class CreateSessionViewController: UIViewController {

    // MARK: - Public Properties

    var presenter: CreateSessionPresenterProtocol?

    // MARK: - Private Properties

    private struct Keys {
        static let nextButtonText = "ПРОДОЛЖИТЬ"
        static let customNavBarTitle = "Создать сеанс"
        static let customNavBarSubtitle = "Выберите понравившиеся подборки"
        static let collectionTitle = "ПОДБОРКИ"
        static let genreTitle = "ЖАНР"
        static let collectionNotificationTitle = "Выберите хотя бы одну подборку"
        static let genreNotificationTitle = "Выберите хотя бы один жанр"
    }

    // MARK: - Layout variables

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .baseBackground
        return view
    }()

    private lazy var customNavBar: UIView = {
        let customNavBar = CustomNavigationBar(
            title: Keys.customNavBarTitle,
            subtitle: Keys.customNavBarSubtitle
        )
        customNavBar.delegate = self
        return customNavBar
    }()

    private lazy var customWarningNotification: CustomWarningNotification = {
        let view = CustomWarningNotification()
        view.isHidden = true
        return view
    }()

    private lazy var upperPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 24
        return view
    }()

    private lazy var lowerPaddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 24
        return view
    }()

    private lazy var nextButton: UIView = {
        let button = CustomButtons()
        button.setupView(with: button.blackButton)
        button.blackButton.setTitle(Keys.nextButtonText, for: .normal)
        button.blackButton.addTarget(
            self,
            action: #selector(didTapNextButton),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 176
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout.createLeftAlignedLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            CreateSessionCollectionCell.self,
            forCellWithReuseIdentifier: CreateSessionCollectionCell.reuseIdentifier
        )
        collectionView.backgroundColor = .whiteBackground
        collectionView.layer.cornerRadius = 24
        collectionView.isHidden = true
        return collectionView
    }()

    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: [Keys.collectionTitle, Keys.genreTitle])
        segmentControl.layer.cornerRadius = 15
        segmentControl.layer.masksToBounds = true
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = UIColor.baseBackground
        segmentControl.selectedSegmentTintColor = .baseTertiaryAccent
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.captionDarkText,
            .font: UIFont.textButtonMediumFont as Any
        ]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.whiteText,
            .font: UIFont.textButtonMediumFont as Any
        ]
        segmentControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentControl.addTarget(
            self,
            action: #selector(segmentControlValueChanged),
            for: .valueChanged
        )
        return segmentControl
    }()

    // MARK: - Initializers

    init(presenter: CreateSessionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(
            CreateSessionTableViewCell.self,
            forCellReuseIdentifier: CreateSessionTableViewCell.reuseIdentifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        setupSubviews()
        setupConstraints()
    }

    // MARK: - Actions

    @objc func didTapNextButton() {
        let notificationTitle = segmentControl.selectedSegmentIndex == 0 ?
        Keys.collectionNotificationTitle : Keys.genreNotificationTitle
        guard let presenter = presenter else {
            return
        }
        if presenter.createSession.collections.isEmpty && presenter.createSession.genres.isEmpty {
            customWarningNotification.setupNotification(
                title: notificationTitle,
                imageView: .infoIcon,
                color: .attentionAdditional
            )
            customWarningNotification.isHidden = false
            customNavBar.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.customWarningNotification.isHidden = true
                self.customNavBar.isHidden = false
            }
            return
        }
        presenter.showNextScreen(navigationController: navigationController)
    }

    @objc private func segmentControlValueChanged(_ sender: UISegmentedControl) {
        tableView.isHidden = sender.selectedSegmentIndex != 0
        collectionView.isHidden = sender.selectedSegmentIndex == 0
    }

    // MARK: - Private methods

    private func setupSubviews() {
        [backgroundView,
         tableView,
         collectionView,
         customNavBar,
         upperPaddingView,
         lowerPaddingView,
         customWarningNotification
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        [segmentControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            upperPaddingView.addSubview($0)
        }
        [nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            lowerPaddingView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            customWarningNotification.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customWarningNotification.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customWarningNotification.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            upperPaddingView.heightAnchor.constraint(equalToConstant: 96),
            upperPaddingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            upperPaddingView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            upperPaddingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            segmentControl.leadingAnchor.constraint(equalTo: upperPaddingView.leadingAnchor, constant: 16),
            segmentControl.topAnchor.constraint(equalTo: upperPaddingView.topAnchor, constant: 24),
            segmentControl.trailingAnchor.constraint(equalTo: upperPaddingView.trailingAnchor, constant: -16),
            segmentControl.bottomAnchor.constraint(equalTo: upperPaddingView.bottomAnchor, constant: -16),

            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: upperPaddingView.bottomAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: lowerPaddingView.topAnchor, constant: -16),

            lowerPaddingView.heightAnchor.constraint(equalToConstant: 84),
            lowerPaddingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lowerPaddingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lowerPaddingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            nextButton.heightAnchor.constraint(equalToConstant: 48),
            nextButton.leadingAnchor.constraint(equalTo: lowerPaddingView.leadingAnchor, constant: 16),
            nextButton.topAnchor.constraint(equalTo: lowerPaddingView.topAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: lowerPaddingView.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - CustomNavigationBarDelegate

extension CreateSessionViewController: CustomNavigationBarDelegate {

    func backButtonTapped() {
        presenter?.showPreviousScreen(navigationController: navigationController)
    }
}

// MARK: - CreateSessionTableViewCellDelegate

extension CreateSessionViewController: CreateSessionTableViewCellDelegate {

    func tableViewCellTitleAdded(title: String?) {
        self.presenter?.didAddCollection(title: title)
    }

    func tableViewCellTitleRemoved(title: String?) {
        self.presenter?.didRemoveCollection(title: title)
    }
}

// MARK: - CreateSessionCollectionCellDelegate

extension CreateSessionViewController: CreateSessionCollectionCellDelegate {

    func collectionCellTitleAdded(title: String?) {
        self.presenter?.didAddGenres(title: title)
    }

    func collectionCellTitleRemoved(title: String?) {
        self.presenter?.didRemoveGenres(title: title)
    }
}

// MARK: - UITableViewDataSource

extension CreateSessionViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return selectionsMockData.count + 2
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == selectionsMockData.count + 1 {
            let cell = UITableViewCell()
            cell.backgroundColor = .baseBackground
            return cell
        } else {
            let realIndex = indexPath.row - 1
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CreateSessionTableViewCell.reuseIdentifier,
                for: indexPath
            )
            guard let createSessionTableViewCell = cell as? CreateSessionTableViewCell else {
                return UITableViewCell()
            }
            let model = selectionsMockData[realIndex]
            createSessionTableViewCell.configureCell(model: model)
            createSessionTableViewCell.delegate = self
            return createSessionTableViewCell
        }
    }
}

// MARK: - UITableViewDelegate

extension CreateSessionViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        if indexPath.row == 0 {
            return 168
        } else if indexPath.row == selectionsMockData.count + 1 {
            return 92
        } else {
            return 176
        }
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CreateSessionTableViewCell else {
            return
        }
        cell.handleTableCellSelected()
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UICollectionViewDataSource

extension CreateSessionViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return genreMockData.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CreateSessionCollectionCell.reuseIdentifier,
            for: indexPath
        )
        guard let collectionCell = cell as? CreateSessionCollectionCell else {
            assertionFailure("Warning: type cast error, empty cells")
            return UICollectionViewCell()
        }
        collectionCell.configure(title: genreMockData[indexPath.row])
        collectionCell.delegate = self
        return collectionCell
    }
}

// MARK: - UICollectionViewDelegate

extension CreateSessionViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CreateSessionCollectionCell else {
            return
        }
        cell.handleCollectionCellSelected()
    }
}
