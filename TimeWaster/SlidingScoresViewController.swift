//
//  SlidingScoresViewController.swift
//  TimeWaster
//
//  Created by user180525 on 12/3/20.
//

import UIKit

class SlidingScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scoresTable: UITableView!
    @IBOutlet weak var difficultly: UILabel!
    let cellID = "cellID"
    var getDiff = 5
    var getTime = -1
    var getName = ""
    var names = ["---", "---", "---", "---", "---"]
    var times = [Int.max, Int.max, Int.max, Int.max, Int.max]

    @IBOutlet weak var difficultyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        difficultly.text = "Difficulty: " + String(getDiff)
        scoresTable.dataSource = self
        scoresTable.delegate = self
        
        if getName != "___" {
            for i in 0...4 {
                if names[i] == "---" {
                    names[i] = getName
                    times[i] = getTime
                    break
                }
            }
        }
        // Do any additional setup after loading the view.
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
        let temp = times[indexPath.row]
        var str = String(temp)
        if temp == Int.max {
            str = "---"
        }
        cell?.textLabel?.text = names[indexPath.row] + "\t" + str
        return cell!
    }
    
}
