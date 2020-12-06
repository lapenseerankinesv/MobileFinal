//
//  SlidingScoresViewController.swift
//  TimeWaster
//
//  Created by user180525 on 12/3/20.
//

import UIKit
import Foundation
import CoreData

class SlidingScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scoresTable: UITableView!
    @IBOutlet weak var difficultly: UILabel!
    
    var dataManager : NSManagedObjectContext!
    let cellID = "cellID"
    var getDiff = 5
    var getTime = ""
    var getName = ""
    var won = false
    var names = ["---", "---", "---", "---", "---"]
    var times = ["---", "---", "---", "---", "---"]
    
    var listArray = [NSManagedObject]()

    @IBOutlet weak var difficultyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        difficultly.text = "Difficulty: \(getDiff)"
        scoresTable.dataSource = self
        scoresTable.delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.persistentContainer.viewContext
        fetchData()
        if won {
            addAndSave()
        }
        // Do any additional setup after loading the view.
    }
    
    func addAndSave() {
        let entName = "Score\(self.getDiff)"
        for i in 0...4 {
            if names[i] == "---" {
                names[i] = getName
                times[i] = getTime
                let newEntity = NSEntityDescription.insertNewObject(forEntityName: entName, into: dataManager)
                newEntity.setValue(getName, forKey: "username")
                newEntity.setValue(times[i], forKey: "timing")
                do {
                    try self.dataManager.save()
                    listArray.append(newEntity)
                } catch {
                    print("Error saving data")
                }
                break
            }
        }
        fetchData()
    }
    
    func fetchData() {
        let entName = "Score\(self.getDiff)"
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entName)
        do {
            let result = try dataManager.fetch(fetchRequest)
            listArray = result as! [NSManagedObject]
            var i = 0
            for item in listArray {
                let uName = item.value(forKey: "username") as! String
                let uScore = item.value(forKey: "timing") as! String
                names[i] = uName
                times[i] = uScore
                i += 1
            }
        } catch {
            print("Error retriving data")
        }
    }

    @IBAction func playSlidingAgain(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = scoresTable.dequeueReusableCell(withIdentifier: cellID)
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCell.CellStyle.default,
                                   reuseIdentifier: cellID)
        }
        
        var tempName = names[indexPath.row]
        if tempName.count > 10 {
            tempName = String(name.dropLast(name.count-10))
        }
        cell?.textLabel?.text = "\(tempName)  \(times[indexPath.row])"
        //cell?.textLabel?.text = String(format: "%s%-10s", "\(names[indexPath.row])", "\(times[indexPath.row])")
        return cell!
    }
    
}
