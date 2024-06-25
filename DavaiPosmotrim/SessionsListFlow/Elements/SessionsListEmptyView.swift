//
//  SessionsListEmptyView.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 07.06.2024.
//

import UIKit

final class SessionsListEmptyView: UIView {

    // MARK: - View properties
    private lazy var placeholderStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = .spacingBase
        return stack
    }()
    private lazy var placeholderTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .headingText
        label.font = .textLabelFont
        return label
    }()
    private lazy var placeholderDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .baseText
        label.font = .textParagraphRegularFont
        return label
    }()
    private lazy var placeholderImageView = UIImageView()

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

// MARK: - Private methods
private extension SessionsListEmptyView {

    func setupUI() {
        backgroundColor = .whiteBackground
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = .radiusLarge

        [placeholderStackView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [placeholderImageView, placeholderTitleLabel, placeholderDescriptionLabel].forEach {
            placeholderStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            placeholderStackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            placeholderStackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),

            placeholderImageView.topAnchor.constraint(equalTo: placeholderStackView.topAnchor),
            placeholderImageView.heightAnchor.constraint(equalToConstant: .placeholderSize),
            placeholderImageView.widthAnchor.constraint(equalToConstant: .placeholderSize),

            placeholderTitleLabel.heightAnchor.constraint(equalToConstant: .textHeadingHeight),

            placeholderDescriptionLabel.heightAnchor.constraint(equalToConstant: .textParagraphHeightTwoLines)
        ])
    }

    func setupSubviewsValue() {
        placeholderImageView.image = UIImage(resource: .emptyFolderPlug)
        placeholderTitleLabel.text = Resources.SessionsList.NoSessions.title
        placeholderDescriptionLabel.text = Resources.SessionsList.NoSessions.description
    }
}
