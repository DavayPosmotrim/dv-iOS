//
//  CoincidencesViewController.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 12.06.2024.
//

import UIKit

final class CoincidencesViewController: UIViewController {

    // MARK: - Stored Properties

    var presenter: CoincidencesPresenterProtocol?

    // MARK: - Initializers

    init(presenter: CoincidencesPresenterProtocol) {
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
    }
}

    // MARK: - CoincidencesViewProtocol

extension CoincidencesViewController: CoincidencesViewProtocol {

}
