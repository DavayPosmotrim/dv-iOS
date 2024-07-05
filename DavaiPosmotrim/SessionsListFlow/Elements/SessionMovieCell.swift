//
//  SessionMovieCell.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 22.06.2024.
//

import UIKit

// TODO: - Wait Eldar's cell

final class SessionMovieCell: UICollectionViewCell {

    // MARK: - Type properties
    static let cellID = "SessionMovieCell"

    // MARK: - Public properties
    private (set) var viewModel = SessionMovieModel(name: "", imageName: nil)

    // MARK: - Private properties
    private enum Size {
        static let placeholderWidth: CGFloat = 80
        static let placeholderHeight: CGFloat = 90
        static let spacing: CGFloat = 8
    }
    private let placeholderImage = UIImage.noImagePlug
    private var hasImage: Bool = true {
        didSet {
            movieImageView.isHidden = hasImage ? false : true
            placeholderImageView.isHidden = hasImage ? true : false
            movieNameLabel.textColor = .headingText
        }
    }

    // MARK: - View properties
    private lazy var movieNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.font = .textParagraphRegularFont
        label.numberOfLines = 2
        label.sizeToFit()
       return label
    }()
    private lazy var movieImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = placeholderImage
        return imageView
    }()
    private lazy var placeholderImageView = UIImageView(image: placeholderImage)

    // MARK: - Public Methods
    func configureCell(for viewModel: SessionMovieModel) {
        self.viewModel = viewModel
        hasImage = viewModel.imageName != nil
        movieNameLabel.text = viewModel.name
        setupUI()
        contentView.layoutIfNeeded()
    }
}

// MARK: - Private methods
private extension SessionMovieCell {

    func setupUI() {
        backgroundColor = .baseBackground
        layer.cornerRadius = .radiusMedium
        layer.masksToBounds = true

        [
            placeholderImageView,
            movieImageView,
            movieNameLabel
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            movieNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Size.spacing),
            movieNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Size.spacing),
            movieNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Size.spacing),
            movieNameLabel.heightAnchor.constraint(equalToConstant: .textParagraphHeightTwoLines),

            movieImageView.topAnchor.constraint(equalTo: bottomAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            placeholderImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeholderImageView.heightAnchor.constraint(equalToConstant: Size.placeholderWidth),
            placeholderImageView.widthAnchor.constraint(equalToConstant: Size.placeholderHeight)
        ])
    }
}
