//
//  QuoteListTableViewManager.swift
//  Technical-test
//
//  Created by Maksym Balukhtin on 18.04.2023.
//

import UIKit

enum QuotesListEvent {
    case onQuoteAction(Quote)
    case onFavoriteAction(Quote, Bool)
}

class QuoteListTableViewManager: NSObject {
    private var data: [Quote]
    private var tableView: UITableView
    
    var eventHandler: ((QuotesListEvent) -> Void)?
    
    init(_ tableView: UITableView, data: [Quote]) {
        self.data = data
        self.tableView = tableView
        super.init()
        
        tableView.register(QuotesListCell.self, forCellReuseIdentifier: QuotesListCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    func updateData(_ data: [Quote]) {
        self.data = data
        
        tableView.reloadData()
    }
}

//MARK: - Data Source
extension QuoteListTableViewManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuotesListCell.reuseIdentifier, for: indexPath) as? QuotesListCell else { return UITableViewCell() }
        let quote = data[indexPath.row]
        cell.config(with: quote)
        cell.eventHandler = { [weak self] isActive in
            self?.eventHandler?(.onFavoriteAction(quote, isActive))
        }
        return cell
    }
}

//MARK: - Delegate
extension QuoteListTableViewManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventHandler?(.onQuoteAction(data[indexPath.row]))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
