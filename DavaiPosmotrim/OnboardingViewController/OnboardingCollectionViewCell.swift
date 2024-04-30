//
//  OnboardingCollectionViewCell.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 24.04.2024.
//

import UIKit

final class OnboardingCollectionViewCell: UICollectionViewCell {

    // MARK: - Stored proprties

    static let reuseIdentifier = "OnboardingCollectionViewCell"
    private var cellConstraints = [NSLayoutConstraint]()

    // MARK: - Computed properties

    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var cellLowerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = .textDescriptionRegularFont
        label.textColor = .baseText
        return label
    }()

    private lazy var cellUpperLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.textAlignment = .left
        label.font = .textTitleFont
        label.textColor = .headingText
        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear

        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func configureCell(with page: PageModel, and indexPath: IndexPath) {
        cellImageView.image = page.image
        cellLowerLabel.text = page.lowerText
        cellUpperLabel.attributedText = adjustCellUpperLabel(with: page.upperText, and: page.upperColoredText)

        setupImageViewConstraints(using: indexPath)
    }

    // MARK: - Private methods

    private func setupSubviews() {
        [cellImageView,
        cellLowerLabel,
        cellUpperLabel
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupConstraints() {
        cellConstraints = [
            cellImageView.topAnchor.constraint(equalTo: cellUpperLabel.bottomAnchor, constant: 33),
            cellImageView.heightAnchor.constraint(equalToConstant: 275),

            cellLowerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            cellLowerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            cellLowerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            cellUpperLabel.leadingAnchor.constraint(equalTo: cellLowerLabel.leadingAnchor),
            cellUpperLabel.trailingAnchor.constraint(equalTo: cellLowerLabel.trailingAnchor),
            cellUpperLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ]
        NSLayoutConstraint.activate(cellConstraints)
    }

    private func setupImageViewConstraints(using indexPath: IndexPath) {
        cellConstraints += [
            cellImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: indexPath.row == 1 ? 0 : 32
            ),
            cellImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: indexPath.row == 1 ? 0 : -32
            )
        ]
        NSLayoutConstraint.activate(cellConstraints)
    }

    private func adjustCellUpperLabel(with text: String, and colorText: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 44

        let rangeOfColoredString = (text as NSString).range(of: colorText)

        let attrString = NSMutableAttributedString(string: text)
        attrString.setAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.basePrimaryAccent], range: rangeOfColoredString
        )
        attrString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: .zero, length: attrString.length)
        )

        return attrString
    }

}
