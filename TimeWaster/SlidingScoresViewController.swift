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
    
    struct Score {
        var name:String = "---"
        var time:String = "---"
    }
    
    var names = [Score(), Score(), Score(), Score(), Score()]
    
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
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: entName, into: dataManager)
        newEntity.setValue(getName, forKey: "username")
        newEntity.setValue(getTime, forKey: "timing")
        var flag = false
        for i in 0...4 {
            if names[i].name == "---" {
                flag = true
                names[i].name = getName
                times[i].time = getTime
                do {
                    try self.dataManager.save()
                    listArray.append(newEntity)
                } catch {
                    print("Error saving data")
                }
                break
            }
        }
        names.sorted(by: { $0.time < $1.time })
        if !flag {
            if getTime < names[4].time {
                for item in listArray {
                    if item.value(forKey: "username") as! String == names[4].name && item.value(forKey: "timing") as! String == names[4].time {
                        dataManager.delete(item)
                        names[4].name = getName
                        names[4].time = getTime
                        break
                    }
                }
            }
            do {
                try self.dataManager.save()
                listArray.append(newEntity)
            } catch {
                print("Error deleting data")
            }
            names.sorted(by: { $0.time < $1.time })
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
                names[i].name = uName
                names[i].time = uScore
                i += 1
            }
        } catch {
            print("Error retriving data")
        }
        names.sorted(by: { $0.time < $1.time })
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
        
        let num = 10
        
        var tempName = names[indexPath.row]
        if tempName.count > 10 {
            tempName = String(name.dropLast(name.count-10))
        }
        else if tempName.count < 10 {
            for _ in 1...10-tempName.count {
                tempName += " "
        }
        cell?.textLabel?.text = "\(tempName)  \(times[indexPath.row])"
        //cell?.textLabel?.text = String(format: "%s%-10s", "\(names[indexPath.row])", "\(times[indexPath.row])")
        return cell!
    }
    
}
