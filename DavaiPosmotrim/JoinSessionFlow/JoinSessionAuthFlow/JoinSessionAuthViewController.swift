//
//  JoinSessionAuthViewController.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import UIKit

final class JoinSessionAuthViewController: UIViewController {

    // MARK: - Public properties

    var presenter: JoinSessionAuthPresenterProtocol

    // MARK: - Initializers

    init(presenter: JoinSessionAuthPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBlue
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        presenter.finishSessionAuth()
    }
}

extension JoinSessionAuthViewController: JoinSessionAuthViewProtocol {}
