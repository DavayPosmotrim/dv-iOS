//
//  ReusableLikedMoviesCell.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 24.06.2024.
//

struct ReusableLikedMoviesCellModel {
    let id = UUID()
    let title: String
    let imageName: String?
}

import UIKit

final class ReusableLikedMoviesCell: UICollectionViewCell {

    // MARK: - Stored properties

    static let reuseIdentifier = "ReusableLikedMoviesCell"
    private var cellId: UUID?

    private var standardImageViewConstraints = [NSLayoutConstraint]()
    private var noImagePlugConstraints = [NSLayoutConstraint]()

    // MARK: - Lazy properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .textParagraphRegularFont
        label.textAlignment = .natural
        label.numberOfLines = 3

        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

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

        layoutIfNeeded()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer else { return }
        gradientLayer.frame = gradientView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        NSLayoutConstraint.deactivate(noImagePlugConstraints)
        NSLayoutConstraint.deactivate(standardImageViewConstraints)
        gradientView.isHidden = false
        titleLabel.textColor = .whiteText
        imageView.image = nil
        cellId = nil
    }

    // MARK: - Public methods

    func configureCell(with model: ReusableLikedMoviesCellModel) {
        titleLabel.text = model.title
        imageView.image = UIImage(named: model.imageName ?? "noImagePlug")
        cellId = model.id

        updateImageViewConstraints()
        updateGradientHeight()
        setNeedsLayout()
    }
}

    // MARK: - Private methods

private extension ReusableLikedMoviesCell {

    func setupCellView() {
        backgroundColor = .baseBackground
        layer.cornerRadius = 16
        clipsToBounds = true

        [imageView, gradientView, titleLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

        standardImageViewConstraints = [
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        noImagePlugConstraints = [
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
    }

    func updateImageViewConstraints() {
        if imageView.image == UIImage.noImagePlug {
            NSLayoutConstraint.activate(noImagePlugConstraints)
            titleLabel.textColor = .baseText
            gradientView.isHidden = true
        } else {
            NSLayoutConstraint.activate(standardImageViewConstraints)
        }
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
