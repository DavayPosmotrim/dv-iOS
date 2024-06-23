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
    private var customNavBarModel: CustomNavBarModel?
    private var customNavBarRightButtonModel: CustomNavBarRightButtonModel?

    // MARK: - Lazy Properties

    private lazy var navBarView: CustomNavBar = {
        let navBar = CustomNavBar()
        navBar.setupCustomNavBar(with: customNavBarModel)
        return navBar
    }()

    private lazy var paddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return view
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 12
        return stack
    }()

    private lazy var plugImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.emptyFolderPlug
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        return imageView
    }()

    private lazy var plugLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = Resources.Coincidences.plugLabelText
        label.textColor = .baseText
        label.font = .textLabelFont
        return label
    }()

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
        navigationController?.setNavigationBarHidden(true, animated: true)

        setupNavBarModel()
        setupSubviews()
        setupConstraints()
        updateUIElements()
    }

    // MARK: - Private methods

    private func setupSubviews() {
        [navBarView, paddingView, stackView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [plugImageView, plugLabel].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            navBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            navBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            navBarView.bottomAnchor.constraint(equalTo: safeArea.topAnchor, constant: 64),

            paddingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            paddingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            paddingView.topAnchor.constraint(equalTo: navBarView.bottomAnchor, constant: 16),
            paddingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.centerXAnchor.constraint(equalTo: paddingView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor),

            plugImageView.topAnchor.constraint(equalTo: stackView.topAnchor),

            plugLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            plugLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            plugLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
    }

    private func setupNavBarModel() {
        customNavBarModel = CustomNavBarModel(
            titleText: Resources.Coincidences.navBarText,
            subtitleText: nil,
            leftButtonImage: UIImage.customBackIcon,
            leftAction: { [weak self] in
                guard let self else { return }
                print("Left button")
            }
        )
    }

    private func setupRightButtonModel() {
        customNavBarRightButtonModel = CustomNavBarRightButtonModel(
            rightButtonImage: UIImage.diceIcon,
            isRightButtonLabelHidden: true,
            rightButtonLabelText: nil,
            rightAction: { [weak self] in
                guard let self else { return }
                print("Right button")
            }
        )
    }

    private func updateUIElements() {
        if presenter?.moviesArray?.isEmpty == false {
            setupRightButtonModel()
            navBarView.setupRightButton(with: customNavBarRightButtonModel)
            stackView.isHidden = true
        }
    }
}

    // MARK: - CoincidencesViewProtocol

extension CoincidencesViewController: CoincidencesViewProtocol {}
