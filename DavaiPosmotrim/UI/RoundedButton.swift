//
//  RoundedButton.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 05.05.2024.
//

import UIKit

final class RoundedButton: UIButton {

    // MARK: - Enum

    enum ButtonType {
        case accentPrimary
        case accentTertiary
        case backgroundBase
    }

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public method

    override func draw(_ rect: CGRect) {
        self.addTarget(self, action: #selector(tapped), for: .touchDown)
        self.addTarget(self, action: #selector(untapped), for: .touchUpInside)
    }

    func configure(title: String, type: ButtonType) {
        setTitle(title, for: .normal)
        setTitleColor(type == .backgroundBase ? .baseText : .whiteText, for: .normal)
        titleLabel?.font = type == .backgroundBase ? .textButtonBoldFont : .textButtonMediumFont
        switch type {
        case .accentPrimary: backgroundColor = .basePrimaryAccent
        case .accentTertiary: backgroundColor = .baseTertiaryAccent
        case .backgroundBase: backgroundColor = .baseBackground
        }
    }

}

// MARK: - Private extension for enum & methods

private extension RoundedButton {

    enum ButtonTransparent {
        static let partOpaque: CGFloat = 0.7
        static let fullOpaque: CGFloat = 1
    }

    func setupButton() {
        layer.cornerRadius = .radiusBase
        layer.masksToBounds = true
    }

    // MARK: - Animation effects for custom buttons

    @objc func tapped() {
        self.alpha = ButtonTransparent.partOpaque
    }

    @objc func untapped() {
        self.alpha = ButtonTransparent.fullOpaque
    }

}
