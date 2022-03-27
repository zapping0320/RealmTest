//
//  TodoManager.swift
//  RealmTest
//
//  Created by DONGHYUN KIM on 2022/03/22.
//

import RealmSwift

class TodoManager {
    
    static let shared = TodoManager()
    
    static private var lastId: Int = 0
    
    public var todos: [Todo] = []
    
    init() {
        setRealmInfo()
        
        loadTodos()
        
    }
    
    func setRealmInfo() {
        print("default = \(Realm.Configuration.defaultConfiguration.fileURL!)")//only for simulator
        
//        guard var fileURL = FileManager.default
//            .containerURL(forSecurityApplicationGroupIdentifier: "group.zenoTeam.AntFootPrint") else {
//                print("Container URL is nil")
//                return
//        }
//
//        fileURL.appendPathComponent("shared.realm")
//
//        let defualtUrl = Realm.Configuration.defaultConfiguration.fileURL!.path
//        if FileManager.default.fileExists(atPath: defualtUrl) {
//            do {
//                if FileManager.default.fileExists(atPath: fileURL.path) {
//                    print(fileURL.absoluteString)
//                    do
//                    {
//                    try FileManager.default.removeItem(atPath: fileURL.path)
//                    }
//                    catch {
//                        print("failed to delete default realm file")
//                        // Tell Realm to use this new configuration object for the default Realm
//                        Realm.Configuration.defaultConfiguration = getDefaultRealmConfig(fileURL)
//                        return
//                    }
//
//                }
//
//                try FileManager.default.moveItem(atPath: defualtUrl, toPath: fileURL.path)
//            }
//            catch {
//                print("failed to move realm file")
//                // Tell Realm to use this new configuration object for the default Realm
//                Realm.Configuration.defaultConfiguration = getDefaultRealmConfig(fileURL)
//                return
//            }
//        }
      
 //       Realm.Configuration.defaultConfiguration = getDefaultRealmConfig(fileURL)
 //       print("shared = \(fileURL)")
        
    }
    
    func getDefaultRealmConfig(_ fileURL: URL? ) -> Realm.Configuration {
        if fileURL == nil {
            let config = Realm.Configuration(
                // Set the new schema version. This must be greater than the previously used
                // version (if you've never set a schema version before, the version is 0).
                schemaVersion: RealmDBSchema.currentVersion,
                // Set the block which will be called automatically when opening a Realm with
                // a schema version lower than the one set above
                migrationBlock: { migration, oldSchemaVersion in
                    // We haven’t migrated anything yet, so oldSchemaVersion == 0
                    if (oldSchemaVersion < RealmDBSchema.currentVersion  ) {
                        // Nothing to do!
                        // Realm will automatically detect new properties and removed properties
                        // And will update the schema on disk automatically
                    }
                })
            return config
        }
        else {
            let migratedConfig = Realm.Configuration(
                fileURL: fileURL!,
                schemaVersion: RealmDBSchema.currentVersion,
                migrationBlock: { migration, oldSchemaVersion in
                    // We haven’t migrated anything yet, so oldSchemaVersion == 0
                    if (oldSchemaVersion < RealmDBSchema.currentVersion) {
                        // Nothing to do!
                        // Realm will automatically detect new properties and removed properties
                        // And will update the schema on disk automatically
                    }
                }
            )
            return migratedConfig
            
        }
    }
    
    
    
    func loadTodos() {
        todos = []
        
        let realm = try! Realm()
        
        let loadedTodos = realm.objects(Todo.self).sorted(byKeyPath: "id", ascending: false)
        
        for todo in loadedTodos {
            if todo.deletedDate != nil {
                continue
            }
            todos.append(todo)
        }
        
    }
    
    func addTodo(_ newTodo: Todo) -> Int {
        let realm = try! Realm()
        
        let newid = (realm.objects(Todo.self).max(ofProperty: "id") as Int? ?? 0) + 1
        newTodo.id = newid
        
        try! realm.write {
            realm.add(newTodo)
        }
        
        todos.append(newTodo)
        
        return newid
    }
    
    func deleteTodo(_ todo: Todo) {
       
        let realm = try! Realm()
        
        try! realm.write {
            //delete todo
            let predicate = NSPredicate(format: "id = %@",  NSNumber(value: todo.id))
            guard let targetTodo = realm.objects(Todo.self).filter(predicate).first else { return }
            realm.delete(targetTodo)
        }
        
        loadTodos()
        
    }
    
    func updateTodo(_ updatedTodo: Todo) {
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "id = %@",  NSNumber(value: updatedTodo.id))
        guard let orignalTodo = realm.objects(Todo.self).filter(predicate).first else { return }
        
        
        try! realm.write {
            orignalTodo.isDone = updatedTodo.isDone
            orignalTodo.title = updatedTodo.title
            orignalTodo.updatedDate = Date()
            
        }
    }
   
    
    func getTodo(_ id: Int) -> Todo {
        if id < 1 {
            return Todo()
        }
        
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "id = %@",  NSNumber(value: id))
        guard let todo = realm.objects(Todo.self).filter(predicate).first else { return Todo()}
        
        return todo
    }
}
