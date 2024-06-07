//
//  ReusableOnboardingCollectionViewCell.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 06.06.2024.
//

import UIKit

final class ReusableOnboardingCollectionViewCell: UICollectionViewCell {

    // MARK: - Stored properties

    static let reuseIdentifier = "ReusableOnboardingCollectionViewCell"
    private var cellConstraints = [NSLayoutConstraint]()

    // MARK: - Lazy properties

    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var cellLowerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .textDescriptionRegularFont
        label.textColor = .baseText
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()

    private lazy var cellUpperLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .textTitleFont
        label.textColor = .headingText
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
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

    func configureCell(with page: PageModel, event: OnboardingEvent, indexPath: IndexPath) {
        cellImageView.image = page.image
        cellLowerLabel.text = page.lowerText
        cellUpperLabel.attributedText = adjustCellUpperLabel(
            with: page.upperText,
            and: page.upperColoredText
        )
        setupAdditionalConstraints(using: indexPath, and: event)
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
        cellConstraints = [
            cellUpperLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            cellUpperLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            cellUpperLabel.topAnchor.constraint(equalTo: contentView.topAnchor),

            cellImageView.topAnchor.constraint(equalTo: cellUpperLabel.bottomAnchor, constant: 32),
            cellImageView.bottomAnchor.constraint(equalTo: cellLowerLabel.topAnchor, constant: -32),
            cellImageView.leadingAnchor.constraint(equalTo: cellUpperLabel.leadingAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: cellUpperLabel.trailingAnchor),

            cellLowerLabel.leadingAnchor.constraint(equalTo: cellUpperLabel.leadingAnchor),
            cellLowerLabel.trailingAnchor.constraint(equalTo: cellUpperLabel.trailingAnchor),
            cellLowerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(cellConstraints)
    }

    private func setupAdditionalConstraints(using indexPath: IndexPath, and event: OnboardingEvent) {
        if event == .firstOnboarding {
            cellConstraints += [
               cellUpperLabel.heightAnchor.constraint(equalToConstant: 132),
               cellLowerLabel.heightAnchor.constraint(equalToConstant: 40)
            ]
        } else {
            let upperLabelHeight: CGFloat = indexPath.row == 1 ? 132 : 88
            let lowerLabelHeight: CGFloat = indexPath.row == 0 ? 60 : 40
             cellConstraints += [
                cellUpperLabel.heightAnchor.constraint(equalToConstant: upperLabelHeight),
                cellLowerLabel.heightAnchor.constraint(equalToConstant: lowerLabelHeight)
             ]
        }
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
