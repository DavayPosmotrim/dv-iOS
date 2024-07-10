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

    private lazy var detailsText: UILabel = {
        var detailsText = UILabel()
        detailsText.font = .textParagraphRegularFont
        detailsText.textColor = .captionLightText
        detailsText.numberOfLines = 0
        return detailsText
    }()

    private lazy var swipeView: UIView = {
        var swipeView = UIView()
        swipeView.backgroundColor = .clear
        return swipeView
    }()

    private lazy var mainScroll: UIScrollView = {
        var mainScroll = UIScrollView()
        mainScroll.isScrollEnabled = true
        return mainScroll
    }()

    private lazy var slider: UIImageView = UIImageView(image: .slider)

    private lazy var detailsLabel: UILabel = {
        var detailsLabel = UILabel()
        detailsLabel.text = Resources.MovieDetails.movieDetailsText
        detailsLabel.font = .textLabelFont
        return detailsLabel
    }()

    private lazy var actorsAndDirectirsCollectionView: UICollectionView = {
        let layout = LearAllignedLayout()
        layout.estimatedItemSize = CGSize(width: 140, height: 28)
        layout.headerReferenceSize = CGSize(width: frame.size.width, height: 36)
        layout.footerReferenceSize = CGSize(width: frame.size.width, height: 24)
        let actorsAndDirectirsCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        actorsAndDirectirsCollectionView.register(
            CustomRolesCollectionCell.self,
            forCellWithReuseIdentifier: CustomRolesCollectionCell.reuseIdentifier
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
        actorsAndDirectirsCollectionView.isScrollEnabled = false
        return actorsAndDirectirsCollectionView
    }()

    private lazy var ratingLabel: UILabel = {
        var ratingLabel = UILabel()
        ratingLabel.text = Resources.MovieDetails.votesText
        ratingLabel.font = .textLabelFont
        return ratingLabel
    }()

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

    // MARK: - Initializers

    init(model: SelectionMovieDetailsCellModel) {
        data = model
        super.init(frame: .zero)
        layer.cornerRadius = 24
        backgroundColor = .whiteBackground
        actorsAndDirectirsCollectionView.dataSource = self
        ratingCollection.dataSource = self
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
        ratingCollection.layoutIfNeeded()
    }

    // MARK: - Public Methods

    func setContentSize() {
        let contentRect: CGRect = mainScroll.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        mainScroll.contentSize = CGSize(width: frame.width, height: contentRect.height)
    }

    func collectionsReloadData() {
        actorsAndDirectirsCollectionView.reloadData()
        ratingCollection.reloadData()
    }

    func updateModel(model: SelectionMovieDetailsCellModel) {
        data = model
        setupWithModel(model: model)
        setContentSize()
        collectionsReloadData()
    }

    func setupWithModel(model: SelectionMovieDetailsCellModel) {
        detailsText.text = model.description
        collectionsReloadData()
    }

    func changeFontColor(_ direction: UISwipeGestureRecognizer.Direction) {
        if direction == .up {
            detailsText.textColor = .baseText
        } else {
            detailsText.textColor = .captionLightText
        }
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

            mainScroll.topAnchor.constraint(equalTo: slider.bottomAnchor),
            mainScroll.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainScroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainScroll.trailingAnchor.constraint(equalTo: trailingAnchor),

            detailsLabel.topAnchor.constraint(equalTo: mainScroll.topAnchor, constant: 12),
            detailsLabel.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 16),
            detailsLabel.heightAnchor.constraint(equalToConstant: 24),

            swipeView.topAnchor.constraint(equalTo: topAnchor),
            swipeView.bottomAnchor.constraint(equalTo: detailsLabel.topAnchor),
            swipeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            swipeView.trailingAnchor.constraint(equalTo: trailingAnchor),

            detailsText.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 12),
            detailsText.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 16),
            detailsText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            actorsAndDirectirsCollectionView.topAnchor.constraint(equalTo: detailsText.bottomAnchor, constant: 24),
            actorsAndDirectirsCollectionView.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 16),
            actorsAndDirectirsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            actorsAndDirectirsCollectionView.heightAnchor.constraint(equalToConstant: 212),

            ratingLabel.topAnchor.constraint(equalTo: actorsAndDirectirsCollectionView.bottomAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 16),
            ratingLabel.heightAnchor.constraint(equalToConstant: 24),

            ratingCollection.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor),
            ratingCollection.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor),
            ratingCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            ratingCollection.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func setupSubviews() {
        [
            mainScroll,
            swipeView,
            slider
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [
            detailsLabel,
            detailsText,
            actorsAndDirectirsCollectionView,
            ratingLabel,
            ratingCollection
        ].forEach {
            mainScroll.addSubview($0)
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
        if collectionView == self.actorsAndDirectirsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomRolesCollectionCell.reuseIdentifier,
                for: indexPath
            ) as? CustomRolesCollectionCell else {
                return UICollectionViewCell()
            }
            if indexPath.section == 0 {
                let mainRole = data.actors[indexPath.row]
                cell.configure(name: mainRole)
                return cell
            } else {
                let mainRole = data.directors[indexPath.row]
                cell.configure(name: mainRole)
                return cell
            }
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomRatingCollectionCell.reuseIdentifier,
                for: indexPath
            ) as? CustomRatingCollectionCell else {
                return UICollectionViewCell()
            }
            if indexPath.row == 0 {
                cell.configureIMDBRatingCell(ratingNumber: data.ratingImdb, votes: data.votesImdb)
            } else {
                cell.configureKinopoiskRatingCell(ratingNumber: data.ratingKp, votes: data.votesKp)
            }
            return cell
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == self.actorsAndDirectirsCollectionView {
            if section == 0 {
                return data.actors.count
            } else {
                return data.directors.count
            }
        } else {
            // TODO: Сделать разные возврат в зависимости от колличества данных
            return 2
        }
    }
}

extension CustomMovieDetails: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.actorsAndDirectirsCollectionView {
            return 2
        } else {
            return 1
        }
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
            if indexPath.section == 0 {
                header.configure(text: Resources.MovieDetails.mainRolesText)
            } else {
                header.configure(text: Resources.MovieDetails.directorText)
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
