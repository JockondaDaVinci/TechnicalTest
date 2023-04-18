//
//  CoreDataManager.swift
//  Technical-test
//
//  Created by Maksym Balukhtin on 18.04.2023.
//
import CoreData
import UIKit

class CoreDataManager {
    private var context: NSManagedObjectContext?
    static var shared = CoreDataManager()
    
    init() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        context = delegate.persistentContainer.viewContext
    }
    
    func save(quote: Quote) {
        guard let context = context else { return }
        
        let fetchRequest = QuoteModel.fetchRequest()
        
        func formModel() {
            let model = QuoteModel(context: context)
            model.setValue(quote.symbol, forKey: #keyPath(QuoteModel.symbol))
            model.setValue(quote.name, forKey: #keyPath(QuoteModel.name))
            model.setValue(quote.currency, forKey: #keyPath(QuoteModel.currency))
            model.setValue(quote.last, forKey: #keyPath(QuoteModel.last))
            model.setValue(quote.variationColor, forKey: #keyPath(QuoteModel.variationColor))
            model.setValue(quote.readableLastChangePercent, forKey: #keyPath(QuoteModel.readableLastChangePercent))
        }
        
        do {
            let data = try context.fetch(fetchRequest)
            if !data.contains(where: { $0.name == quote.name }) {
                formModel()
                try context.save()
            } else {
                delete(quote: quote)
                
                formModel()
                try context.save()
            }
        } catch {
            print(error)
        }
    }
    
    func fetch() -> [Quote] {
        guard let context = context else { return [] }
        
        let fetchRequest = QuoteModel.fetchRequest()
        
        do {
            let data = try context.fetch(fetchRequest)
            return data.map { model -> Quote in
                Quote(symbol: model.symbol,
                      name: model.name,
                      currency: model.currency,
                      readableLastChangePercent: model.readableLastChangePercent,
                      last: model.last,
                      variationColor: model.variationColor)
            }
        } catch {
            print(error)
            return []
        }
    }
    
    func delete(quote: Quote) {
        guard let context = context else { return }
        let fetchRequest = QuoteModel.fetchRequest()
        
        do {
            let data = try context.fetch(fetchRequest)
            if let quote = data.first(where: { $0.name == quote.name }) {
                context.delete(quote)
                try context.save()
            }
        } catch {
            print(error)
        }
    }
}
