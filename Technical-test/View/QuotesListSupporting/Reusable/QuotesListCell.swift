//
//  QuotesListCell.swift
//  Technical-test
//
//  Created by Maksym Balukhtin on 18.04.2023.
//

import UIKit

class QuotesListCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let lastLabel = UILabel()
    private let currencyLabel = UILabel()
    private let readableLastChangePercentLabel = UILabel()
    
    private let favoriteButton = StarButton()
    
    var eventHandler: ((Bool) -> Void)?
    static var reuseIdentifier: String {
        String(describing: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupAutolayout()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    func config(with quote: Quote) {
        nameLabel.text = quote.name
        lastLabel.text = quote.last
        currencyLabel.text = quote.currency
        readableLastChangePercentLabel.text = quote.readableLastChangePercent
        readableLastChangePercentLabel.textColor = UIColor(named: quote.variationColor!) ?? .black
        
        favoriteButton.isActive = quote.isFavorite ?? false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        favoriteButton.isActive = false
        favoriteButton.removeTarget(nil, action: nil, for: [])
        eventHandler = nil
    }
}

private extension QuotesListCell {
    func addSubviews() {
        [nameLabel, lastLabel, currencyLabel, readableLastChangePercentLabel, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    func setupAutolayout() {
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15.0),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            
            lastLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15.0),
            lastLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 5),
            lastLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0),
            
            currencyLabel.leftAnchor.constraint(equalTo: lastLabel.rightAnchor, constant: 10.0),
            currencyLabel.heightAnchor.constraint(equalTo: lastLabel.heightAnchor),
            currencyLabel.topAnchor.constraint(equalTo: lastLabel.topAnchor),
            
            readableLastChangePercentLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            readableLastChangePercentLabel.bottomAnchor.constraint(equalTo: lastLabel.bottomAnchor),
            readableLastChangePercentLabel.rightAnchor.constraint(equalTo: favoriteButton.leftAnchor, constant: 15.0),
            readableLastChangePercentLabel.leftAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0.0),
            
            favoriteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15.0),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44.0),
            favoriteButton.widthAnchor.constraint(equalTo: favoriteButton.heightAnchor)
        ])
    }
    
    func configureViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        [nameLabel, lastLabel, currencyLabel].forEach {
            $0.font = .systemFont(ofSize: 16.0)
            $0.textColor = .black
            $0.textAlignment = .left
        }
        
        readableLastChangePercentLabel.font = .systemFont(ofSize: 24.0, weight: .medium)
        readableLastChangePercentLabel.textAlignment = .center
        
        favoriteButton.addTarget(self, action: #selector(onFavoriteAction(_:)), for: .touchUpInside)
    }
    
    @objc func onFavoriteAction(_ sender: StarButton) {
        sender.isActive.toggle()
        eventHandler?(sender.isActive)
    }
}
