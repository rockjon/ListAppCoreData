//
//  ViewController.swift
//  CoreTodo
//
//  Created by Jonathan Hernandez on 12/21/17.
//  Copyright © 2017 Jonathan Hernandez. All rights reserved.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController{

    var itemArray = [Item]()
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // print(dataFilePath!)
        
        // Do any additional setup after loading the view, typically from a nib.
//        if let items = defaults.array(forKey: "TodoListArray") as? [String]{
//            itemArray = items
//        }
//        let newItem = Item()
//        newItem.title = "Jonas"
//        itemArray.append(newItem)
        
       
        
        loadItems()
        
    }

    //MARK: - Table Data Sources
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Table Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
       
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }

    }

    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Agregarr Nuevo Item", message: "", preferredStyle: .alert)
        let  actition = UIAlertAction(title: "Agregar Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
           self.saveItems()
           
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Crear Nuevo Item"
            textField = alertTextField
        }
        alert.addAction(actition)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Functions Model Manipuation
    
    func saveItems()  {
        //let encoder = PropertyListEncoder()
        do{
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
            try context.save()
        }catch{
            print("Error Encoding Item Array : \(error)")
        }
         self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest())  {
        do{
            itemArray = try context.fetch(request)
        }catch {
            print("Error fetch request \(error)")
        }
        tableView.reloadData()
//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do{
//                itemArray = try decoder.decode([Item].self, from: data)
//            }catch {
//                print("Error decodig item Array:\(error)")
//            }
//        }
    }
    
}

extension TodoListViewController : UISearchBarDelegate {
    // MARK: - Search Bar Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate (format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

