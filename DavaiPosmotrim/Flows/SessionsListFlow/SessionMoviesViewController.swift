//
//  SessionMoviesViewController.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 22.06.2024.
//

import UIKit

final class SessionMoviesViewController: UIViewController, SessionMoviesViewControllerProtocol {

    // MARK: - Public properties
    var presenter: SessionMoviesPresenterProtocol

    enum Section: Int, Hashable, CaseIterable {
        case users, empty, movies
    }

    // MARK: - Private properties
    private enum Size {
        static let fullSize: CGFloat = 1
        static let smallSpacing: CGFloat = 8
        // swiftlint:disable:next nesting
        enum Cell {
            static let user: CGFloat = 36
            static let movie: CGFloat = 240
        }
        // swiftlint:disable:next nesting
        enum Header {
            static let user: CGFloat = 48
            static let movie: CGFloat = 16
        }
    }

    private lazy var dataSource = configureDataSource()

    // MARK: - View properties
    private lazy var customNavBar: UIView = {
        let customNavBar = CustomNavigationBar(title: presenter.sessionDateForTitle, subtitle: presenter.sessionCode)
        customNavBar.delegate = presenter as? any CustomNavigationBarDelegate
        return customNavBar
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .whiteBackground
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.allowsMultipleSelection = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    // MARK: - Inits
    init(presenter: SessionMoviesPresenterProtocol) {
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
}

// MARK: - UICollectionViewDelegate
extension SessionMoviesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard Section(rawValue: indexPath.section) != .users,
            let cell = collectionView.cellForItem(at: indexPath) as? ReusableLikedMoviesCell else { return }

        // TODO: - change random to real index later
        let index = Int.random(in: 0...selectionMovieMockData.count)

        presenter.showMovie(by: index)
    }
}

// MARK: - Private methods
private extension SessionMoviesViewController {

    func setupUI() {
        view.backgroundColor = .whiteBackground

        [
            customNavBar,
            collectionView
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionType = Section(rawValue: sectionIndex) else { return nil }

            let section: NSCollectionLayoutSection
            switch sectionType {
            case .users: section = self.createUsersSectionLayout()
            case .empty: section = self.createEmptySectionLayout()
            case .movies: section = self.createMoviesSectionLayout()
            }
            return section
        }
        var layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        layout = registerSectionBackground(layout: layout)
        return layout
    }

