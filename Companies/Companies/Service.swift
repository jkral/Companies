//
//  Service.swift
//  Companies
//
//  Created by Jeff Kral on 12/28/17.
//  Copyright © 2017 Jeff Kral. All rights reserved.
//

import Foundation
import CoreData

struct Service {
    
    static let shared = Service()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func dowloadCompaniesFromServer() {
        print("Attempting to download json from server")
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            print("finished downloading")
            
            if let err = err {
                print("failed to download", err)
                return
            }
            
            guard let data = data else { return }
            
             let jsonDecoder = JSONDecoder()
            
            do {
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data )
                
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
                
                jsonCompanies.forEach({ (jsonCompany) in
                    print(jsonCompany.name)
                    
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM,dd,yyyy"
                    let foundedDate = dateFormatter.date(from: jsonCompany.founded)
                    
                    company.founded = foundedDate
                    
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        print(" \(jsonEmployee.name)")
                        
                        let employee = Employee(context: privateContext)
                        employee.fullName = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        
                        let employeeInformation = EmployeeInformation(context: privateContext)
                        let birthdayDate = dateFormatter.date(from: jsonEmployee.birthday)
                        employeeInformation.birthday = birthdayDate
                        
                        employee.employeeInformation = employeeInformation
                        
                        employee.company = company
                    })
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch let jsonErr {
                        print(jsonErr)
                    }
                    
                })
            } catch let jsonDecodeError {
                print("Failed to decode: ", jsonDecodeError)
            }
            
        }.resume()
    }
    
}

struct JSONCompany: Decodable {
    let name: String
    let founded: String
    var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let birthday: String
    let type: String
}














