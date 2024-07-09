//
//  RatingCollectionCell.swift
//  DavaiPosmotrim
//
//  Created by Maksim Zimens on 02.07.2024.
//

import UIKit

final class CustomRatingCollectionCell: UICollectionViewCell {
    
    // MARK: - Stored Properties

    static let reuseIdentifier = "CustomRatingCollectionCell"
    
    // MARK: - Layout variables

    private lazy var rating: UILabel = {
        var rating = UILabel()
        rating.font = .textHeadingFont
        return rating
    }()

    private lazy var stack: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
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
    
    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 12
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods

    func configureKinopoiskRatingCell(ratingNumber: Float, votes: Int) {
        rating.text = String(ratingNumber)
        votesAmount.text = "\(String(votes)) оценок"
        name.text = "Рейтинг Кинопоиска"
        configureBackground(number: ratingNumber)
    }

    func configureIMDBRatingCell(ratingNumber: Float, votes: Int) {
        rating.text = String(ratingNumber)
        votesAmount.text = "\(String(votes)) оценок"
        name.text = "Рейтинг IMDb"
        configureBackground(number: ratingNumber)
    }
    
    // MARK: - Private Methods

    private func configureBackground(number: Float) {
        if number >= 7.0 {
            contentView.backgroundColor = .lightSecondaryAccent
        } else if number >= 5.0 {
            contentView.backgroundColor = .attentionAdditional
        } else {
            contentView.backgroundColor = .errorAdditional
        }
    }

    private func setupSubviews() {
        [name, votesAmount].forEach {
            stack.addArrangedSubview($0)
        }
        [rating, stack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            rating.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rating.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            rating.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),

            stack.leadingAnchor.constraint(equalTo: rating.trailingAnchor, constant: 16),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
