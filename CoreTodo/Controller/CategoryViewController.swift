//
//  CategoryViewController.swift
//  CoreTodo
//
//  Created by Jonathan Hernandez on 12/23/17.
//  Copyright © 2017 Jonathan Hernandez. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    var categories = [Category]()
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }
    //MARK: - Table DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    //MARK: - Data MAnipulation Methods
    func saveCategories()  {
    
        do{
            try context.save()
        }catch{
            print("Error Encoding Item Array : \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories()  {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        }catch {
            print("Error fetch request \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Add New Caegories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Agregar Nueva Categoria", message: "", preferredStyle: .alert)
        let  actition = UIAlertAction(title: "Agregar", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveCategories()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Crear Nuevo Item"
            textField = alertTextField
        }
        alert.addAction(actition)
        present(alert, animated: true, completion: nil)
        
    }
    

}
