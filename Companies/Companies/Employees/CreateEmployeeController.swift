//
//  CreateEmployeeController.swift
//  Companies
//
//  Created by Jeff Kral on 12/11/17.
//  Copyright © 2017 Jeff Kral. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    var company: Company?
    
    var delegate: CreateEmployeeControllerDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "MM/DD/YYYY"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkBlue
        
        navigationItem.title = "Create Employee"
        setupCancelButtonInNavBar()
       
        
        setupUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc private func handleSave() {
        
        guard let employeeName = nameTextField.text else { return }
        guard let company = self.company  else { return }
        guard let birthdayText = birthdayTextField.text else { return }
        
        if birthdayText.isEmpty {
            showError(title: "Blank Birthday", message: "Please enter birthday")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
            showError(title: "Invalid Date", message: "Please enter birthday as MM,dd,yyyy")
            return
        }
        
        guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else { return }
        print(employeeType)
        
        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, employeeType: employeeType, birthday: birthdayDate, company: company)
        
        if let error = tuple.1 {
            print(error)
        } else {
            dismiss(animated: true, completion: {
                self.delegate?.didAddEmployee(employee: tuple.0!)
            })
        }
        
    }
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    let employeeTypeSegmentedControl: UISegmentedControl = {
        
        let types = [EmployeeType.Executive.rawValue, EmployeeType.SeniorManagement.rawValue, EmployeeType.Staff.rawValue, EmployeeType.Intern.rawValue]
        
        let sc = UISegmentedControl(items: types)
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.darkBlue
        return sc
    }()
    
    
    private func setupUI() {
        
        _ = setupLightBlueBackgroundView(height: 150)
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        
        view.addSubview(birthdayLabel)
        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(birthdayTextField)
        birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor).isActive = true
        birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
        birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true
        
        view.addSubview(employeeTypeSegmentedControl)
        employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthdayTextField.bottomAnchor, constant: 0).isActive = true
        employeeTypeSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        employeeTypeSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        employeeTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
       
    }
}















