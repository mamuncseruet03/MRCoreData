//
//  SingleTaskController.swift
//  Fitsmind
//
//  Created by Mamun Ar Rashid on 7/9/17.
//  Copyright © 2017 Fantasy Apps. All rights reserved.
//

import UIKit

protocol SaveNotifiable: class {
    func successfullySaved()
}

class SingleTaskViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var task: Task?

    weak var delegate: SaveNotifiable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        navigationItem.title = "Task"

        if let task = task {
            nameTextField.text = task.taskName
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss()
    }
    
    func dismiss() {
        nameTextField.resignFirstResponder()
        if presentingViewController is UINavigationController {
            dismiss(animated: true, completion: nil)
        }
        else if let navController = navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func showMessage(title:String,message:String, isNeedDismiss: Bool = true) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default, handler:  { [weak self] action in
            if isNeedDismiss {
               self?.dismiss()
            }
        })
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        nameTextField.resignFirstResponder()
        
        if let nameText = nameTextField.text, !nameText.isEmpty {
        
            if let context = MRCoreData.defaultStore?.defaultSaveContext() {
               
                if let task = self.task {
                     self.task = context.object(with: task.objectID) as? Task
                } else {
                    self.task = Task(context: context)
                }
                
                self.task?.taskName = nameTextField.text!
                self.task?.created = Date()
                
                context.performAndWait({
                    try! context.save()
                    DispatchQueue.main.async {
                        self.delegate?.successfullySaved()
                        self.showMessage(title: "Success", message: "Successfully Saved")
                    }
                })
            }
        } else {
            showMessage(title: "Failled", message: "Please Insert Name", isNeedDismiss: false)
        }
        
 
    }
}
