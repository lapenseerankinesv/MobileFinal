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
        var name:String = "___"
        var time:String = "___"
    }
    
    var names = [Score(), Score(), Score(), Score(), Score(), Score(), Score(), Score(), Score(), Score()]
    
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
        
        var flag = false
        for i in 0...9 {
            if names[i].name == "---" {
                flag = true
                let newEntity = NSEntityDescription.insertNewObject(forEntityName: entName, into: dataManager)
                newEntity.setValue(getName, forKey: "username")
                newEntity.setValue(getTime, forKey: "timing")
                do {
                    try self.dataManager.save()
                    listArray.append(newEntity)
                } catch {
                    print("Error saving data")
                }
                break
            }
        }
        names = names.sorted(by: { $0.time < $1.time })
        if flag == false {
            if getTime < names[9].time {
                for item in listArray {
                    if item.value(forKey: "username") as! String == names[9].name && item.value(forKey: "timing") as! String == names[9].time {
                        dataManager.delete(item)
                        break
                    }
                }
            }
            do {
                try self.dataManager.save()
                let newEntity = NSEntityDescription.insertNewObject(forEntityName: entName, into: dataManager)
                newEntity.setValue(getName, forKey: "username")
                newEntity.setValue(getTime, forKey: "timing")
                listArray.append(newEntity)
            } catch {
                print("Error deleting data")
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
                names[i].name = uName
                names[i].time = uScore
                i += 1
            }
        } catch {
            print("Error retriving data")
        }
        names = names.sorted(by: { $0.time < $1.time })
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
            cell = UITableViewCell(style:UITableViewCell.CellStyle.value1,
                                   reuseIdentifier: cellID)
        }
        
        let num = 10
        
        var tempName = names[indexPath.row].name
        if tempName.count > num {
            tempName = String(tempName.dropLast(tempName.count-num))
        }
        
        cell?.textLabel?.text = "\(tempName)"
        cell?.detailTextLabel?.text = "\(names[indexPath.row].time)"
        //cell?.textLabel?.text = String(format: "%s%-10s", "\(names[indexPath.row])", "\(times[indexPath.row])")
        return cell!
    }
    
}
