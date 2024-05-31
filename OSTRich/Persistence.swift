//
//  Persistence.swift
//  OSTRich
//
//  Created by snow on 5/31/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init?(inMemory: Bool = false) {
        let storageName = "OSTRich"
        container = NSPersistentContainer(name: storageName)
        
        // 1
        guard let storeLocation = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.net.snowskeleton.OSTRich")?
            .appendingPathComponent("\(storageName).sqlite") else {
            return nil
        }
        // 2
        let description = NSPersistentStoreDescription(url: storeLocation)
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        // 3
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            guard error == nil else {
                assertionFailure("Persistent store '\(storeDescription)' failed loading: \(String(describing: error))")
                return
            }
        })
        
        // uncomment this to wipe the coredata container on next launch
        //        do {
        //            try container.persistentStoreCoordinator.destroyPersistentStore(at: container.persistentStoreDescriptions.first!.url!, type: .sqlite, options: nil)
        //            print("Success")
        //        } catch {
        //
        //            print(error.localizedDescription)
        //            print("Fail")
        //        }
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
