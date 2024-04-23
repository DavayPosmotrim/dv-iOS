//
//  OnboardingViewController.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import UIKit

protocol OnboardingViewProtocol: AnyObject {

}

final class OnboardingViewController: UIViewController {

    // MARK: - Public Properties

    var presenter: OnboardingPresenterProtocol?

    override func viewDidLoad() {
        view.backgroundColor = .systemOrange
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.presenter?.onboardingFinish()
        }
    }

    // MARK: - Initializers

    init(presenter: OnboardingPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OnboardingViewController: OnboardingViewProtocol {

}
