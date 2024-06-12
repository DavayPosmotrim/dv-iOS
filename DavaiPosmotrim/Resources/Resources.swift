//
//  Resources.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 06.05.2024.
//

import Foundation

enum Resources {
    enum ReusableCollectionView {
        static let updateCollectionView = "updateCollectionView"
    }

    enum Onboarding {
        static let nextButtonText = "Продолжить".uppercased()
        static let beginButtonText = "Начать".uppercased()

        static let firstOnboardingLowerLabelText = "Никаких лишних разговоров и долгих поисков."
        static let secondOnboardingLowerLabelText = "Выбирать фильмы можно с любым количеством людей."
        static let thirdOnboardingLowerLabelText = "Только самые любимые жанры или готовые подборки."

        static let firstOnboardingUpperLabelText = "Выбирайте фильмы\nбез стресса"
        static let secondOnboardingUpperLabelText = "Вдвоём или\nв большой компании"
        static let thirdOnboardingUpperLabelText = "Библиотека фильмов на любой вкус"

        static let coloredFirstUpperText = "без стресса"
        static let coloredSecondUpperText = "Вдвоём"
        static let coloredThirdUpperText = "на любой вкус"
    }

    enum Authentication {
        static let savedNameUserDefaultsKey = "userName"
        static let authDidFinishNotification = "AuthDidFinishNotification"

        static let upperLabelText = "Введите ваше имя"
        static let joinSessionUpperText = "Код сеанса"
        static let enterButtonLabelText = "Войти".uppercased()
        static let editButtonLabelText = "Сохранить".uppercased()
        static let joinSessionButtonLabelText = "Присоединиться".uppercased()

        static let lowerLabelInputNameWarningText = "Введите имя"
        static let lowerLabelLengthWarningText = "Минимум две буквы"
        static let lowerLabelNumbersWarningText = "Только буквы"
        static let lowerLabelMaxCharactersText = "Не более 16 символов"
        static let lowerLabelSessionNotFound = "Сеанс не найден"
    }

    enum MainScreen {
        static let startJoinSessionFlow = "startJoinSessionFlow"
    }

    enum JoinSession {
        static let joinSessionCreatedCode = "joinSessionCreatedCode"

        static let sessionNameLabelText = "Сеанс "
        static let enterButtonLabelText = "Выйти".uppercased()
        static let upperLabelText = "Ожидаем подключения всех участников"
        static let lowerLabelText = "Сеанс начнётся, когда подключатся \n все самые нужные люди."

        static let customLabelUpperText = "Покинуть сеанс?"
        static let customLabelLowerText = "До того, как начнётся этот сеанс, вы сможете подключиться повторно."
        static let customLabelYesButtonText = "Да".uppercased()
        static let customLabelNoButtonText = "Нет".uppercased()
    }

    enum MainFlow {
        static let descriptionLabelText = """
    Забудьте о бесконечных спорах и компромиссах
    Наслаждайтесь моментами, выбрав вместе идеальный фильм
    """
        static let titleLabelTextCellOne = "Создать сеанс"
        static let titleLabelTextCellTwo = "Понравившиеся фильмы"
        static let titleLabelTextCellThree = "Присоединиться к сеансу"

        static let authViewController = "AuthViewController"
        static let createSessionViewController = "CreateSessionViewController"
        static let favoriteMoviesViewController = "FavoriteMoviesViewController"
        static let joinSessionViewController = "JoinSessionViewController"
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

    enum SessionsList {
        static let title = "Понравившиеся фильмы"
        static let placeholderTitle = "Пока ничего нет"
        static let placeholderDescription = "Здесь будут фильмы,\n которые вам понравились"
    }
}
