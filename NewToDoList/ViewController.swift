//
//  ViewController.swift
//  NewToDoList
//
//  Created by Mehmet Ekşi on 17.08.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
    private var models = [ToDoListItem]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To Do List"
        view.addSubview(tableView)
        getAlItems()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        // Do any additional setup after loading the view.
    }
    
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "New Item", message: "Enter a new ıtem", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
                return
            }
            self?.createItem(name: text)
        }))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = model.name
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let stringDate = dateFormatter.string(from: date)

        
        cell.textLabel?.text = model.name
        cell.detailTextLabel?.text = stringDate
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler:{ _ in
        
        let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?.first?.text = item.name
        alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else{
                return
            }
            self?.updateItem(item: item, newName: newName)
        }))
        self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in self?.deleteItem(item: item)}))
        present(sheet, animated: true)
    }
    
    //Core Data
    func getAlItems(){
        do{
            models = try contex.fetch(ToDoListItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch{
            print("Error")
        }
    }
    
    func createItem(name: String){
        let newItem = ToDoListItem(context: contex)
        newItem.name = name
        newItem.createdAt = Date()
        
        do{
            try contex.save()
            getAlItems()
        }catch{
            print("Error")
        }
    }
    
    func deleteItem(item: ToDoListItem) {
        contex.delete(item)
        
        do{
            try contex.save()
            getAlItems()
        }catch{
            print("Error")
        }
        
    }
    
    func updateItem(item: ToDoListItem, newName: String) {
        item.name = newName
        
        do{
            try contex.save()
            getAlItems()
        }catch{
            print("Error")
        }
    }
    
    
}



