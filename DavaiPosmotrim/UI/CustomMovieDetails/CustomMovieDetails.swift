//
//  CustomMovieDetails.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 02.07.2024.
//

import UIKit

final class CustomMovieDetails: UIView {

    // MARK: - Public Properties

    var data: SelectionMovieDetailsCellModel

    // MARK: - Layout variables

    private lazy var swipeView: UIView = {
        var swipeView = UIView()
        swipeView.backgroundColor = .clear
        return swipeView
    }()

    private lazy var slider: UIImageView = UIImageView(image: .slider)

    private lazy var actorsAndDirectirsCollectionView: UICollectionView = {
        let layout = LeftAllignedLayout()
        layout.headerReferenceSize = CGSize(width: frame.size.width, height: 36)
        layout.footerReferenceSize = CGSize(width: frame.size.width, height: 24)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let actorsAndDirectirsCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        actorsAndDirectirsCollectionView.register(
            CustomRolesCollectionCell.self,
            forCellWithReuseIdentifier: CustomRolesCollectionCell.reuseIdentifier
        )
        actorsAndDirectirsCollectionView.register(
            CustomMovieDescriptionCollectionCell.self,
            forCellWithReuseIdentifier: CustomMovieDescriptionCollectionCell.reuseIdentifier
        )
        actorsAndDirectirsCollectionView.register(
            CustomRatingParentCollectionCell.self,
            forCellWithReuseIdentifier: CustomRatingParentCollectionCell.reuseIdentifier
        )
        actorsAndDirectirsCollectionView.register(
            CustomMovieDetailsCollectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CustomMovieDetailsCollectionHeader.identifier
        )
        actorsAndDirectirsCollectionView.register(
            CustomMovieDetailsCollectionFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: CustomMovieDetailsCollectionFooter.identifier
        )
        actorsAndDirectirsCollectionView.showsVerticalScrollIndicator = false
        actorsAndDirectirsCollectionView.isScrollEnabled = true
        return actorsAndDirectirsCollectionView
    }()

    private lazy var ratingLabel: UILabel = {
        var ratingLabel = UILabel()
        ratingLabel.text = Resources.MovieDetails.votesText
        ratingLabel.font = .textLabelFont
        return ratingLabel
    }()

    // MARK: - Initializers

    init(model: SelectionMovieDetailsCellModel) {
        data = model
        super.init(frame: .zero)
        layer.cornerRadius = 24
        backgroundColor = .whiteBackground
        actorsAndDirectirsCollectionView.dataSource = self
        actorsAndDirectirsCollectionView.delegate = self
        setupSubviews()
        setupContraints()
        updateModel(model: model)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        actorsAndDirectirsCollectionView.layoutIfNeeded()
    }

    // MARK: - Public Methods

    func collectionsReloadData() {
        actorsAndDirectirsCollectionView.reloadData()
    }

    func updateModel(model: SelectionMovieDetailsCellModel) {
        data = model
        setupWithModel(model: model)
        collectionsReloadData()
    }

    func setupWithModel(model: SelectionMovieDetailsCellModel) {
        collectionsReloadData()
    }

    func setUpSwipeView(_ swipeGuesture: UISwipeGestureRecognizer) {
        swipeView.addGestureRecognizer(swipeGuesture)
        swipeView.isUserInteractionEnabled = true
    }

    // MARK: - Private Methods

    private func setupContraints() {

        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.widthAnchor.constraint(equalToConstant: 48),
            slider.heightAnchor.constraint(equalToConstant: 6),

            swipeView.topAnchor.constraint(equalTo: topAnchor),
            swipeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            swipeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            swipeView.heightAnchor.constraint(equalToConstant: 30),

            actorsAndDirectirsCollectionView.topAnchor.constraint(equalTo: swipeView.bottomAnchor),
            actorsAndDirectirsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            actorsAndDirectirsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            actorsAndDirectirsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupSubviews() {
        [
            swipeView,
            slider,
            actorsAndDirectirsCollectionView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CustomMovieDetails: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomMovieDescriptionCollectionCell.reuseIdentifier,
                for: indexPath
            ) as? CustomMovieDescriptionCollectionCell else {
                return UICollectionViewCell()
            }
            cell.configure(text: data.description)
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomRolesCollectionCell.reuseIdentifier,
                for: indexPath
            ) as? CustomRolesCollectionCell else {
                return UICollectionViewCell()
            }
            let mainRole = data.actors[indexPath.row]
            cell.configure(name: mainRole)
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomRolesCollectionCell.reuseIdentifier,
                for: indexPath
            ) as? CustomRolesCollectionCell else {
                return UICollectionViewCell()
            }
            let mainRole = data.directors[indexPath.row]
            cell.configure(name: mainRole)
            return cell
        case 3:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomRatingParentCollectionCell.reuseIdentifier,
                for: indexPath
            ) as? CustomRatingParentCollectionCell else {
                return UICollectionViewCell()
            }
            cell.configure(
                ratingKp: data.ratingKp,
                ratingImdb: data.ratingImdb,
                votesKp: data.votesKp,
                votesImdb: data.votesImdb
            )
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return data.actors.count
        case 2:
            return data.directors.count
        case 3:
            return 1
        default:
            return 0
        }
    }
}

extension CustomMovieDetails: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: CustomMovieDetailsCollectionHeader.identifier,
                for: indexPath
            ) as? CustomMovieDetailsCollectionHeader else {
                return UICollectionReusableView()
            }
            let section = indexPath.section
            switch section {
            case 0:
                header.configure(text: Resources.MovieDetails.mainRolesText)
            case 1:
                header.configure(text: Resources.MovieDetails.movieDetailsText)
            case 2:
                header.configure(text: Resources.MovieDetails.directorText)
            case 3:
                header.configure(text: Resources.MovieDetails.votesText)
            default:
                return UICollectionReusableView()
            }
            return header
        } else {
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: CustomMovieDetailsCollectionFooter.identifier,
                for: indexPath
            ) as? CustomMovieDetailsCollectionFooter else {
                return UICollectionReusableView()
            }
            return footer
        }
    }
}

extension CustomMovieDetails: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: frame.width, height: 70)
    }
}
