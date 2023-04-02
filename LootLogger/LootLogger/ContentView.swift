//
//  ContentView.swift
//  LootLogger
//
//  Created by Kayley Kennemer on 4/1/23.
//

import UIKit
class ItemViewcontroller: UITableViewController{
    var itemStore: ItemStore!
}
class ItemStore{
    var allItems = [Item]()
}

class Item {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    let dateCreated: Date
}

init( name: String, serialNumber: String?, valueInDollars: Int){
    self.name = name
    self.valueInDollars = valueInDollars
    self.serialNumber = serialNumber
    self.dateCreated = Date()
}

convenience init(random: Bool = false){
    if random{
        let adjectives = ["Fluffy", "Rusty", "Shiny"]
        let nouns = ["Bear", "Spork", "Mac"]
        
        let randomAdjective = adjectives.randomElement()!
        let randomNoun = nouns.randomElement()!
        
        let randomName = "\(randomAdjective) \(randomNoun)"
        let randomValue = Int.random(in: 0..<100)
        let randomSerialNumber = UUID().uuidString.components(separatedBy: "-").first!
        
        self.init(name: randomName, serialNumber: randomSerialNumber, valueInDollars: randomValue)
    }else{
        self.init(name: "", serialNumber: nil, valueInDollars: 0)
    }
}

@discardableResult func createItem() -> Item {
    let newItem = Item(random:true)
    allItems.append(newItem)
    return newItem
}

func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions){
    guard let _ = (scene as? UIWindowScene) else{return}
    
    let itemStore = ItemStore()
    let itemsController = window!.rootViewController as! ItemsViewController itemsController.itemStore = itemStore
}

init (){
    for _ in 0..<5 {
        createItem()
    }
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    return itemStore.allItems.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: indexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
    let item = itemStore.allItems[indexPath.row]
    
    cell.textLabel?.text = item.name
    cell.detailTextLabel?.text = "$\(item.valueInDollars)"
    
    return cell
}
