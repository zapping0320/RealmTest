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
    
    private var currentTodo:Todo?
    private var updateImageView:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        thumbImageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        thumbImageView.layer.masksToBounds = true
        thumbImageView.contentMode = .scaleToFill
        thumbImageView.layer.borderWidth = 1
        
        thumbImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickProfileImage)))
        thumbImageView.isUserInteractionEnabled = true
        
        self.tableView.register(UINib(nibName: "TodoTableViewCell", bundle: nil), forCellReuseIdentifier: "todoTableViewCell")
        
        TodoManager.shared.loadTodos()
        
    }
    
    @IBAction func addTodoAction(_ sender: Any) {
        let newTodo = Todo()
        newTodo.title = titleTextField.text!
        newTodo.isDone = statusSwitch.isOn
        
        if updateImageView == true {
            newTodo.imageUUID = UUID().uuidString
            SaveImageHelper.saveImageToDocumentDirectory(imageName: newTodo.getImageName(), image: thumbImageView.image!)
        }
        
        _ = TodoManager.shared.addTodo(newTodo)
        
        updateTabale()
    }
    
    @IBAction func updateTodoAction(_ sender: Any) {
        guard let todo = currentTodo else {
            popupMessage("", "todo를 선택해주세요.")
            return
        }
        
        let updatedTodo = Todo()
        updatedTodo.id = todo.id
        updatedTodo.title = titleTextField.text!
        updatedTodo.isDone = statusSwitch.isOn
        
        TodoManager.shared.updateTodo(updatedTodo)
        
        currentTodo = updatedTodo
        
        updateTabale()
        
    }
    
    @IBAction func deleteTodoAction(_ sender: Any) {
        guard let todo = currentTodo else {
            popupMessage("", "todo를 선택해주세요.")
            return
        }
        
        if todo.getImageName().isEmpty == false {
            SaveImageHelper.deleteImageFromDocumentDirectory(imageName: todo.getImageName())
        }
        
        TodoManager.shared.deleteTodo(todo)
        
        updateTabale()
        
        initDetailView()
    }
    
    func updateTabale() {
        TodoManager.shared.loadTodos()
        
        tableView.reloadData()
    }
    
    func initDetailView() {
        titleTextField.text = ""
        statusSwitch.isOn = false
        thumbImageView.image = UIImage(named: "PillDefault")
    }
    
    func updateDetailView() {
        guard let todo = currentTodo else {
            return
        }
        
        initDetailView()
        
        titleTextField.text = todo.title
        statusSwitch.isOn = todo.isDone
        
        if todo.getImageName().isEmpty == false {
            guard let imageData = SaveImageHelper.loadImageFromDocumentDirectory(imageName: todo.getImageName()) else { return }
            thumbImageView.image = imageData
        }
    }
    
    func popupMessage(_ title:String, _ message:String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인",
                                          style: .default, handler: {result in
                                           
                                          })
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func pickProfileImage() {
        self.pickImage()
    }
    
    func pickImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion:  nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        updateImageView = true
        thumbImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodoManager.shared.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoTableViewCell", for: indexPath) as? TodoTableViewCell else { return UITableViewCell()}
        
        let current = TodoManager.shared.todos[indexPath.row]
        
        cell.updateUI(current)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.currentTodo = TodoManager.shared.todos[indexPath.row]
        
        updateDetailView()
    }
    
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
