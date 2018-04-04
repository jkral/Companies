//
//  EmployeesController.swift
//  Companies
//
//  Created by Jeff Kral on 12/11/17.
//  Copyright © 2017 Jeff Kral. All rights reserved.
//

import UIKit
import CoreData

class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: customRect)
    }
}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate  {
    
    func didAddEmployee(employee: Employee) {
        
        guard let section = employeeTypes.index(of: employee.type!) else { return }
        
        let row = allEmployees[section].count
        
        let insertionIndexPath = IndexPath(row: row , section: section)
        
        allEmployees[section].append(employee)
        
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }
    
    var company: Company?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
      
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = IndentedLabel()
        label.backgroundColor = UIColor.lightBlue
        label.text = employeeTypes[section]
        label.textColor = UIColor.darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    var allEmployees = [[Employee]]()
    
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue,
        EmployeeType.Intern.rawValue
    ]
    
    private func fetchEmployees() {
        
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        
        allEmployees = []
        
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(companyEmployees.filter { $0.type == employeeType })
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    let cellId = "cellIddddddd"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        let employee = allEmployees[indexPath.section][indexPath.row]

        cell.textLabel?.text = employee.fullName
        
        if let birthday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            cell.textLabel?.text = "\(employee.fullName ?? "")    \(dateFormatter.string(from: birthday))"
        }
        
        cell.backgroundColor = UIColor.tealColor
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.darkBlue
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        
        fetchEmployees()
        
    }
    
    @objc private func handleAdd() {
       
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        present(navController, animated: true, completion: nil)
        
    }
    
    
}
