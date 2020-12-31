//
//  ViewController.swift
//  Learning Core Data
//
//  Created by Francisco De Freitas on 29/12/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    var items: [Person]?
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
        
    }
    
    private func fetchData() {
        
        do {
            items = try context?.fetch(Person.fetchRequest())
        } catch {
            print("Error al extraer los datos")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    @IBAction func buttonAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Agregar", message: "Escribe algo", preferredStyle: .alert)
        
        alert.addTextField()
        
        let submit = UIAlertAction(title: "Grabar", style: .default) { (action) in
            
            let textField = alert.textFields![0]
            
            let newPerson = Person(context: self.context!)
            newPerson.name = textField.text!
            newPerson.age = 20
            
            do {
                try self.context?.save()
            } catch {
                print("Error al ingresar usuario")
            }
            
            self.fetchData()
            
        }
        
        alert.addAction(submit)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
}

// MARK:- UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Agregar", message: "Escribe algo", preferredStyle: .alert)
        
        alert.addTextField()
        
        let person = items?[indexPath.row]
        let textField = alert.textFields![0]
        textField.text = person?.name
        
        let submit = UIAlertAction(title: "Grabar", style: .default) { (action) in
            
            person?.name = textField.text!
            
            do {
                try self.context?.save()
            } catch {
                print("Error al ingresar usuario")
            }
            
            self.fetchData()
            
            self.fetchData()
            
        }
        
        alert.addAction(submit)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Borrar") { (action, view, completion) in
            
            let person = self.items?[indexPath.row]
            self.context?.delete(person!)
            
            do {
                try self.context?.save()
            } catch {
                print("Error al ingresar usuario")
            }
            
            self.fetchData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

// MARK:- UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = items?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewCell", for: indexPath)
        cell.textLabel?.text = person?.name
        
        return cell
    }
    
    
}

