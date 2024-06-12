//
//  SessionsListMovieCell.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 07.06.2024.
//

import UIKit

final class SessionsListMovieCell: UIView {

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.textColor = .headingText
        label.font = .textLabelFont
        return label
    }()
    private lazy var matchCountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .basePrimaryAccent
        label.layer.cornerRadius = .radiusBase
        label.textAlignment = .center
        label.textColor = .whiteText
        label.font = .textParagraphRegularFont
        return label
    }()
    private lazy var usersListLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .headingText
        label.font = .textLabelFont
        return label
    }()
    private lazy var imageView = UIImage()

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupSubviewsValue()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SessionsListMovieCell {
    func setupUI() { 
        self.backgroundColor = .whiteBackground
        self.layer.cornerRadius = .radiusLarge

        [dateLabel, matchCountLabel, usersListLabel, imageView].forEach { view in
            guard let view = view as? UIView else { return }
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        let safeArea = self.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
//            placeholderStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
//            placeholderStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
//
//            placeholderImageView.topAnchor.constraint(equalTo: placeholderStackView.topAnchor),
//            placeholderImageView.heightAnchor.constraint(equalToConstant: .placeholderSize),
//            placeholderImageView.widthAnchor.constraint(equalToConstant: .placeholderSize),
//
//            placeholderTitleLabel.heightAnchor.constraint(equalToConstant: .textHeadingHeight),
//
//            placeholderDescriptionLabel.heightAnchor.constraint(equalToConstant: .textParagraphHeightTwoLines)
        ])
    }

    func setupSubviewsValue() {
        dateLabel.text = "22 September 2023"
        matchCountLabel.text = "Matches: 22"
        usersListLabel.text = "Artem (you), Anna, Nikita, Ruslan"
    }
}
