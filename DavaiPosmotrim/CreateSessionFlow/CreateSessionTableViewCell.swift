//
//  CreateSessionTableViewCell.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 07.05.24.
//

import UIKit
import Kingfisher

protocol CreateSessionTableViewCellDelegate: AnyObject {
    func tableViewCellTitleAdded(id: UUID?)
    func tableViewCellTitleRemoved(id: UUID?)
}

final class CreateSessionTableViewCell: UITableViewCell {

    // MARK: - Properties

    var isSelectedTableViewCell: Bool = false {
        didSet {
            updateCellAppearance(isSelectedTableViewCell)
        }
    }
    private var modelId: UUID?
    private let indicatorImageName = "doneFilledIcon"

    // MARK: - Stored Properties

    static let reuseIdentifier = "CreateSessionTableViewCell"
    weak var delegate: CreateSessionTableViewCellDelegate?

    // MARK: - Layout variables

    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.whiteBackground.cgColor
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteText
        label.font = .textParagraphRegularFont
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        let templateImage = UIImage(named: indicatorImageName)?.withRenderingMode(.alwaysTemplate)
        imageView.image = templateImage
        imageView.tintColor = .baseSecondaryAccent
        imageView.isHidden = true
        return imageView
    }()

    private lazy var linearGradientView: UIView = {
        let view = UIView()
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        let startColor: UIColor = .black.withAlphaComponent(.zero)
        let endColor: UIColor = .black
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        return view
    }()

    // MARK: - Public Methods

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let gradientLayer = linearGradientView.layer.sublayers?.first as? CAGradientLayer else { return }
        gradientLayer.frame = linearGradientView.bounds
    }

    func configureCell(model: TableViewCellModel) {
        modelId = model.id
        titleLabel.text = model.title
        let imageURL = URL(string: model.movieImage)
        let memoryOnlyOptions: KingfisherOptionsInfoItem = .cacheMemoryOnly
        movieImageView.kf.indicatorType = .activity
        movieImageView.kf.setImage(with: imageURL, options: [memoryOnlyOptions]) { [weak self] result in
            switch result {
            case .success(let value):
                self?.movieImageView.image = value.image
            case .failure(let error):
                print("Error loading image: \(error)")
            }
            self?.movieImageView.kf.indicatorType = .none
        }
        contentView.backgroundColor = .baseBackground
        setupSubviews()
        setupConstraints()
    }

    // MARK: - Private Methods

    private func setupSubviews() {
        [
            movieImageView,
            linearGradientView,
            titleLabel,
            indicatorImageView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            linearGradientView.leadingAnchor.constraint(equalTo: movieImageView.leadingAnchor, constant: 8),
            linearGradientView.topAnchor.constraint(equalTo: movieImageView.centerYAnchor),
            linearGradientView.trailingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: -8),
            linearGradientView.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -8),

            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -16),

            indicatorImageView.heightAnchor.constraint(equalToConstant: 24),
            indicatorImageView.widthAnchor.constraint(equalToConstant: 24),
            indicatorImageView.trailingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: -16),
            indicatorImageView.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -16)
        ])
    }

    private func updateCellAppearance(_ isSelected: Bool) {
        if isSelected {
            delegate?.tableViewCellTitleAdded(id: modelId)
            indicatorImageView.isHidden = false
            movieImageView.layer.borderColor = UIColor.baseSecondaryAccent.cgColor
        } else {
            delegate?.tableViewCellTitleRemoved(id: modelId)
            indicatorImageView.isHidden = true
            movieImageView.layer.borderColor = UIColor.whiteBackground.cgColor
        }
    }
}
