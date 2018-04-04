//
//  CompaniesController+CreateCompany.swift
//  Companies
//
//  Created by Jeff Kral on 12/10/17.
//  Copyright © 2017 Jeff Kral. All rights reserved.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegate {
    
    
    func didEditCompany(company: Company) {
        
        let row = companies.index(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    func didAddCompany(company: Company) {
        
        companies.append(company)
        
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    
    
    
    
}
