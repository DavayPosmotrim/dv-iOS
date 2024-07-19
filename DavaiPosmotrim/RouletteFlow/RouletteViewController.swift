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

    private let usersCollectionModel = ReusableCollectionModel(
        image: nil,
        upperText: nil,
        lowerText: Resources.RouletteFlow.usersCollectionLowerText
    )

    private var isScrolling = false
    private var targetVelocity: CGFloat = 40 // Adjust as needed
    private var velocityAdjustment: CGFloat = 0.05 // Adjust for smoothness
    private var displayLink: CADisplayLink?

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
            cell: ReusableUICollectionViewCell.self,
            cellIdentifier: ReusableUICollectionViewCell.reuseIdentifier,
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
            paddingView.heightAnchor.constraint(lessThanOrEqualToConstant: 360),

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
                withReuseIdentifier: ReusableUICollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? ReusableUICollectionViewCell else { return UICollectionViewCell() }

            cell.configureCell(with: presenter.getNamesAtIndex(index: indexPath.item))
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
        let cellHeight: CGFloat = 420
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
        targetVelocity = 30

        displayLink = CADisplayLink(target: self, selector: #selector(updateScroll))
        displayLink?.add(to: .main, forMode: .default)
    }

    func hideUsersView() {
        paddingView.isHidden = true
        titleLabel.isHidden = true
        usersCollectionView.isHidden = true
    }
}

    // MARK: - RouletteStartViewControllerDelegate

extension RouletteViewController: RouletteStartViewControllerDelegate {
    func didTapCancelButton() {
        presenter.finishRoulette()
    }

    func didTapBeginButton() {
        presenter.downloadUsersArray()
    }
}

    // MARK: - RouletteAnimation

extension RouletteViewController {

    @objc func updateScroll() {
        guard isScrolling else { return }

        let newOffset = movieCardCollectionView.contentOffset.x + targetVelocity
        movieCardCollectionView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: false)

        // Check if it needs to slow down
        if targetVelocity > 0 {
            targetVelocity -= velocityAdjustment
        }

        // If the target velocity is low enough, stop scrolling
        if targetVelocity < 0 {
            stopRouletteScroll()
        }
        print(targetVelocity)
    }

    func stopRouletteScroll() {
        isScrolling = false

        // Ensure we have the correct layout to calculate item size
        guard let layout = movieCardCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let itemWidth = layout.itemSize.width
        let centerOffset = movieCardCollectionView.bounds.size.width / 2
        let nearestIndex = Int(ceil((movieCardCollectionView.contentOffset.x + centerOffset) / itemWidth))

        // clamp nearestIndex to valid range
        let numberOfItems = movieCardCollectionView.numberOfItems(inSection: 0)
        let clampedIndex = max(0, min(nearestIndex, numberOfItems - 1))

        stopScrolling()
        let visibleItems = movieCardCollectionView.indexPathsForVisibleItems
        guard let indexPath = visibleItems.last else { return  }
        movieCardCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
