//
//  MainViewController.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - Public Properties

    var presenter: MainPresenterProtocol?

    // MARK: - Private Properties

    private let mainCellModels: [MainCellModel] = [
        MainCellModel(
            title: Resources.MainFlow.titleLabelTextCellOne,
            textColor: .whiteText,
            paddingBackgroundColor: .basePrimaryAccent,
            menuImage: UIImage.circledForwardIcon.withRenderingMode(.alwaysTemplate),
            menuImageColor: .whiteBackground
        ),
        MainCellModel(
            title: Resources.MainFlow.titleLabelTextCellTwo,
            textColor: .baseText,
            paddingBackgroundColor: .baseSecondaryAccent,
            menuImage: UIImage.circledHeartIcon.withRenderingMode(.alwaysTemplate),
            menuImageColor: .baseTertiaryAccent
        ),
        MainCellModel(
            title: Resources.MainFlow.titleLabelTextCellThree,
            textColor: .whiteText,
            paddingBackgroundColor: .baseTertiaryAccent,
            menuImage: UIImage.circledForwardIcon.withRenderingMode(.alwaysTemplate),
            menuImageColor: .whiteBackground
        )
    ]

    // MARK: - Layout variables

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.smallLogo
        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Resources.MainFlow.descriptionLabelText
        label.textColor = .captionDarkText
        label.font = .textCaptionRegularFont
        label.textAlignment = .right
        label.numberOfLines = 0

        if let labelText = label.text,
           let range = labelText.range(of: "Наслаждайтесь моментами") {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(
                .foregroundColor,
                value: UIColor.basePrimaryAccent,
                range: NSRange(range, in: labelText)
            )
            label.attributedText = attributedString
        }
        return label
    }()

    private lazy var paddingView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteBackground
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 24
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = presenter?.checkUserNameProperty()
        label.textColor = .headingText
        label.font = .textLabelFont
        return label
    }()

    private lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage.circledEditIcon
        button.setImage(image, for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapBackButton),
            for: .touchUpInside
        )
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 88
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    // MARK: - Initializers

    init(presenter: MainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: Notification.Name(Resources.Authentication.authDidFinishNotification),
            object: nil
        )
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .baseBackground
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        setupSubviews()
        setupConstraints()
        setupAuthNotificationObserver()
        setupTableViewHeightConstraint()

        presenter?.getUser()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Actions

    @objc private func didTapBackButton() {
        presenter?.didTapButtons(screen: Resources.MainFlow.authViewController)
    }

    @objc private func updateUserName(_ notification: Notification) {
        nameLabel.text = presenter?.getUserName(notification)
    }

    // MARK: - Private methods

    private func setupAuthNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUserName(_:)),
            name: Notification.Name(Resources.Authentication.authDidFinishNotification),
            object: nil
        )
    }

    private func setupSubviews() {
        [
            imageView,
            descriptionLabel,
            paddingView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        [
            nameLabel,
            editButton,
            tableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            paddingView.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 53),
            imageView.widthAnchor.constraint(equalToConstant: 122),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),

            paddingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paddingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paddingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            tableView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 36),
            tableView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),

            nameLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 32),
            nameLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -56),
            nameLabel.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 16),

            editButton.heightAnchor.constraint(equalToConstant: 40),
            editButton.widthAnchor.constraint(equalToConstant: 40),
            editButton.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -32),

            descriptionLabel.heightAnchor.constraint(equalToConstant: 48),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: paddingView.topAnchor, constant: -24)
        ])
    }

    private func setupTableViewHeightConstraint() {
        tableView.layoutIfNeeded()
        let tableViewHeight = tableView.contentSize.height
        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: tableViewHeight)
        ])
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainCellModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath)
        guard let mainTableViewCell = cell as? MainTableViewCell else {
            return UITableViewCell()
        }
        let model = mainCellModels[indexPath.row]
        mainTableViewCell.configureCell(model: model)
        return mainTableViewCell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            presenter?.didTapButtons(screen: Resources.MainFlow.createSessionViewController)
        case 1:
            presenter?.didTapButtons(screen: Resources.MainFlow.favoriteMoviesViewController)
        case 2:
            presenter?.didTapButtons(screen: Resources.MainFlow.joinSessionViewController)
        default:
            break
        }
    }
}
