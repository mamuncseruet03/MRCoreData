//
//  ViewController.swift
//  MRCoreData
//
//  Created by Mamun Ar Rashid on 7/23/17.
//  Copyright © 2017 Fantasy Apps. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBAction func clicked(_ sender: UIButton) {
        
        if let context = MRCoreData.defaultStore?.backgroundTheadSaveContext() {
            let task = Task(context: context)
            task.taskName = "m16"
            context.performAndWait({
                try! context.save()
            })
        }
        
        let predicate: NSPredicate = NSPredicate(format:"taskName = %@", argumentArray: ["m16"] )
        if  let result:[Task] = MRCoreData.defaultStore?.selectAll(where: predicate) {
          print(result.first?.taskName)
            
        }
        
    }
    
    @IBAction func getclicked(_ sender: UIButton) {
        
        let predicate: NSPredicate = NSPredicate(format: "taskName = %@", argumentArray: ["m16"])
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        fetchRequest.predicate = predicate
        
        let result = try! MRCoreData.defaultStore?.getNewBackgroundTheadContext().fetch(fetchRequest) as? [Task]
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
           let _ = try MRCoreData.makeAndGetStore(dataModelName: "MRTodo")
        } catch let error {
            switch error {
            case MRCoreDataError.creationError(let message):
            print(message)
            default: break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

