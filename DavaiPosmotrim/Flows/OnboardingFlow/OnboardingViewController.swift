//
//  OnboardingViewController.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 22.04.2024.
//

import UIKit

final class OnboardingViewController: UIViewController {

    // MARK: - Stored properties

    var presenter: OnboardingPresenterProtocol?

    private var nextButtonAction: (() -> Void)?

    private let pages: [PageModel] = [
        PageModel(
            image: .firstOnboarding,
            upperText: Resources.Onboarding.firstOnboardingUpperLabelText,
            upperColoredText: Resources.Onboarding.coloredFirstUpperText,
            lowerText: Resources.Onboarding.firstOnboardingLowerLabelText
        ),

        PageModel(
            image: .secondOnboarding,
            upperText: Resources.Onboarding.secondOnboardingUpperLabelText,
            upperColoredText: Resources.Onboarding.coloredSecondUpperText,
            lowerText: Resources.Onboarding.secondOnboardingLowerLabelText
        ),

        PageModel(
            image: .thirdOnboarding,
            upperText: Resources.Onboarding.thirdOnboardingUpperLabelText,
            upperColoredText: Resources.Onboarding.coloredThirdUpperText,
            lowerText: Resources.Onboarding.thirdOnboardingLowerLabelText
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
            onboardingEvent: .firstOnboarding,
            pages: pages
        )
        view.setupNextButtonAction(with: nextButtonAction)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initializers

    init(presenter: OnboardingPresenter) {
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
            UserDefaults.standard.setValue(true, forKey: Resources.Onboarding.onboardingUserDefaultsKey)
            DispatchQueue.main.async {
                self.presenter?.onboardingFinish()
            }
        }
    }
}
