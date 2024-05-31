//
//  ReusableUICollectionView.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 24.05.2024.
//

import UIKit

struct ReusableCollectionModel {
    let image: UIImage?
    let upperText: String?
    let lowerText: String?
}

final class ReusableUICollectionView: UIView {

    // MARK: - Private properties

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout.createLeftAlignedLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear

        return collectionView
    }()

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        view.contentMode = .scaleAspectFill

        return view
    }()

    private lazy var upperLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .textParagraphBoldFont
        label.textColor = .headingText

        return label
    }()

    private lazy var lowerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .textParagraphRegularFont
        label.textColor = .captionLightText

        return label
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .whiteBackground
        layer.cornerRadius = 24
        layer.masksToBounds = true

        setupSubviews()
        setupConstraints()
        setupNotificationObserver()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name(Resources.ReusableCollectionView.updateCollectionView),
            object: nil
        )
    }

    // MARK: - Public methods

    func setupCollectionView(
        with controller: UIViewController,
        cell: UICollectionViewCell.Type,
        cellIdentifier: String,
        and model: ReusableCollectionModel? = nil
    ) {
        collectionView.register(
            cell,
            forCellWithReuseIdentifier: cellIdentifier
        )
        collectionView.delegate = controller as? UICollectionViewDelegate
        collectionView.dataSource = controller as? UICollectionViewDataSource

        guard let model else { return }
        imageView.image = model.image
        upperLabel.text = model.upperText
        lowerLabel.text = model.lowerText
    }

    // MARK: - Handlers

    @objc private func updateCollection() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    // MARK: - Private methods

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            lowerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            lowerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            lowerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            lowerLabel.heightAnchor.constraint(equalToConstant: 48),

            upperLabel.leadingAnchor.constraint(equalTo: lowerLabel.leadingAnchor),
            upperLabel.trailingAnchor.constraint(equalTo: lowerLabel.trailingAnchor),
            upperLabel.bottomAnchor.constraint(equalTo: lowerLabel.topAnchor, constant: -12),
            upperLabel.heightAnchor.constraint(equalToConstant: 20),

            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupSubviews() {
        [
            imageView,
            upperLabel,
            lowerLabel,
            collectionView
        ].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCollection),
            name: NSNotification.Name(Resources.ReusableCollectionView.updateCollectionView),
            object: nil
        )
    }
}
