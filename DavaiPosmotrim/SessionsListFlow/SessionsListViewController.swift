//
//  SessionsListViewController.swift
//  DavaiPosmotrim
//
//  Created by Sergey Kemenov on 07.06.2024.
//

import UIKit

final class SessionsListViewController: UIViewController {

    // MARK: - Public properties
    var presenter: SessionsListPresenterProtocol

    // MARK: - View properties
    private lazy var customNavBar: UIView = {
        let customNavBar = CustomNavigationBar(title: Resources.SessionsList.title, subtitle: "")
        customNavBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        customNavBar.layer.cornerRadius = .radiusLarge
        customNavBar.delegate = presenter as? any CustomNavigationBarDelegate
        return customNavBar
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    private lazy var backgroundView = UIView()
    private lazy var sessionsListEmptyView = SessionsListEmptyView()

    // MARK: - Private properties
    private let cellHeightWithVerticalSpacing: CGFloat = 256
    private var isSessionsListEmpty: Bool = false {
        didSet {
            sessionsListEmptyView.isHidden = !isSessionsListEmpty
            tableView.isHidden = isSessionsListEmpty
        }
    }

    // MARK: - Inits
    init(presenter: SessionsListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupUI()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SessionsListCell.self, forCellReuseIdentifier: SessionsListCell.cellID)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showListOrEmptyView()
    }

    // MARK: - Public methods
    func showListOrEmptyView() {
        tableView.reloadData()
        isSessionsListEmpty = presenter.isSessionsListEmpty
    }
}

// MARK: - UITableViewDelegate
extension SessionsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeightWithVerticalSpacing
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
            presenter.updateSessionsList()
        }
    }
}

// MARK: - UITableViewDataSource
extension SessionsListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.sessionsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SessionsListCell.cellID,
                for: indexPath
              ) as? SessionsListCell else {
            return UITableViewCell()
        }
        var model = presenter.getSessionForCellBy(index: indexPath.row)
        model.isFirstCell = indexPath.row == 0
        cell.configureCell(for: model)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - Private methods
private extension SessionsListViewController {

    func setupUI() {
        view.backgroundColor = .whiteBackground
        backgroundView.backgroundColor = .baseBackground

        [backgroundView, sessionsListEmptyView, tableView, customNavBar].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: -.spacingMedium * 2),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            sessionsListEmptyView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            sessionsListEmptyView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            sessionsListEmptyView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: .spacingMedium),
            sessionsListEmptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
