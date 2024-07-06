//
//  SessionsListViewController.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 07.06.2024.
//

import UIKit

final class SessionsListViewController: UIViewController, SessionsListViewControllerProtocol {

    // MARK: - Public properties
    var presenter: SessionsListPresenterProtocol
    enum Section: Int, Hashable, CaseIterable {
        case empty, sessions
    }

    // MARK: - Private properties
    private var isSessionsListEmpty: Bool = false {
        didSet {
            sessionsListEmptyView.isHidden = !isSessionsListEmpty
            collectionView.isHidden = isSessionsListEmpty
        }
    }
    private enum Size {
        static let fullSize: CGFloat = 1
        static let smallSpacing: CGFloat = 8
        static let sessionHeight: CGFloat = 240
    }
    private lazy var dataSource = configureDataSource()

    // MARK: - View properties
    private lazy var customNavBar: UIView = {
        let customNavBar = CustomNavigationBar(title: Resources.SessionsList.title, subtitle: "")
        customNavBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        customNavBar.layer.cornerRadius = .radiusLarge
        customNavBar.delegate = presenter as? any CustomNavigationBarDelegate
        return customNavBar
    }()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.allowsMultipleSelection = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    private lazy var backgroundView = UIView()
    private lazy var sessionsListEmptyView = SessionsListEmptyView()

    // MARK: - Inits
    init(presenter: SessionsListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupUI()
        applySnapshot()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showListOrEmptyView()
    }

    // MARK: - Public methods
    func showListOrEmptyView() {
        collectionView.reloadData()
        isSessionsListEmpty = presenter.isSessionsListEmpty
    }
}

// MARK: - UICollectionViewDelegate
extension SessionsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        // TODO: - add code later
        guard let cell = collectionView.cellForItem(at: indexPath) as? SessionsListCell else { return }
        if indexPath.row == presenter.sessionsCount - 1 {
            presenter.updateSessionsList()
        } else {
            // TODO: - wait new MainCoordinator
            presenter.showSessionMovies(by: indexPath.row)
        }
    }
}

// MARK: - Private methods
private extension SessionsListViewController {

    func setupUI() {
        view.backgroundColor = .whiteBackground
        backgroundView.backgroundColor = .baseBackground
        sessionsListEmptyView.showDescription(true)

        [
            backgroundView,
            sessionsListEmptyView,
            collectionView,
            customNavBar
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            customNavBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            customNavBar.topAnchor.constraint(equalTo: safeArea.topAnchor),

            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: -.spacingMedium * 3),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            sessionsListEmptyView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            sessionsListEmptyView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            sessionsListEmptyView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: .spacingMedium),
            sessionsListEmptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionType = Section(rawValue: sectionIndex) else { return nil }
            let group = sectionType == .empty
            ? NSCollectionLayoutGroup.vertical(layoutSize: self.setSize(for: .empty), subitems: [self.setItem()])
            : NSCollectionLayoutGroup.vertical(layoutSize: self.setSize(for: .sessions), subitems: [self.setItem()])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = sectionType == .empty ? .zero : .spacingMedium
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }

    func setItem() -> NSCollectionLayoutItem {
        NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Size.fullSize),
            heightDimension: .fractionalHeight(Size.fullSize)
        ))
    }

    func setSize(for type: Section) -> NSCollectionLayoutSize {
        NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Size.fullSize),
            heightDimension: .absolute(type == .empty ? .spacingMedium * 4 : Size.sessionHeight)
        )
    }
    func createEmptyCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, Int> {
        UICollectionView.CellRegistration<UICollectionViewCell, Int> { _, _, _ in
        }
    }

    func createSessionCellRegistration() -> UICollectionView.CellRegistration<SessionsListCell, SessionModel> {
        UICollectionView.CellRegistration<SessionsListCell, SessionModel> { cell, _, session in
            cell.configureCell(for: session)
        }
    }

    func configureDataSource() -> UICollectionViewDiffableDataSource<Section, AnyHashable> {
        let emptyCellRegistration = createEmptyCellRegistration()
        let sessionCellRegistration = createSessionCellRegistration()

        let dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) {
            // swiftlint:disable:next closure_parameter_position
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            return Section(rawValue: indexPath.section) == .empty
            ? collectionView.dequeueConfiguredReusableCell(
                using: emptyCellRegistration,
                for: indexPath,
                item: item as? Int
            )
            : collectionView.dequeueConfiguredReusableCell(
                using: sessionCellRegistration,
                for: indexPath,
                item: item as? SessionModel
            )
        }
        return dataSource
    }

    func applySnapshot() {
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(sections)

        var emptySnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        emptySnapshot.append([Int()])
        dataSource.apply(
            emptySnapshot,
            to: .empty,
            animatingDifferences: false
        )

        var moviesSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        moviesSnapshot.append(presenter.sessions)
        dataSource.apply(
            moviesSnapshot,
            to: .sessions,
            animatingDifferences: false
        )
    }
}
