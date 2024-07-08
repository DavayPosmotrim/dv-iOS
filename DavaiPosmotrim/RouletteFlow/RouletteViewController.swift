//
//  RouletteViewController.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 08.07.2024.
//

import UIKit

final class RouletteViewController: UIViewController {

    // MARK: - Stored Properties

    private var presenter: RoulettePresenterProtocol

    // MARK: - Initializers

    init(presenter: RoulettePresenterProtocol) {
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
}

    // MARK: - JoinSessionViewProtocol

extension RouletteViewController: RouletteViewProtocol {}
