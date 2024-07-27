//
//  EditNameViewController.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 28.07.2024.
//

import UIKit

final class EditNameViewController: UIViewController {

    // MARK: - Public properties

    var presenter: EditNamePresenterProtocol

    // MARK: - Initializers

    init(presenter: EditNamePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemOrange
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        presenter.finishEdit()
    }
}

extension EditNameViewController : EditNameViewProtocol {}
