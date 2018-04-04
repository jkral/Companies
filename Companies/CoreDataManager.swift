//
//  CoreDataManager.swift
//  Companies
//
//  Created by Jeff Kral on 12/4/17.
//  Copyright © 2017 Jeff Kral. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CompaniesModel")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        
        return container
    }()
    
    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies            
        } catch let fetchErr {
            print("Failed to fetch companies: ", fetchErr)
            return[]
        }
    }
    
    func createEmployee(employeeName: String, employeeType: String, birthday: Date, company: Company) -> (Employee?, Error?) {
        
        let context = persistentContainer.viewContext
        
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        
        employee.company = company
        employee.type = employeeType
        
        employee.setValue(employeeName, forKey: "name")
        
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        
        employeeInformation.taxId = "456"
        employeeInformation.birthday = birthday
        
        employee.employeeInformation = employeeInformation
        
        do {
            try context.save()
            return (employee, nil)
        } catch let err {           
            print("Falied to save employee: ", err)
            return (nil, err)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
