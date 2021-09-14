//
//  PortfolioDataService.swift
//  PortfolioDataService
//
//  Created by Łukasz Stachnik on 14/09/2021.
//

import Foundation
import Combine
import CoreData

class PortfolioDataService {
    
    private let container : NSPersistentContainer
    private let containerName : String = "PortfolioContainer"
    
    @Published var savedEntities : [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getPortfolio()
        }
        
    }
    
    //MARK: - Public
    
    func updatePortfolio(coin: Coin, amount: Double) {
        
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                remove(entity: entity)
            }
            
        } else {
            add(coin: coin, amount: amount)
        }
        
    }
    
    
    //MARK: - Private
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: "PortfolioEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
    }
    
    private func add(coin : Coin, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity : PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func remove(entity : PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
    
}
