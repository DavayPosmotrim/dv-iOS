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

    // MARK: - Lazy properties

    private lazy var editNameView: ReusableAuthView = {
        let view = ReusableAuthView(frame: .zero, authEvent: .edit)
        return view
    }()

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

        setupView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        presenter.finishEdit()
    }

    // MARK: - Private methods

    private func setupView() {
        view.addSubview(editNameView)
        editNameView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            editNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editNameView.topAnchor.constraint(equalTo: view.topAnchor),
            editNameView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension EditNameViewController : EditNameViewProtocol {}
