//
//  ViewController.swift
//  Fitsmind
//
//  Created by Mamun Ar Rashid on 7/9/17.
//  Copyright © 2017 Fantasy Apps. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UISearchBarDelegate, SaveNotifiable {

    //MARK: Properties
    
    var tasks: [Task] = []
    @IBOutlet weak var taskListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var isAscending: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        taskListTableView.delegate = self
        taskListTableView.dataSource = self
        loadData()
        taskListTableView.cellLayoutMarginsFollowReadableWidth = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private Methods
    
    func loadData() {
        if let tasks:[Task] = MRCoreData.defaultStore?.selectAll()  {
            self.tasks = tasks
            self.taskListTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "addNewTask":
            if let taskControllerNav = segue.destination as? UINavigationController,let taskController = taskControllerNav.viewControllers.first as? SingleTaskViewController  {
                taskController.delegate = self
            }
        case "TaskDetail":
            if let taskControllerNav = segue.destination as? UINavigationController,let taskController = taskControllerNav.viewControllers.first as? SingleTaskViewController , let row = taskListTableView.indexPathForSelectedRow?.row  {
                taskController.delegate = self
                taskController.task = tasks[row]
            }
            
        default:
               break
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        loadData()
    }
    
    @IBAction func sortByDate(_ sender: UIBarButtonItem) {
        
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: isAscending)
        
        if let searchText = searchBar.text , !searchText.isEmpty {
            let predicate = NSPredicate(format:"taskName contains[c] %@",searchText)
            if let tasks:[Task] = MRCoreData.defaultStore?.selectAll(where: predicate,sortDescriptors: [sortDescriptor])  {
                self.tasks = tasks
            }
        } else {
            if let tasks:[Task] = MRCoreData.defaultStore?.selectAll(sortDescriptors: [sortDescriptor]) {
                self.tasks = tasks
            }
        }
        
        self.taskListTableView.reloadData()
        isAscending = !isAscending
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
        let predicate = NSPredicate(format:"taskName contains[c] %@",searchText)
            if let tasks:[Task] = MRCoreData.defaultStore?.selectAll(where: predicate) {
                self.tasks = tasks
            }
        } else {
            if let tasks:[Task] = MRCoreData.defaultStore?.selectAll() {
                self.tasks = tasks
            }
        }
        self.taskListTableView.reloadData()
    }
    
    func successfullySaved() {
      loadData()
    }

}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        if tasks.count >= indexPath.row {
        let task = tasks[indexPath.row]
            
        cell.nameLabel.text = task.taskName
        cell.nameLabel.textColor = UIColor.black
         
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        cell.dateLabel.text = dateFormatter.string(from: task.created)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //let deletedTask = tasks[indexPath.row]
            if let context = MRCoreData.defaultStore?.defaultDeleteContext() {
                let deleteTask = context.object(with: tasks[indexPath.row].objectID)
                context.delete(deleteTask)
                context.performAndWait({
                    try! context.save()
                    self.loadData()
                })
            }
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
        
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins))  {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if cell.responds(to: #selector(setter: UIView.layoutMargins))  {
            cell.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }
    }

}


