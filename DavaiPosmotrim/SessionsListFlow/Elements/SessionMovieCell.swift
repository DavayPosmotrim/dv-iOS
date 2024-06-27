//
//  SessionMovieCell.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 22.06.2024.
//

import UIKit

final class SessionMovieCell: UICollectionViewCell {

    // MARK: - Type properties
    static let cellID = "SessionMovieCell"

    // MARK: - Public properties
    var viewModel = SessionMovieModel(name: "", imageName: nil)

    // MARK: - Private properties
    private enum Size {
        static let placeholderWidth: CGFloat = 80
        static let placeholderHeight: CGFloat = 90
        static let spacing: CGFloat = 8
    }
    private let placeholderImage = UIImage(resource: .noImagePlug)
    private var hasMovieImage: Bool {
        movieImageView.image != placeholderImage
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
    private lazy var movieImageView = UIImageView()
    private lazy var placeholderImageView = UIImageView(image: placeholderImage)

    // MARK: - Public Methods
    func configureCell(for viewModel: SessionMovieModel) {
        self.viewModel = viewModel
        setupValues()
        setupUI()
        contentView.layoutIfNeeded()
    }
}

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

    func setupValues() {
        movieNameLabel.text = viewModel.name
        movieNameLabel.textColor = .headingText
//        movieNameLabel.textColor = hasMovieImage ? .lightText : .headingText
        movieImageView.contentMode = .scaleAspectFill
        movieImageView.clipsToBounds = true

        //        let imageName = viewModel.imageName ?? ""
        //        movieImageView.image = imageName == "" ? UIImage() : UIImage(named: imageName)
        movieImageView.image = placeholderImage
        hidePlaceholder()
        //        if let imageName = viewModel.imageName {
        //            movieImageView.image = UIImage(named: imageName)
        //            hidePlaceholder(true)
        //        } else {
        //            hidePlaceholder(false)
        //        }

    }

    func hidePlaceholder() {
        movieImageView.isHidden = !hasMovieImage
        placeholderImageView.isHidden = hasMovieImage
    }
    
}
