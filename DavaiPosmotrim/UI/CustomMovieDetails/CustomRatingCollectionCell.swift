//
//  RatingCollectionCell.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 02.07.2024.
//

import UIKit

final class CustomRatingCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CustomRatingCollectionCell"
    
    var cellData: RatingCell?
    
    private lazy var rating: UILabel = {
        var rating = UILabel()
        rating.font = .textHeadingFont
        return rating
    }()
    
    private lazy var votesAmount: UILabel = {
        var votesAmount = UILabel()
        votesAmount.font = .textCaptionRegularFont
        return votesAmount
    }()
    
    private lazy var name: UILabel = {
        var name = UILabel()
        name.font = .textCaptionRegularFont
        return name
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 12
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        [rating, votesAmount, name].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            rating.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rating.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            rating.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            name.leadingAnchor.constraint(equalTo: rating.trailingAnchor, constant: 16),
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            name.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 30),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            votesAmount.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            votesAmount.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 2),
            votesAmount.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
