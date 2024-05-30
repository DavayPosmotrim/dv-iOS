//
//  OnboardingCollectionViewCell.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 24.04.2024.
//

import UIKit

final class OnboardingCollectionViewCell: UICollectionViewCell {

    // MARK: - Stored properties

    static let reuseIdentifier = "OnboardingCollectionViewCell"

    // MARK: - Computed properties

    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
        contentView.backgroundColor = .clear

        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func configureCell(with page: PageModel) {
        cellImageView.image = page.image
        cellLowerLabel.text = page.lowerText
        cellUpperLabel.attributedText = adjustCellUpperLabel(
            with: page.upperText,
            and: page.upperColoredText
        )
    }

    // MARK: - Private methods

    private func setupSubviews() {
        [
            cellUpperLabel,
            cellImageView,
            cellLowerLabel
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellUpperLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            cellUpperLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            cellUpperLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellUpperLabel.heightAnchor.constraint(equalToConstant: 132),

            cellImageView.topAnchor.constraint(equalTo: cellUpperLabel.bottomAnchor, constant: 32),
            cellImageView.bottomAnchor.constraint(equalTo: cellLowerLabel.topAnchor, constant: -32),
            cellImageView.leadingAnchor.constraint(equalTo: cellUpperLabel.leadingAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: cellUpperLabel.trailingAnchor),

            cellLowerLabel.leadingAnchor.constraint(equalTo: cellUpperLabel.leadingAnchor),
            cellLowerLabel.trailingAnchor.constraint(equalTo: cellUpperLabel.trailingAnchor),
            cellLowerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellLowerLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
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
