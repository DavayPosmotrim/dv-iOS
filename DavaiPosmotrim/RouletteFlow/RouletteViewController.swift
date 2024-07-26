//
//  RouletteViewController.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 08.07.2024.
//

import UIKit

final class RouletteViewController: UIViewController {

    // MARK: - Stored Properties

    private var presenter: RoulettePresenterProtocol
    private var scrollTimer: Timer?
    private var isScrolling = false
    private var targetVelocity: CGFloat = .random(in: 45...65)
    private var velocityAdjustment: CGFloat = 0.05
    private var displayLink: CADisplayLink?

    private let usersCollectionModel = ReusableCollectionModel(
        image: nil,
        upperText: nil,
        lowerText: Resources.RouletteFlow.usersCollectionLowerText
    )

    // MARK: - Lazy Properties

    private lazy var movieCardCollectionView: UICollectionView = {
        let layout = CustomHorizontalCollectionLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            RouletteCollectionViewCell.self,
            forCellWithReuseIdentifier: RouletteCollectionViewCell.reuseIdentifier
        )

        collectionView.backgroundColor = .clear
        collectionView.bouncesZoom = true
        collectionView.isUserInteractionEnabled = false
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()

    private lazy var paddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .textHeadingFont
        label.textColor = .headingText
        label.numberOfLines = 1
        label.textAlignment = .natural
        label.text = Resources.RouletteFlow.usersCollectionTitleText

        return label
    }()

    private lazy var usersCollectionView: UIView = {
        let collectionView = ReusableUICollectionView()
        collectionView.setupCollectionView(
            with: self,
            cell: RouletteUsersCollectionCell.self,
            cellIdentifier: RouletteUsersCollectionCell.reuseIdentifier,
            and: usersCollectionModel
        )
        collectionView.deactivateUserInteraction()

        return collectionView
    }()

    // MARK: - Initializers

    init(presenter: RoulettePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .baseBackground

        setupSubviews()
        setupConstraints()

        presenter.downloadMoviesArray()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startScrolling()
        presenter.startRouletteController(with: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopScrolling()
    }

    // MARK: - Handlers

    @objc private func handleScroll() {
        let currentOffset = movieCardCollectionView.contentOffset
        let nextOffset = CGPoint(x: currentOffset.x + 1, y: currentOffset.y)

        if nextOffset.x <= movieCardCollectionView.contentSize.width - movieCardCollectionView.bounds.width {
            movieCardCollectionView.setContentOffset(nextOffset, animated: false)
        } else {
            let firstIndexPath = IndexPath(row: 0, section: 0)
            movieCardCollectionView.scrollToItem(
                at: firstIndexPath,
                at: .centeredHorizontally,
                animated: false
            )
        }
    }
}

// MARK: - Private methods

private extension RouletteViewController {
    func setupSubviews() {
        [movieCardCollectionView, paddingView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [titleLabel, usersCollectionView].forEach {
            paddingView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            movieCardCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            movieCardCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            movieCardCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            movieCardCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),

            paddingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            paddingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            paddingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            paddingView.heightAnchor.constraint(greaterThanOrEqualToConstant: 236),

            titleLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 16),

            usersCollectionView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor),
            usersCollectionView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor),
            usersCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            usersCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    func startScrolling() {
        scrollTimer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(handleScroll),
            userInfo: nil,
            repeats: true
        )
    }

    func stopScrolling() {
        scrollTimer?.invalidate()
        scrollTimer = nil
    }
}

    // MARK: - UICollectionViewDataSource

extension RouletteViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == movieCardCollectionView {
            return presenter.moviesCount
        } else {
            return presenter.usersCount
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView == movieCardCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RouletteCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? RouletteCollectionViewCell else { return UICollectionViewCell() }

            cell.configureCell(with: presenter.getMoviesAtIndex(index: indexPath.item))
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RouletteUsersCollectionCell.reuseIdentifier,
                for: indexPath
            ) as? RouletteUsersCollectionCell else { return UICollectionViewCell() }

            cell.backgroundColor = .clear
            cell.configureCell(with: presenter.getNamesAtIndex(index: indexPath.item))
            cell.configureConnection(with: presenter.getConnectedProperty(index: indexPath.row))
            return cell
        }
    }
}

    // MARK: - UICollectionViewDelegateFlowLayout

extension RouletteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionInset: CGFloat = 64
        let cellHeight: CGFloat = collectionView.frame.height * 0.5
        let cellWidth = collectionView.frame.width - collectionInset * 2

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        let lineSpacing: CGFloat = 48
        return lineSpacing
    }
}

    // MARK: - RouletteViewProtocol

extension RouletteViewController: RouletteViewProtocol {
    func startRouletteScroll() {
        movieCardCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)

        isScrolling = true

        displayLink = CADisplayLink(target: self, selector: #selector(updateScroll))
        displayLink?.add(to: .main, forMode: .default)
    }

    func hideUsersView() {
        paddingView.isHidden = true
        titleLabel.isHidden = true
        usersCollectionView.isHidden = true
    }

    func updateUsersCollectionViewHeight() {
        let itemHeight: CGFloat = 36
        let itemSpacing: CGFloat = 8
        let bottomSpacing: CGFloat = 110
        let itemWidth: CGFloat = 100

        let availableWidth = usersCollectionView.bounds.width
        let maxItemsPerRow = Int((availableWidth + itemSpacing) / (itemWidth + itemSpacing))
        let numberOfItems = presenter.usersCount
        let rows = (numberOfItems + maxItemsPerRow - 1) / maxItemsPerRow

        let totalHeight = itemHeight * CGFloat(rows) + itemSpacing * CGFloat(rows - 1) + bottomSpacing

        usersCollectionView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
}

    // MARK: - RouletteStartViewControllerDelegate

extension RouletteViewController: RouletteStartViewControllerDelegate {
    func didTapCancelButton() {
        presenter.finishRoulette()
    }

    func didTapBeginButton() {
        presenter.downloadUsersArray()
        presenter.connectUsers()
    }
}

    // MARK: - RouletteAnimation

extension RouletteViewController {

    @objc func updateScroll() {
        guard isScrolling else { return }

        let newOffset = movieCardCollectionView.contentOffset.x + targetVelocity
        movieCardCollectionView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: false)

        // Imitation of chosen movie id from server
        let middleIndex = presenter.movieIDs.count / 2
        let serverID = presenter.movieIDs[middleIndex]

        if targetVelocity > 0 {
            targetVelocity -= velocityAdjustment
        }

        let indexPaths = movieCardCollectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            guard let cell = movieCardCollectionView.cellForItem(at: indexPath) as? RouletteCollectionViewCell else {
                return
            }
            let cellID = cell.getCellID()
            if cellID == serverID && targetVelocity <= 5 {
                stopRouletteScroll(with: indexPath)
                return
            }
        }

        if targetVelocity < 0 {
            guard let index = presenter.movieIDs.firstIndex(of: serverID) else { return }
            let newIndexPath = IndexPath(item: index, section: 0)
            stopRouletteScroll(with: newIndexPath)
        }
    }

    func stopRouletteScroll(with indexPath: IndexPath) {
        stopScrolling()

        isScrolling = false

        movieCardCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
