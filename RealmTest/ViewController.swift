//
//  ViewController.swift
//  RealmTest
//
//  Created by DONGHYUN KIM on 2022/03/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var todoDetailView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var statusSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        thumbImageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        thumbImageView.layer.masksToBounds = true
        thumbImageView.contentMode = .scaleToFill
        thumbImageView.layer.borderWidth = 1
        
        self.tableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: "todoTableViewCell")
        
        TodoManager.shared.loadTodos()
        
    }
    
    @IBAction func addTodoAction(_ sender: Any) {
        let newTodo = Todo()
        newTodo.title = titleTextField.text!
        newTodo.isDone = statusSwitch.isOn
        
        _ = TodoManager.shared.addTodo(newTodo)
        
        updateTabale()
    }
    
    @IBAction func updateTodoAction(_ sender: Any) {
        
    }
    
    @IBAction func deleteTodoAction(_ sender: Any) {
        
    }
    
    func updateTabale() {
        TodoManager.shared.loadTodos()
        
        tableView.reloadData()
    }
    
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoManager.shared.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoTableViewCell", for: indexPath) as? TodoTableViewCell else { return UITableViewCell()}
        
        return cell
    }
    
    
}

