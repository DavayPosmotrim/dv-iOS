//
//  CustomRatingParentCollectionCell.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 11.07.2024.
//

import UIKit

final class CustomRatingParentCollectionCell: UICollectionViewCell {

    private var ratingKp: Float = 0
    private var ratingImdb: Float = 0
    private var votesKp: Int = 0
    private var votesImdb: Int = 0

    // MARK: - Stored Properties

    static let reuseIdentifier = "CustomRatingParentCollectionCell"

    // MARK: - Layout variables

    private lazy var ratingCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 200, height: 58)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let ratingCollection = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        ratingCollection.register(
            CustomRatingCollectionCell.self,
            forCellWithReuseIdentifier: CustomRatingCollectionCell.reuseIdentifier
        )
        ratingCollection.showsHorizontalScrollIndicator = false
        ratingCollection.backgroundColor = .clear
        ratingCollection.isScrollEnabled = true

        return ratingCollection
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        ratingCollection.dataSource = self
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(
        ratingKp: Float,
        ratingImdb: Float,
        votesKp: Int,
        votesImdb: Int
    ) {
        self.ratingKp = ratingKp
        self.ratingImdb = ratingImdb
        self.votesKp = votesKp
        self.votesImdb = votesImdb
        ratingCollection.reloadData()
    }

    // MARK: - Private Methods

    private func setupCell() {
        ratingCollection.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingCollection)

        NSLayoutConstraint.activate([
            ratingCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingCollection.topAnchor.constraint(equalTo: contentView.topAnchor),
            ratingCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratingCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension CustomRatingParentCollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomRatingCollectionCell.reuseIdentifier,
            for: indexPath
        ) as? CustomRatingCollectionCell else {
            return UICollectionViewCell()
        }
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .right, animated: true)
        if indexPath.row == 0 {
            cell.configureIMDBRatingCell(ratingNumber: ratingImdb, votes: votesImdb)
        } else {
            cell.configureKinopoiskRatingCell(ratingNumber: ratingKp, votes: votesKp)
        }
        return cell
    }
}
