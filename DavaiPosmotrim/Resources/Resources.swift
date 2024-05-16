//
//  Resources.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 06.05.2024.
//

import Foundation

enum Resources {
    enum Authentication {
        static let savedNameUserDefaultsKey = "userName"

        static let upperLabelText = "Введите ваше имя"
        static let enterButtonLabelText = "Войти".uppercased()
        static let editButtonLabelText = "Сохранить".uppercased()

        static let lowerLabelInputNameWarningText = "Введите имя"
        static let lowerLabelLengthWarningText = "Минимум две буквы"
        static let lowerLabelNumbersWarningText = "Только буквы"
        static let lowerLabelMaxCharactersText = "Не более 16 символов"
    }

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
