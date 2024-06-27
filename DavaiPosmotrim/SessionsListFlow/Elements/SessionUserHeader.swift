//
//  SessionUserHeader.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 24.06.2024.
//

import UIKit

final class SessionUserHeader: UICollectionReusableView {

    // MARK: - Type properties
    static let headerID = "SessionUserHeader"

    // MARK: - View properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.textColor = .headingText
        label.font = .textHeadingFont
        label.text = Resources.SessionsList.Movies.usersTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension SessionUserHeader {

    func setupUI() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .spacingLarge),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingMedium),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .spacingMedium),
            titleLabel.heightAnchor.constraint(equalToConstant: .textLabelHeight)
        ])
    }
}
