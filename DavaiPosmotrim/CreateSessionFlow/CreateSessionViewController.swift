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

    private enum Keys: String {
        case nextButtonText = "ПРОДОЛЖИТЬ"
        case customNavBarTitle = "Создать сеанс"
        case customNavBarSubtitle = "Выберите понравившиеся подборки"
        case collectionTitle = "ПОДБОРКИ"
        case genreTitle = "ЖАНР"
        case collectionNotificationTitle = "Выберите хотя бы одну подборку"
        case genreNotificationTitle = "Выберите хотя бы один жанр"
    }

    // MARK: - Layout variables

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .baseBackground
        return view
    }()

    private lazy var customNavBar: UIView = {
        let customNavBar = CustomNavigationBar(
            title: Keys.customNavBarTitle.rawValue,
            subtitle: Keys.customNavBarSubtitle.rawValue
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
        button.blackButton.setTitle(Keys.nextButtonText.rawValue, for: .normal)
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

    private lazy var collectionView: UIView = {
        let collectionView = ReusableUICollectionView()
        collectionView.setupCollectionView(
            with: self,
            cell: CreateSessionCollectionCell.self,
            cellIdentifier: CreateSessionCollectionCell.reuseIdentifier
        )
        collectionView.isHidden = true

        return collectionView
    }()

    private lazy var segmentControl: CustomSegmentedControl = {
        let segmentControl = CustomSegmentedControl(items: [Keys.collectionTitle.rawValue, Keys.genreTitle.rawValue])
        segmentControl.selectedSegmentIndex = 0
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
        setupUI()
        setupSubviews()
        setupConstraints()
    }

    // MARK: - Actions

    @objc private func didTapNextButton() {
        let segmentIndex = segmentControl.selectedSegmentIndex
        let notificationTitle = segmentIndex == 0 ?
        Keys.collectionNotificationTitle.rawValue : Keys.genreNotificationTitle.rawValue
        guard let presenter = presenter else {
            return
        }
        if presenter.isSessionEmpty(segmentIndex: segmentIndex) {
            showNotification(title: notificationTitle, duration: 2.0)
            return
        }
        presenter.didTapNextButton()
    }

    @objc private func segmentControlValueChanged(_ sender: UISegmentedControl) {
        tableView.isHidden = sender.selectedSegmentIndex != 0
        collectionView.isHidden = sender.selectedSegmentIndex == 0
    }
}

    // MARK: - Private methods

private extension CreateSessionViewController {
    func setupUI() {
        tableView.register(
            CreateSessionTableViewCell.self,
            forCellReuseIdentifier: CreateSessionTableViewCell.reuseIdentifier
        )
    }

    func setupSubviews() {
        [
            backgroundView,
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

    func setupConstraints() {
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

    private func showNotification(title: String, duration: TimeInterval) {
        UIView.transition(
            with: customWarningNotification,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations: {
                self.customWarningNotification.setupNotification(
                    title: title,
                    imageView: .infoIcon,
                    color: .attentionAdditional
                )
                self.customWarningNotification.isHidden = false
                self.customNavBar.isHidden = true
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    UIView.transition(
                        with: self.customWarningNotification,
                        duration: 0.2,
                        options: .transitionCrossDissolve,
                        animations: {
                            self.customWarningNotification.isHidden = true
                            self.customNavBar.isHidden = false
                        },
                        completion: nil
                    )
                }
            }
        )
    }
}

// MARK: - CustomNavigationBarDelegate

extension CreateSessionViewController: CustomNavigationBarDelegate {

    func backButtonTapped() {
        presenter?.backButtonTapped()
    }
}

// MARK: - CreateSessionTableViewCellDelegate

extension CreateSessionViewController: CreateSessionTableViewCellDelegate {

    func tableViewCellTitleAdded(id: UUID?) {
        presenter?.didAddCollection(id: id)
    }

    func tableViewCellTitleRemoved(id: UUID?) {
        presenter?.didRemoveCollection(id: id)
    }
}

// MARK: - CreateSessionCollectionCellDelegate

extension CreateSessionViewController: CreateSessionCollectionCellDelegate {

    func collectionCellTitleAdded(id: UUID?) {
        presenter?.didAddGenres(id: id)
    }

    func collectionCellTitleRemoved(id: UUID?) {
        presenter?.didRemoveGenres(id: id)
    }
}

// MARK: - UITableViewDataSource

extension CreateSessionViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.getSelectionsMoviesCount() + 2
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let presenter = presenter,
              let cell = tableView.dequeueReusableCell(
                withIdentifier: CreateSessionTableViewCell.reuseIdentifier,
                for: indexPath
              ) as? CreateSessionTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row == 0 || indexPath.row == presenter.getSelectionsMoviesCount() + 1 {
            cell.backgroundColor = .baseBackground
        } else {
            let realIndex = indexPath.row - 1
            let model = presenter.getSelectionsMovie(index: realIndex)
            cell.configureCell(model: model)
            cell.delegate = self
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CreateSessionViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 168
        case (presenter?.getSelectionsMoviesCount() ?? 0) + 1:
            return 92
        default:
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
        cell.isSelectedTableViewCell.toggle()
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UICollectionViewDataSource

extension CreateSessionViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return presenter?.getGenresMoviesCount() ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let presenter = presenter,
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CreateSessionCollectionCell.reuseIdentifier,
                for: indexPath
              ) as? CreateSessionCollectionCell else {
            return UICollectionViewCell()
        }
        cell.configure(model: presenter.getGenreAtIndex(index: indexPath.item))
        cell.delegate = self
        return cell
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
        cell.isSelectedCollectionCell.toggle()
    }
}
