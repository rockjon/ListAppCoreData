//
//  CategoryViewController.swift
//  CoreTodo
//
//  Created by Jonathan Hernandez on 12/23/17.
//  Copyright © 2017 Jonathan Hernandez. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categories: Results<Category>?
    //var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }
    //MARK: - Table DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No has agregado categorias"
        
        return cell
    }
    
    //MARK: - Table Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data MAnipulation Methods
 /*func saveCategories()  {
    
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
 */
    func save(category: Category)  {
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error Encoding Item Array : \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories()  {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    // MARK: - Add New Caegories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Agregar Nueva Categoria", message: "", preferredStyle: .alert)
        let  actition = UIAlertAction(title: "Agregar", style: .default) { (action) in
            
            //let newCategory = Category(context: self.context)
            let newCategory = Category()
            newCategory.name = textField.text!
            
            //self.categories.append(newCategory)
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.save(category: newCategory)
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Crear Nuevo Item"
            textField = alertTextField
        }
        alert.addAction(actition)
        present(alert, animated: true, completion: nil)
        
    }
    

}
