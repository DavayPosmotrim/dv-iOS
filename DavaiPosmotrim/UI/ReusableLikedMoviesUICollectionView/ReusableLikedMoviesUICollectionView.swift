//
//  ReusableLikedMoviesUICollectionView.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 24.06.2024.
//

import UIKit

final class ReusableLikedMoviesUICollectionView: UIView {

    // MARK: - Stored properties

    private let params = CellGeometricParams(
        cellCount: 2,
        cellHeight: 240,
        cellSpacing: 16,
        lineSpacing: 16
    )

    // MARK: - Lazy properties

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.register(
            ReusableLikedMoviesCell.self,
            forCellWithReuseIdentifier: ReusableLikedMoviesCell.reuseIdentifier
        )
        collectionView.contentInset = UIEdgeInsets(top: 56, left: 16, bottom: 16, right: 16)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()

    private lazy var paddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return view
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func setupCollectionView(with controller: UIViewController) {
        collectionView.dataSource = controller as? UICollectionViewDataSource
    }

    // MARK: - Private methods

    private func setupView() {
        [paddingView, collectionView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            paddingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            paddingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            paddingView.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 40),
            paddingView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

    // MARK: - UICollectionViewDelegateFlowLayout

extension ReusableLikedMoviesUICollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionInset: CGFloat = 16
        let availableWidth = collectionView.frame.width - collectionInset * 2 - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)

        return CGSize(width: cellWidth, height: params.cellHeight)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return params.lineSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return params.cellSpacing
    }
}

    // MARK: - UIScrollViewDelegate

extension ReusableLikedMoviesUICollectionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        paddingView.transform = CGAffineTransform(translationX: 0, y: min(-offset.y - scrollView.contentInset.top, 0))
    }
}
