//
//  ReusableLikedMoviesCell.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 24.06.2024.
//

struct ReusableLikedMoviesCellModel: Identifiable, Equatable, Hashable {
    let id: Int
    let title: String
    let imageName: String?
}

import UIKit

final class ReusableLikedMoviesCell: UICollectionViewCell {

    // MARK: - Stored properties

    static let reuseIdentifier = "ReusableLikedMoviesCell"
    var cellId: Int?

    // MARK: - Lazy properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .textParagraphRegularFont
        label.textAlignment = .natural
        label.numberOfLines = 2

        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.isHidden = true
        imageView.image = UIImage.noImagePlug

        return imageView
    }()

    private lazy var gradientView: UIView = {
        let view = UIView()
        let gradientLayer = CAGradientLayer()
        let startColor: UIColor = .black.withAlphaComponent(.zero)
        let endColor: UIColor = .black
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)

        return view
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCellView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer else { return }
        gradientLayer.frame = gradientView.bounds
    }

    // MARK: - Public methods

    func configureCell(with model: ReusableLikedMoviesCellModel) {
        cellId = model.id
        titleLabel.text = model.title

        guard let encodedImagePath = model.imageName,
              let decodedImagePath = encodedImagePath.removingPercentEncoding
        else {
            toggleVisibility(didLoadImage: false)
            return
        }
        let imagePath = String(decodedImagePath.dropFirst())
        let imageURL = URL(string: imagePath)
        let activityIndicator = RotatingIndicator(image: UIImage.loader, size: 45)
        imageView.kf.indicatorType = .custom(indicator: activityIndicator)
        imageView.kf.setImage(
            with: imageURL,
            options: [
                .transition(.fade(1)),
                .cacheMemoryOnly
            ]) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let value):
                    self.imageView.image = value.image
                    toggleVisibility(didLoadImage: true)
                case .failure:
                    toggleVisibility(didLoadImage: false)
                }
                self.imageView.kf.indicatorType = .none
            }
        updateGradientHeight()
    }
}

    // MARK: - Private methods

private extension ReusableLikedMoviesCell {

    func setupCellView() {
        backgroundColor = .baseBackground
        layer.cornerRadius = 16
        clipsToBounds = true

        [
            imageView,
            placeholderImageView,
            gradientView,
            titleLabel
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            placeholderImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            placeholderImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            placeholderImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            placeholderImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func toggleVisibility(didLoadImage: Bool) {
        imageView.isHidden = !didLoadImage
        placeholderImageView.isHidden = didLoadImage
        gradientView.isHidden = !didLoadImage
        titleLabel.textColor = !didLoadImage ? .baseText : .whiteText
    }

    func updateGradientHeight() {
        let titleHeight = titleLabel.systemLayoutSizeFitting(
            CGSize(width: contentView.frame.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        NSLayoutConstraint.activate([gradientView.heightAnchor.constraint(equalToConstant: 56 + titleHeight)])
        contentView.layoutIfNeeded()
    }
}
