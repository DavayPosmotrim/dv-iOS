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

    // MARK: - Lazy Properties

    private lazy var collectionView: UICollectionView = {
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
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopScrolling()
    }

    // MARK: - Handlers

    @objc private func handleScroll() {
        let currentOffset = collectionView.contentOffset
        let nextOffset = CGPoint(x: currentOffset.x + 1, y: currentOffset.y)

        if nextOffset.x <= collectionView.contentSize.width - collectionView.bounds.width {
            collectionView.setContentOffset(nextOffset, animated: false)
        } else {
            let firstIndexPath = IndexPath(row: 0, section: 0)
            collectionView.scrollToItem(
                at: firstIndexPath,
                at: .centeredHorizontally,
                animated: false
            )
        }
    }

    // MARK: - Private methods

    private func setupSubviews() {
        [collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }

    private func startScrolling() {
        scrollTimer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(handleScroll),
            userInfo: nil,
            repeats: true
        )
    }

    private func stopScrolling() {
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
        return presenter.moviesCount
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RouletteCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? RouletteCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configureCell(with: presenter.getMoviesAtIndex(index: indexPath.row))

        return cell
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

extension RouletteViewController: RouletteViewProtocol {}
