//
//  CreateSessionViewController.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import UIKit

final class CreateSessionViewController: UIViewController {

    // MARK: - Public properties

    var presenter: CreateSessionPresenterProtocol
    var isServerReachable: Bool?

    // MARK: - Private properties

    private var loadingVC: CustomLoadingViewController?
    private var networkReachabilityHandler: NetworkReachabilityHandler

    // MARK: - Layout variables

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .baseBackground
        return view
    }()

    private lazy var customNavBar: UIView = {
        let customNavBar = CustomNavigationBar(
            title: Resources.CreateSession.customNavBarTitle,
            subtitle: Resources.CreateSession.customNavBarSubtitle
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
        button.blackButton.setTitle(Resources.CreateSession.nextButtonText, for: .normal)
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
        let segmentControl = CustomSegmentedControl(items: [
            Resources.CreateSession.collectionTitle,
            Resources.CreateSession.genreTitle
        ])
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

    init(
        presenter: CreateSessionPresenter,
        networkReachabilityHandler: NetworkReachabilityHandler = NetworkReachabilityHandler()
    ) {
        self.presenter = presenter
        self.networkReachabilityHandler = networkReachabilityHandler
        super.init(nibName: nil, bundle: nil)
        self.networkReachabilityHandler.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteBackground
        setupUI()
        setupSubviews()
        setupConstraints()
        networkReachabilityHandler.setupNetworkReachability()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        networkReachabilityHandler.stopListening()
    }

    // MARK: - Actions

    @objc private func didTapNextButton() {
        let segmentIndex = segmentControl.selectedSegmentIndex
        let notificationTitle = segmentIndex == 0 ?
        Resources.CreateSession.collectionNotificationTitle : Resources.CreateSession.genreNotificationTitle
        if presenter.isSessionEmpty(segmentIndex: segmentIndex) {
            showNotification(title: notificationTitle, duration: 2.0)
            return
        }
        presenter.didTapNextButton(segmentIndex: segmentIndex)
    }

    @objc private func segmentControlValueChanged(_ sender: UISegmentedControl) {
        tableView.isHidden = sender.selectedSegmentIndex != 0
        collectionView.isHidden = sender.selectedSegmentIndex == 0
    }
}

    // MARK: - Private methods

private extension CreateSessionViewController {

    func loadData() {
        showLoader()

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        self.presenter.getCollections { [weak self] isSuccess in
            self?.isServerReachable = isSuccess
            if isSuccess {
                self?.tableView.reloadData()
            }
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        self.presenter.getGenres { [weak self] isSuccess in
            self?.isServerReachable = isSuccess
            if isSuccess {
                if let collectionView = self?.collectionView as? ReusableUICollectionView {
                    collectionView.updateCollectionView()
                }
                NotificationCenter.default.post(
                    name: NSNotification.Name(Resources.ReusableCollectionView.updateCollectionView),
                    object: nil
                )
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.hideLoader()
        }
    }

    func setupUI() {
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.reuseIdentifier)
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
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        upperPaddingView.addSubview(segmentControl)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        lowerPaddingView.addSubview(nextButton)
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

    func showNotification(title: String, duration: TimeInterval) {
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
        presenter.backButtonTapped()
    }
}

    // MARK: - CreateSessionTableViewCellDelegate

extension CreateSessionViewController: CreateSessionTableViewCellDelegate {

    func tableViewCellTitleAdded(id: UUID?) {
        presenter.didAddCollection(id: id)
    }

    func tableViewCellTitleRemoved(id: UUID?) {
        presenter.didRemoveCollection(id: id)
    }
}

    // MARK: - CreateSessionCollectionCellDelegate

extension CreateSessionViewController: CreateSessionCollectionCellDelegate {

    func collectionCellTitleAdded(id: UUID?) {
        presenter.didAddGenres(id: id)
    }

    func collectionCellTitleRemoved(id: UUID?) {
        presenter.didRemoveGenres(id: id)
    }
}

    // MARK: - UITableViewDataSource

extension CreateSessionViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getSelectionsMoviesCount() + 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 || indexPath.row == presenter.getSelectionsMoviesCount() + 1 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: EmptyTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? EmptyTableViewCell else {
                return UITableViewCell()
            }
            cell.backgroundColor = .baseBackground
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CreateSessionTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? CreateSessionTableViewCell else {
                return UITableViewCell()
            }
            let realIndex = indexPath.row - 1
            let model = presenter.getSelectionsMovie(index: realIndex)
            cell.configureCell(model: model)
            cell.delegate = self
            return cell
        }
    }
}

    // MARK: - UITableViewDelegate

extension CreateSessionViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 168
        case presenter.getSelectionsMoviesCount() + 1:
            return 92
        default:
            return 176
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CreateSessionTableViewCell else {
            return
        }
        cell.isSelectedTableViewCell.toggle()
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

    // MARK: - UICollectionViewDataSource

extension CreateSessionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getGenresMoviesCount()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CreateSessionCollectionCell else {
            return
        }
        cell.isSelectedCollectionCell.toggle()
    }
}

    // MARK: - NetworkReachabilityHandlerDelegate

extension CreateSessionViewController: NetworkReachabilityHandlerDelegate {

    func didChangeNetworkStatus(isReachable: Bool?) {
        isServerReachable = isReachable
    }
}

    // MARK: - CreateSessionViewProtocol

extension CreateSessionViewController: CreateSessionViewProtocol {

    func showLoader() {
        loadingVC = CustomLoadingViewController.show(in: self)
    }

    func hideLoader() {
        loadingVC?.hide()
        loadingVC = nil
    }
}
