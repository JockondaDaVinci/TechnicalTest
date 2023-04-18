//
//  QuotesListViewController.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import UIKit

class QuotesListViewController: UIViewController {
    private let tableView = UITableView()
    
    private var tableViewManager: QuoteListTableViewManager?
    private let dataManager = DataManager()    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupAutolayout()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchQuotes()
    }
}

private extension QuotesListViewController {
    func fetchQuotes() {
        dataManager.fetchQuotes { [weak self] data in
            guard let self = self else { return }
            self.configureTableView(with: data)
        } errorHandler: { error in
            print(error)
        }
    }
    
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func setupAutolayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    func configureViews() {
        view.backgroundColor = .white
        tableView.backgroundColor = .white
    }
    
    func configureTableView(with data: [Quote]) {
        var data = data
        tableViewManager = QuoteListTableViewManager(tableView, data: data)
        tableViewManager?.eventHandler = { [unowned self] event in
            switch event {
            case .onQuoteAction(let quote):
                let vc = QuoteDetailsViewController(quote: quote)
                navigationController?.pushViewController(vc, animated: true)
            case .onFavoriteAction(let quote, let isActive):
                if isActive {
                    dataManager.addToFavorites(quote)
                } else {
                    dataManager.deleteFavorite(quote)
                }
                
                data = data.map { model in
                    var _model = model
                    if model.name == quote.name {
                        _model.isFavorite = isActive
                    }
                    return _model
                }
                tableViewManager?.updateData(data)
            }
        }
    }
}
