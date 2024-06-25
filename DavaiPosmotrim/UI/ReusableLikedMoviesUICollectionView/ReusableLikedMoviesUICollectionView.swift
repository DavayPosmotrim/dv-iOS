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
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView.backgroundColor = .whiteBackground
        collectionView.layer.cornerRadius = 24
        collectionView.layer.masksToBounds = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        return collectionView
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
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
