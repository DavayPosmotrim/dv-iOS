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

    enum ReusableLikedMoviesCollectionView {
        static let updateCollectionView = "updateLikedMoviesCollectionView"
    }

    enum Onboarding {
        static let onboardingUserDefaultsKey = "isOnboardingShown"

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

    enum MovieSelectionOnboarding {
        static let movieSelectionOnboardingUserDefaultsKey = "isMovieSelectionOnboardingShown"

        static let firstOnboardingLowerLabelText = """
        Свайп вправо - нравится.
        Свайп влево - не нравится.
        Да, да, сделали очень оригинально.
        """
        static let secondOnboardingLowerLabelText = "Храним историю всех совпадений во время и после сеансов."
        static let thirdOnboardingLowerLabelText = "Сеанс закончится, когда один из участников его покинет."

        static let firstOnboardingUpperLabelText = "Всё как вы привыкли"
        static let secondOnboardingUpperLabelText = "Выбирайте\nиз общих\nсовпадений"
        static let thirdOnboardingUpperLabelText = "Ещё секундочку"

        static let coloredFirstUpperText = "привыкли"
        static let coloredSecondUpperText = "общих\nсовпадений"
        static let coloredThirdUpperText = "секундочку"
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

    enum InvitingSession {
        static let lowerLabelText = "Если вы пригласили друзей – дождитесь, когда\n они подключаться, прежде чем начать сеанс."
        static let codeCopyWarningText = "Код сеанса успешно скопирован"
        static let fewUsersWarningText = "Должно быть хотя бы два участника"

        static let inviteButtonLabelText = "Пригласить".uppercased()
        static let startButtonLabelText = "Начать сеанс".uppercased()
        static let cancelButtonLabelText = "Отменить сеанс".uppercased()
        static let usersLabelText = "Участники"

        static let customLabelUpperText = "Отменить?"
        static let customLabelLowerText = "Вы действительно хотите отменить уже созданный сеанс?"

        static let inviteMessageText = "Выбор фильма зависит от вас! Код для подключения к сеансу: "
        static let downloadAppText = "Ссылки для скачивания приложения: \n"
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

    enum Coincidences {
        static let plugLabelText = "Пока ничего нет"
        static let navBarText = "Совпадения"

        static let navBarTitle = "Понравившийся фильм"
    }

    enum RouletteFlow {
        static let isRouletteOnboardingShown = "RouletteOnboardingIsShown"

        static let titleLabelText = "Доверьтесь случаю"
        static let upperLabelText = "Если понравилось много фильмов и тяжело определиться, что же посмотреть."
        static let lowerLabelText = "Рандомно выберем фильм из всех понравившихся в этом сеансе."
        static let proceedButtonText = "Понял, принял".uppercased()

        static let startTitleLabelText = "Случайный выбор"
        static let startUpperLabelText = "Из всех совпадений выберем один фильм. После выбора, сеанс завершится."
        static let startUpperBoldLabelText = "Из всех совпадений выберем один фильм."
        static let startLowerLabelText = "Остальные участники подключатся автоматически."
        static let beginButtonText = "Начать".uppercased()
        static let cancelButtonText = "Отменить".uppercased()

        static let usersCollectionLowerText = "Начнём магию, когда подключатся все участники"
        static let usersCollectionTitleText = "Ждём участников..."
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

    enum SplashScreen {
        static let musicalText = "Мюзикал"
        static let thrillerText = "Триллер"
        static let melodrammaText = "Мелодрамма"
        static let biographyText = "Биография"
        static let boevikText = "Боевик"
        static let fantasyText = "Фантастика"
        static let posmotrimText = "Посмотрим?"
        static let multfilmText = "Мультфильм"
        static let familyText = "Семейный"
        static let documentaryText = "Документальный"
        static let adventureText = "Приключение"

        static let topBorderIdent = "topBorder"
        static let leftBorderIdent = "leftBorder"
        static let rightBorderIdent = "rightBorder"
        static let bottomBorderIdent = "bottomBorder"
        static let davayImageViewIdent = "davayImageView"
	}

    enum SelectionMovies {
        static let titleNavBarText = "Выберите фильм"
        static let rightButtonLabelText = "0"
        static let customLabelUpperText = "Покинуть сеанс?"
        static let customLabelLowerText = """
    Сеанс будет завершён у всех участников.

    Все совпавшие фильмы вы найдёте в разделе «Понравившиеся фильмы».
    """

        static let customOneButtonLabelUpperText = "Сеанс завершён"
        static let customOneButtonLabelLowerText = """
    Участник покинул сеанс.

    Все совпавшие фильмы вы найдёте в разделе «Понравившиеся фильмы».
    """

        static let customOneButtonText = "Хорошо".uppercased()
        static let continueButtonText = "Продолжить сеанс".uppercased()
    }

    enum MovieDetails {
        static let kinoPoiskRatingText = "Рейтинг Кинопоиска"
        static let iMDBRatingText = "Рейтинг IMDb"

        static let movieDetailsText = "Подробнее о фильме"
        static let mainRolesText = "В главных ролях"
        static let directorText = "Режиссёр"
        static let votesText = "Оценки"
        static let howManyVotesText = " оценок"
    }

    enum SessionsList {
        static let title = "Понравившиеся фильмы"
        // swiftlint:disable:next nesting
        enum Sessions {
            static let matchesTitle = "Совпадений:"
            static let noImageTitle = "Не удалось загрузить фото"
        }
        // swiftlint:disable:next nesting
        enum NoSessions {
            static let title = "Пока ничего нет"
            static let description = "Здесь будут фильмы,\n которые вам понравились"
        }
        // swiftlint:disable:next nesting
        enum Movies {
            static let sessionTitle = "Сеанс"
            static let usersTitle = "Участники"
        }
    }

    enum AnimationKeys {
        static let strokeEnd = "strokeEnd"
        static let progressAnimation = "progressAnimation"
    }
}