    func createUsersSectionLayout() -> NSCollectionLayoutSection {
        var section: NSCollectionLayoutSection
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(Size.Cell.user),
            heightDimension: .absolute(Size.Cell.user)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Size.fullSize),
            heightDimension: .estimated(Size.Cell.user)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(Size.smallSpacing)
        section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Size.smallSpacing
        section.contentInsets = createSectionInsets()

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Size.fullSize),
            heightDimension: .estimated(Size.Header.user)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SessionUserHeader.headerID,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        section = createBackground(for: .users, on: section)
        return section
    }

    func createEmptySectionLayout() -> NSCollectionLayoutSection {
        var section: NSCollectionLayoutSection
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Size.fullSize),
            heightDimension: .fractionalHeight(Size.fullSize)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Size.fullSize),
            heightDimension: .absolute(.spacingMedium)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        section = NSCollectionLayoutSection(group: group)
        section = createBackground(for: .empty, on: section)
        return section
    }

    func createMoviesSectionLayout() -> NSCollectionLayoutSection {
        var section: NSCollectionLayoutSection
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Size.fullSize),
            heightDimension: .fractionalHeight(Size.fullSize)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Size.fullSize),
            heightDimension: .absolute(Size.Cell.movie)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(.spacingMedium)
        section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = .spacingMedium
        section.contentInsets = createSectionInsets()
        section = createBackground(for: .movies, on: section)
        return section
    }

    func createBackground(for type: Section, on section: NSCollectionLayoutSection) -> NSCollectionLayoutSection {
        let currentSection: String
        switch type {
        case .users: currentSection = SessionUserSection.sectionID
        case .empty: currentSection = SessionBaseSection.sectionID
        case .movies: currentSection = SessionMovieSection.sectionID
        }
        let baseDecoration = NSCollectionLayoutDecorationItem.background(elementKind: SessionBaseSection.sectionID)
        let currentSectionDecoration = NSCollectionLayoutDecorationItem.background(elementKind: currentSection)
        section.decorationItems = [baseDecoration, currentSectionDecoration]
        return section
    }

    func registerSectionBackground(layout: UICollectionViewCompositionalLayout) -> UICollectionViewCompositionalLayout {
        layout.register(SessionUserSection.self, forDecorationViewOfKind: SessionUserSection.sectionID)
        layout.register(SessionBaseSection.self, forDecorationViewOfKind: SessionBaseSection.sectionID)
        layout.register(SessionMovieSection.self, forDecorationViewOfKind: SessionMovieSection.sectionID)
        return layout
    }

    func createSectionInsets() -> NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets.init(
            top: .spacingMedium,
            leading: .spacingMedium,
            bottom: .spacingMedium,
            trailing: .spacingMedium
        )
    }
    func createUserCellRegistration() -> UICollectionView.CellRegistration<
        ReusableUICollectionViewCell,
        ReusableCollectionCellModel
    > {
        UICollectionView.CellRegistration<ReusableUICollectionViewCell, ReusableCollectionCellModel> { cell, _, user in
            cell.configureCell(with: user)
        }
    }

    func createEmptyCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, Int> {
        UICollectionView.CellRegistration<UICollectionViewCell, Int> { _, _, _ in
        }
    }

    func createMovieCellRegistration() -> UICollectionView.CellRegistration<
        ReusableLikedMoviesCell,
        ReusableLikedMoviesCellModel
    > {
        UICollectionView.CellRegistration<ReusableLikedMoviesCell, ReusableLikedMoviesCellModel> { cell, _, movie in
            cell.configureCell(with: movie)
        }
    }

    func createUserHeaderRegistration() -> UICollectionView.SupplementaryRegistration<SessionUserHeader> {
        UICollectionView.SupplementaryRegistration(elementKind: SessionUserHeader.headerID) { _, _, _ in
        }
    }

    func configureDataSource() -> UICollectionViewDiffableDataSource<Section, AnyHashable> {
        let userCellRegistration = createUserCellRegistration()
        let emptyCellRegistration = createEmptyCellRegistration()
        let movieCellRegistration = createMovieCellRegistration()
        let userHeaderRegistration = createUserHeaderRegistration()

        let dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) {
            // swiftlint:disable:next closure_parameter_position
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch Section(rawValue: indexPath.section) {
            case .users:
                return collectionView.dequeueConfiguredReusableCell(
                    using: userCellRegistration,
                    for: indexPath,
                    item: item as? ReusableCollectionCellModel
                )
            case .empty:
                return collectionView.dequeueConfiguredReusableCell(
                    using: emptyCellRegistration,
                    for: indexPath,
                    item: item as? Int
                )
            case .movies:
                return collectionView.dequeueConfiguredReusableCell(
                    using: movieCellRegistration,
                    for: indexPath,
                    item: item as? ReusableLikedMoviesCellModel
                )
            case .none:
                fatalError("Unknown section!")
            }
        }

        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            guard kind == SessionUserHeader.headerID else { fatalError("Unknown header") }
            return collectionView.dequeueConfiguredReusableSupplementary(using: userHeaderRegistration, for: indexPath)
        }

        return dataSource
    }

    func applySnapshot() {
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(sections)

        var usersSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        usersSnapshot.append(presenter.users)
        dataSource.apply(
            usersSnapshot,
            to: .users,
            animatingDifferences: false
        )

        var emptySnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        emptySnapshot.append([Int()])
        dataSource.apply(
            emptySnapshot,
            to: .empty,
            animatingDifferences: false
        )

        var moviesSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        moviesSnapshot.append(presenter.movies)
        dataSource.apply(
            moviesSnapshot,
            to: .movies,
            animatingDifferences: false
        )
    }
}
