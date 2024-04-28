//
//  MainViewController.swift
//  DavaiPosmotrim
//
//  Created by Aleksandr Garipov on 23.04.2024.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - Private Properties

    private struct Keys {
        static let descriptionLabelText = """
    Забудьте о бесконечных спорах и компромиссах
    Наслаждайтесь моментами, выбрав вместе идеальный фильм
    """
        static let nameLabelText = "Артем_Test"
        static let titleLabelTextCellOne = "Создать сеанс"
        static let titleLabelTextCellTwo = "Понравившиеся фильмы"
        static let titleLabelTextCellThree = "Присоединиться к сеансу"
    }

    // MARK: - Computed properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.smallLogo

        return imageView
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Keys.descriptionLabelText
        label.textColor = .captionDarkText
        label.font = UIFont(name: "Inter-Regular", size: 12)
        label.textAlignment = .right
        label.numberOfLines = 0

        if let labelText = label.text, let range = labelText.range(of: "Наслаждайтесь моментами") {
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
        label.text = Keys.nameLabelText
        label.textColor = .headingText
        label.font = UIFont(name: "DaysOne-Regular", size: 16)

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

        return tableView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .baseBackground
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        addSubviews()
        constraintsSetup()
    }

    // MARK: - IBAction

    @objc func didTapBackButton() {
        // TODO: Go to screen "Edit_name"
    }

    // MARK: - Private methods

    private func addSubviews() {
        [imageView, descriptionLabel, paddingView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        [nameLabel, editButton, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            paddingView.addSubview($0)
        }
    }

    private func constraintsSetup() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 53),
            imageView.widthAnchor.constraint(equalToConstant: 122),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -229),

            descriptionLabel.heightAnchor.constraint(equalToConstant: 48),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 150),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: paddingView.topAnchor, constant: -24),

            paddingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paddingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paddingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 32),
            nameLabel.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 16),

            editButton.heightAnchor.constraint(equalToConstant: 40),
            editButton.widthAnchor.constraint(equalToConstant: 40),
            editButton.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -32),

            tableView.heightAnchor.constraint(equalToConstant: 264),
            tableView.widthAnchor.constraint(equalToConstant: 343),
            tableView.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 36),
            tableView.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor, constant: -100)
        ])
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath)

        guard let mainTableViewCell = cell as? MainTableViewCell else {
            return UITableViewCell()
        }

        switch indexPath.row {
        case 0:
            mainTableViewCell.configureCell(
                titleLabelText: Keys.titleLabelTextCellOne,
                textColor: .whiteText,
                paddingBackgroundColor: .basePrimaryAccent,
                buttonImage: UIImage.circledForwardIcon.withRenderingMode(.alwaysTemplate),
                buttonColor: .whiteBackground
            )
        case 1:
            mainTableViewCell.configureCell(
                titleLabelText: Keys.titleLabelTextCellTwo,
                textColor: .baseText,
                paddingBackgroundColor: .baseSecondaryAccent,
                buttonImage: UIImage.circledHeartIcon.withRenderingMode(.alwaysTemplate),
                buttonColor: .baseTertiaryAccent
            )
        case 2:
            mainTableViewCell.configureCell(
                titleLabelText: Keys.titleLabelTextCellThree,
                textColor: .whiteText,
                paddingBackgroundColor: .baseTertiaryAccent,
                buttonImage: UIImage.circledForwardIcon.withRenderingMode(.alwaysTemplate),
                buttonColor: .whiteBackground
            )
        default:
            break
        }

        return mainTableViewCell
    }
}
