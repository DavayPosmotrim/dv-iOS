//
//  MovieSelectionOnboardingViewController.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 05.06.2024.
//

import UIKit

final class MovieSelectionOnboardingViewController: UIViewController {

    // MARK: - Stored properties

    var presenter: MovieSelectionOnboardingPresenterProtocol?

    private var nextButtonAction: (() -> Void)?

    private let pages: [PageModel] = [
        PageModel(
            image: .firstMovieSelection,
            upperText: Resources.MovieSelectionOnboarding.firstOnboardingUpperLabelText,
            upperColoredText: Resources.MovieSelectionOnboarding.coloredFirstUpperText,
            lowerText: Resources.MovieSelectionOnboarding.firstOnboardingLowerLabelText
        ),

        PageModel(
            image: .secondMovieSelection,
            upperText: Resources.MovieSelectionOnboarding.secondOnboardingUpperLabelText,
            upperColoredText: Resources.MovieSelectionOnboarding.coloredSecondUpperText,
            lowerText: Resources.MovieSelectionOnboarding.secondOnboardingLowerLabelText
        ),

        PageModel(
            image: .thirdMovieSelection,
            upperText: Resources.MovieSelectionOnboarding.thirdOnboardingUpperLabelText,
            upperColoredText: Resources.MovieSelectionOnboarding.coloredThirdUpperText,
            lowerText: Resources.MovieSelectionOnboarding.thirdOnboardingLowerLabelText
        )
    ]

    // MARK: - Lazy properties

    private lazy var paddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        return view
    }()

    private lazy var onboardingView: ReusableOnboardingView = {
        let view = ReusableOnboardingView(
            frame: .zero,
            onboardingEvent: .secondOnboarding,
            pages: pages
        )
        view.setupNextButtonAction(with: nextButtonAction)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initializers

    init(presenter: MovieSelectionOnboardingPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .baseBackground

        navigationController?.setNavigationBarHidden(true, animated: true)

        setupNextButtonAction()
        setupView()
    }

    // MARK: - Private methods

    private func setupView() {
        [paddingView, onboardingView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            onboardingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            onboardingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            onboardingView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            onboardingView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            paddingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            paddingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            paddingView.topAnchor.constraint(equalTo: view.centerYAnchor),
            paddingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupNextButtonAction() {
        nextButtonAction = { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                self.presenter?.nextButtonTapped()
            }
        }
    }
}
