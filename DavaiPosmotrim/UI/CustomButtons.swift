//
//  CustomButtons.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 23.04.2024.
//

import UIKit

final class CustomButtons: UIView {

    // MARK: - Lazy properties

    lazy var purpleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .basePrimaryAccent
        button.setTitleColor(.whiteText, for: .normal)
        button.titleLabel?.font = .textButtonMediumFont
        button.layer.cornerRadius = 14
        return button
    }()

    lazy var blackButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .baseTertiaryAccent
        button.setTitleColor(.whiteText, for: .normal)
        button.titleLabel?.font = .textButtonMediumFont
        button.layer.cornerRadius = 14
        return button
    }()

    lazy var grayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .baseBackground
        button.setTitleColor(.baseText, for: .normal)
        button.titleLabel?.font = .textButtonMediumFont
        button.layer.cornerRadius = 14
        return button
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func setupView(with button: UIButton) {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
