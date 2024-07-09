//
//  CustomMovieDetails.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 02.07.2024.
//

import UIKit

final class CustomMovieDetails: UIView, UICollectionViewDelegate {
    
    // MARK: - Public Properties

    var data: SelectionMovieDetailsCellModel
    
    // MARK: - Layout variables
    
    lazy var detailsText: UILabel = {
        var detailsText = UILabel()
        detailsText.font = .textParagraphRegularFont
        detailsText.textColor = .captionLightText
        detailsText.numberOfLines = 0
        return detailsText
    }()
    
    lazy var swipeView: UIView = {
        var swipeView = UIView()
        swipeView.backgroundColor = .clear
        return swipeView
    }()

    private lazy var mainScroll: UIScrollView = {
        var mainScroll = UIScrollView()
        mainScroll.isScrollEnabled = true
        return mainScroll
    }()

    private lazy var slider: UIImageView = {
        var slider = UIImageView(image: .slider)
        return slider
    }()

    private lazy var detailsLabel: UILabel = {
        var detailsLabel = UILabel()
        detailsLabel.text = "Подробнее о фильме"
        detailsLabel.font = .textLabelFont
        return detailsLabel
    }()

    private lazy var mainRolesLabel: UILabel = {
        var mainRolesLabel = UILabel()
        mainRolesLabel.font = .textLabelFont
        mainRolesLabel.text = "В главных ролях"
        return mainRolesLabel
    }()

    private lazy var mainRolesCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout.createLeftAlignedLayout(itemHeight: 28)
        let mainRolesCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        mainRolesCollectionView.register(
            CustomRolesCollectionCell.self,
            forCellWithReuseIdentifier: CustomRolesCollectionCell.reuseIdentifier
        )
        mainRolesCollectionView.isScrollEnabled = false
        return mainRolesCollectionView
    }()

    private lazy var directorLabel: UILabel = {
        var directorLabel = UILabel()
        directorLabel.font = .textLabelFont
        directorLabel.text = "Режиссёр"
        return directorLabel
    }()

    private lazy var directorCellBackground: UIView = {
       var directorCellBackground = UIView()
        directorCellBackground.backgroundColor = .baseBackground
        directorCellBackground.layer.cornerRadius = 12
        return directorCellBackground
    }()

    private lazy var directorCell: UILabel = {
        var directorCell = UILabel()
        directorCell.font = .textParagraphRegularFont
        directorCell.backgroundColor = .clear
        return directorCell
    }()

    private lazy var ratingLabel: UILabel = {
        var ratingLabel = UILabel()
        ratingLabel.text = "Оценки"
        ratingLabel.font = .textLabelFont
        return ratingLabel
    }()

    private lazy var ratingCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 200, height: 58)
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
        mainRolesCollectionView.dataSource = self
        ratingCollection.dataSource = self
        setupSubviews()
        setupContraints()
        updateModel(model: model)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods

    override func layoutSubviews() {
        super.layoutSubviews()
        mainRolesCollectionView.layoutIfNeeded()
        ratingCollection.layoutIfNeeded()
    }
    
    func setContentSize() {
        let contentRect: CGRect = mainScroll.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        mainScroll.contentSize = CGSize(width: frame.width, height: contentRect.height)
    }

    func collectionsReloadData() {
        mainRolesCollectionView.reloadData()
        ratingCollection.reloadData()
    }

    func updateModel(model: SelectionMovieDetailsCellModel) {
        data = model
        setupWithModel(model: model)
        setContentSize()
        collectionsReloadData()
    }

    func setupWithModel(model: SelectionMovieDetailsCellModel) {
        detailsText.text = model.descreption
        directorCell.text = model.directors[0]
        mainRolesCollectionView.reloadData()
        ratingCollection.reloadData()
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

            mainRolesLabel.topAnchor.constraint(equalTo: detailsText.bottomAnchor, constant: 24),
            mainRolesLabel.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 16),
            mainRolesLabel.heightAnchor.constraint(equalToConstant: 24),

            mainRolesCollectionView.topAnchor.constraint(equalTo: mainRolesLabel.bottomAnchor),
            mainRolesCollectionView.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor),
            mainRolesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainRolesCollectionView.heightAnchor.constraint(equalToConstant: 88),

            directorLabel.topAnchor.constraint(equalTo: mainRolesCollectionView.bottomAnchor, constant: 12),
            directorLabel.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 16),
            directorLabel.heightAnchor.constraint(equalToConstant: 24),

            directorCell.topAnchor.constraint(equalTo: directorLabel.bottomAnchor, constant: 12),
            directorCell.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 28),

            directorCellBackground.topAnchor.constraint(equalTo: directorCell.topAnchor, constant: -4),
            directorCellBackground.bottomAnchor.constraint(equalTo: directorCell.bottomAnchor, constant: 4),
            directorCellBackground.leadingAnchor.constraint(equalTo: directorCell.leadingAnchor, constant: -12),
            directorCellBackground.trailingAnchor.constraint(equalTo: directorCell.trailingAnchor, constant: 12),

            ratingLabel.topAnchor.constraint(equalTo: directorCell.bottomAnchor, constant: 24),
            ratingLabel.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 16),
            ratingLabel.heightAnchor.constraint(equalToConstant: 24),

            ratingCollection.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor),
            ratingCollection.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 16),
            ratingCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            ratingCollection.heightAnchor.constraint(equalToConstant: 70)

        ])

    }

    private func setupSubviews() {
        [mainScroll, swipeView, slider].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [
            detailsLabel,
            detailsText,
            mainRolesLabel,
            mainRolesCollectionView,
            directorLabel,
            directorCellBackground,
            directorCell,
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
        if collectionView == self.mainRolesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomRolesCollectionCell.reuseIdentifier,
                for: indexPath
            ) as? CustomRolesCollectionCell else {
                return UICollectionViewCell()
            }
            let mainRole = data.actors[indexPath.row]
            cell.roleLabel.text = mainRole
            return cell
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
        if collectionView == self.mainRolesCollectionView {
            return data.actors.count
        } else {
            //TODO: Сделать разные возврат в зависимости от колличества данных
            return 2
        }
    }
}
