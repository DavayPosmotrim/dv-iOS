//
//  CustomMovieDetails.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 02.07.2024.
//

import UIKit

final class CustomMovieDetails: UIView {
    
    private lazy var mainScroll: UIScrollView = {
        var mainScroll = UIScrollView()
        return mainScroll
    }()
    
    private lazy var detailsLabel: UILabel = {
        var detailsLabel = UILabel()
        detailsLabel.text = "Подробнее о фильме"
        detailsLabel.font = .textLabelFont
        return detailsLabel
    }()
    
    private lazy var detailsText: UILabel = {
        var detailsText = UILabel()
        detailsText.font = .textParagraphRegularFont
        detailsText.numberOfLines = 0
        return detailsText
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
        mainRolesCollectionView.backgroundColor = .clear
        mainRolesCollectionView.isScrollEnabled = false
        return mainRolesCollectionView
    }()
    
    private lazy var directorLabel: UILabel = {
        var directorLabel = UILabel()
        directorLabel.font = .textLabelFont
        directorLabel.text = "Режиссёр"
        return directorLabel
    }()
    
    private lazy var directorCell: UILabel = {
        var directorCell = UILabel()
        directorCell.font = .textParagraphRegularFont
        return directorCell
    }()
    
    private lazy var ratingLabel: UILabel = {
        var ratingLabel = UILabel()
        ratingLabel.text = "Оценки"
        ratingLabel.font = .textLabelFont
        return ratingLabel
    }()
    
    private lazy var ratingCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout.createLeftAlignedLayout(itemHeight: 58)
        let ratingCollection = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        ratingCollection.register(
            CustomRatingCollectionCell.self,
            forCellWithReuseIdentifier: CustomRatingCollectionCell.reuseIdentifier
        )
        ratingCollection.backgroundColor = .clear
        ratingCollection.isScrollEnabled = true
        
        return ratingCollection
    }()
    
    init(model: SelectionMovieDetailsCellModel) {
        super.init(frame: .zero)
        setupWithModel(model: model)
        setupSubviews()
        setupContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContraints() {
        mainScroll.contentSize.width = self.frame.width

        NSLayoutConstraint.activate([
            
            mainScroll.topAnchor.constraint(equalTo: topAnchor),
            mainScroll.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainScroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainScroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            detailsLabel.topAnchor.constraint(equalTo: mainScroll.topAnchor, constant: 30),
            detailsLabel.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 16),
            detailsLabel.heightAnchor.constraint(equalToConstant: 24),
            
            detailsText.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 12),
            detailsText.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 16),
            detailsText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            mainRolesLabel.topAnchor.constraint(equalTo: detailsText.bottomAnchor, constant: 24),
            mainRolesLabel.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 16),
            mainRolesLabel.heightAnchor.constraint(equalToConstant: 24),
            
            mainRolesCollectionView.topAnchor.constraint(equalTo: mainRolesLabel.bottomAnchor, constant: 12),
            mainRolesCollectionView.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 16),
            
            directorLabel.topAnchor.constraint(equalTo: mainRolesCollectionView.bottomAnchor, constant: 24),
            directorLabel.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 16),
            directorLabel.heightAnchor.constraint(equalToConstant: 24),
            
            directorCell.topAnchor.constraint(equalTo: directorLabel.bottomAnchor, constant: 12),
            directorCell.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 16),
            
            ratingLabel.topAnchor.constraint(equalTo: directorCell.bottomAnchor, constant: 24),
            ratingLabel.leadingAnchor.constraint(equalTo: mainScroll.leadingAnchor, constant: 16),
            ratingLabel.heightAnchor.constraint(equalToConstant: 24)
            
        ])
        
    }
    
    func setupSubviews() {
        addSubview(mainScroll)
        mainScroll.translatesAutoresizingMaskIntoConstraints = false
        [
            detailsLabel,
            detailsText,
            mainRolesLabel,
            mainRolesCollectionView,
            directorLabel,
            directorCell,
            ratingLabel
        ].forEach {
            mainScroll.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupWithModel(model: SelectionMovieDetailsCellModel) {
        detailsText.text = model.descreption
        directorCell.text = model.derictor
        mainRolesCollectionView.reloadData()
        ratingCollection.reloadData()
    }
}
