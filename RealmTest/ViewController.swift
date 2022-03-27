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
            let uuid = UUID().uuidString
            saveImageToDocumentDirectory(imageName: uuid + ".jpg", image: thumbImageView.image!)
            newTodo.imageUUID = uuid
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
    }
    
    func updateDetailView() {
        guard let todo = currentTodo else {
            return
        }
        
        titleTextField.text = todo.title
        statusSwitch.isOn = todo.isDone
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
    
    func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
            // 1. 이미지를 저장할 경로를 설정해줘야함 - 도큐먼트 폴더,File 관련된건 Filemanager가 관리함(싱글톤 패턴)
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            
            // 2. 이미지 파일 이름 & 최종 경로 설정
            let imageURL = documentDirectory.appendingPathComponent(imageName)
            
            // 3. 이미지 압축(image.pngData())
            // 압축할거면 jpegData로~(0~1 사이 값)
            guard let data = image.pngData() else {
                print("압축이 실패했습니다.")
                return
            }
            
            // 4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기하는 경우
            // 4-1. 이미지 경로 여부 확인
            if FileManager.default.fileExists(atPath: imageURL.path) {
                // 4-2. 이미지가 존재한다면 기존 경로에 있는 이미지 삭제
                do {
                    try FileManager.default.removeItem(at: imageURL)
                    print("이미지 삭제 완료")
                } catch {
                    print("이미지를 삭제하지 못했습니다.")
                }
            }
            
            // 5. 이미지를 도큐먼트에 저장
            // 파일을 저장하는 등의 행위는 조심스러워야하기 때문에 do try catch 문을 사용하는 편임
            do {
                try data.write(to: imageURL)
                print("이미지 저장완료")
            } catch {
                print("이미지를 저장하지 못했습니다.")
            }
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
