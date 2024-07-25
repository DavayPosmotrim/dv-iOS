//
//  RouletteCollectionViewCell.swift
//  DavaiPosmotrim
//
//  Created by Эльдар Айдумов on 18.07.2024.
//

import UIKit

final class RouletteCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "RouletteCollectionViewCell"

    private var movieCard: CustomMovieSelection?
    private var viewModel: SelectionMovieCellModel? {
        didSet {
            if let viewModel {
                movieCard = CustomMovieSelection(model: viewModel)
                movieCard?.showButtons = false
                movieCard?.showCollection = false
                movieCard?.showMovieCountries = false
                setupCell()
            }
        }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        backgroundColor = .whiteBackground
        layer.cornerRadius = 24
        layer.masksToBounds = true

        guard let movieCard else { return }
        contentView.addSubview(movieCard)
        movieCard.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            movieCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieCard.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configureCell(with model: SelectionMovieCellModel?) {
        guard let model else { return }
        viewModel = model
    }

    func getCellID() -> UUID {
        guard let cellID = viewModel?.id else { return UUID() }
        return cellID
    }
}
