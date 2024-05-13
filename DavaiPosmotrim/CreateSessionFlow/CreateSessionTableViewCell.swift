//
//  CreateSessionTableViewCell.swift
//  DavaiPosmotrim
//
//  Created by Iurii on 07.05.24.
//

import UIKit

protocol CreateSessionTableViewCellDelegate: AnyObject {
    func tableViewCellTitleAdded(title: String?)
    func tableViewCellTitleRemoved(title: String?)
}

final class CreateSessionTableViewCell: UITableViewCell {

    // MARK: - Stored Properties

    static let reuseIdentifier = "CreateSessionTableViewCell"
    weak var delegate: CreateSessionTableViewCellDelegate?

    // MARK: - Layout variables

    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.whiteBackground.cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteText
        label.font = .textParagraphRegularFont
        return label
    }()

    private lazy var indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        let templateImage = UIImage(named: "doneFilledIcon")?.withRenderingMode(.alwaysTemplate)
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
        return view
    }()

    // MARK: - Public Methods

    override func layoutSubviews() {
        super.layoutSubviews()
        linearGradientView.layer.sublayers?.first?.frame = linearGradientView.bounds
    }

    func configureCell(model: TableViewCellModel) {
        titleLabel.text = model.title
        movieImageView.image = model.movieImage
        contentView.backgroundColor = .baseBackground
        setupSubviews()
        setupConstraints()
    }

    func handleTableCellSelected() {
        indicatorImageView.isHidden = !indicatorImageView.isHidden
        if indicatorImageView.isHidden == false {
            delegate?.tableViewCellTitleAdded(title: titleLabel.text)
            movieImageView.layer.borderColor = UIColor.baseSecondaryAccent.cgColor
        } else {
            delegate?.tableViewCellTitleRemoved(title: titleLabel.text)
            movieImageView.layer.borderColor = UIColor.whiteBackground.cgColor
        }
    }

    // MARK: - Private Methods

    private func setupSubviews() {
        [movieImageView,
         linearGradientView,
         titleLabel,
         indicatorImageView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        gradientLayer(linearGradientView)
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
            titleLabel.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -16),

            indicatorImageView.heightAnchor.constraint(equalToConstant: 24),
            indicatorImageView.widthAnchor.constraint(equalToConstant: 24),
            indicatorImageView.trailingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: -16),
            indicatorImageView.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -16)
        ])
    }

    private func gradientLayer(_ view: UIView) {
        let gradientLayer = CAGradientLayer()
        let startColor: UIColor = UIColor(
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 0.0
        )
        let endColor: UIColor = UIColor(
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 1.0
        )
        let gradientColors: [CGColor] = [startColor.cgColor, endColor.cgColor]
        gradientLayer.colors = gradientColors
        gradientLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: view.bounds.height
        )
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

}
