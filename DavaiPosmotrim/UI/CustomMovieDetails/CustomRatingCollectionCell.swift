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
        rating.textColor = .headingText
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
        votesAmount.textColor = .baseText
        votesAmount.font = .textCaptionRegularFont
        return votesAmount
    }()

    private lazy var name: UILabel = {
        var name = UILabel()
        name.textColor = .headingText
        name.font = .textCaptionRegularFont
        return name
    }()

    // MARK: - Initializers

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
        votesAmount.text = formatInt(votes) + (Resources.MovieDetails.howManyVotesText)
        name.text = Resources.MovieDetails.kinoPoiskRatingText
        configureBackground(ratingNumber)
    }

    func configureIMDBRatingCell(ratingNumber: Float, votes: Int) {
        rating.text = String(ratingNumber)
        votesAmount.text = formatInt(votes) + (Resources.MovieDetails.howManyVotesText)
        name.text = Resources.MovieDetails.iMDBRatingText
        configureBackground(ratingNumber)
    }

    // MARK: - Private Methods

    private func formatInt(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = " "
        guard let newNumber = numberFormatter.string(for: number) else { return String(number) }
        return newNumber
    }

    private func configureBackground(_ number: Float) {
        if number >= 7.0 {
            contentView.backgroundColor = .baseSecondaryAccent
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
