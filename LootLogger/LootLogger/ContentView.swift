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

class Item: Equatable{
    static func ==(lhs: Item, rhs, rhs: Item)-> Bool{
        return lhs.name == rhs.name
        && lhs.serialNumber == rhs.serialNumber
        && lhs.valueInDollars == rhs.valueInDollars
        && lhs.dateCreated == rhs.dateCreated }
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

override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: Indexpath) {
    if editingStyle == .delete{
        let item = itemStore.allItems[indexpath.row]
        itemStore.removeItem(item)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
    itemStore.moveItem(from: sourceIndexPath.row, to: destinaitonIndexPath.row)
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: indexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
    let item = itemStore.allItems[indexPath.row]
    
    cell.textLabel?.text = item.name
    cell.detailTextLabel?.text = "$\(item.valueInDollars)"
    
    return cell
}

@IBAction func addNewItem(_ sender: UIButton){
    let newItem = itemStore.createItem()
    
    if let index = itemStore.allItems.firstIndex(of: newItem){
        let indexPath = IndexPath(row: index, section: 0)
    }
    
    tableView.insertRows(at: [indexPath], with: .automatic)
}

@IBAction func toggleEditingMode(_ sender: UIButton){
    if isEditing{
        sender.setTitle("Edit", for: .normal)
        setEditing(false, animated:true)
    }else{
        sender.setTitle("Done", for: .normal)
        setEditing(true, animated:true)
    }
}

func removeItem(_ item: Item){
    if let index = allItems.firstIndex(of: item){
        allItems.remove(at: index)
    }
}

func moveItem(from fromIndex: Int, to toIndex: Int){
    if fromIndex == toIndex{
        return
    }
    
    let movedItem = allItems[fromIndex]
    
    allItems.remove(at: fromIndex)
    
    allItems.insert(movedItem, at: toIndex)
}
