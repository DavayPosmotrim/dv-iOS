//
//  RoundedButton.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 05.05.2024.
//

import UIKit

final class RoundedButton: UIButton {

    // MARK: - Enums

    enum ButtonType {
        case accentPrimary
        case accentTertiary
        case backgroundBase
    }

    private enum ButtonTransparent {
        static let partOpaque: CGFloat = 0.7
        static let fullOpaque: CGFloat = 1
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

// MARK: - Private methods

private extension RoundedButton {

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


enum Resources {
    enum Mistakes {
        static let noInternetHeader = "Нет соединения с интернетом"
        static let noInternetText = "Интернет не бом-бом,\n проверьте соединение"
        static let noInternetButtonTitle = "повторное подключение".uppercased()

        static let serviceUnavailableHeader = "Сервис временно недоступен"
        static let serviceUnavailableText = "Дождитесь, пока мы сделаем магию.\n Вжух!"

        static let oldVersionHeader = "Версия приложения устарела"
        static let oldVersionText = "Сначала сломали, потом починили.\n Скачайте, обновлённую версию."
        static let oldVersionButtonTitle = "Перейти в магазин".uppercased()
    }
}
