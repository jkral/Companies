//
//  ViewController.swift
//  Companies
//
//  Created by Jeff Kral on 11/28/17.
//  Copyright © 2017 Jeff Kral. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
    
    var companies = [Company]()
    
    @objc private func doWork() {
        print("trying to do work....")
        
                CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
                
                (0...5).forEach { (value) in
                    print(value)
                    let company = Company(context: backgroundContext)
                    company.name = String(value)
                }
                
                do {
                    try backgroundContext.save()
                    
                    DispatchQueue.main.async {
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                    
                } catch let err {
                    print("failed to save", err)
                }
                
            })
        
    }
    
    @objc private func doUpdates() {
        print("trying to update companies on a background thread")
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            
            do {
                let companies = try backgroundContext.fetch(request)
                
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "C: \(company.name ?? "")"
                })
                do {
                    try backgroundContext.save()
                    
                    DispatchQueue.main.async {
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                }
                
            } catch let err {
                print(err)
            }
            
        }
    }
    
    @objc private func doNestedUpdates() {
        print("trying to perform nested updates...")
        
        DispatchQueue.global(qos: .background).async {
            
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            
            do {
                let companies = try privateContext.fetch(request)
                
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "D: \(company.name ?? "")"
                })
                
                do {
                    try privateContext.save()
                    
                    DispatchQueue.main.async {
                        do {
                            let context = CoreDataManager.shared.persistentContainer.viewContext
                            
                            if context.hasChanges {
                                try context.save()
                            }
                            
                            self.tableView.reloadData()
                        } catch let err {
                            print(err)
                        }
                        
                    }
                } catch let err {
                    print(err)
                }
                
            } catch let fetchErr {
                print("fetch error", fetchErr)
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)), UIBarButtonItem(title: "Nested updates", style: .plain, target: self, action: #selector(doNestedUpdates))]
        
        view.backgroundColor = .white
        
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(handleAddCompany))
        
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
    }
    
    @objc func handleAddCompany() {
        
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        
        createCompanyController.delegate = self
        
        present(navController, animated: true, completion: nil)
        
    }
    
    @objc private func handleReset() {
        print("tapping reset button")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            
            try context.execute(batchDeleteRequest)
            
            var indexPathsToRemove = [IndexPath]()
            
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
            
        } catch let deleteError {
            print("falied delete: ", deleteError)
        }
    }
}

