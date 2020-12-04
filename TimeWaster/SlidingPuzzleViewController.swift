//
//  SlidingPuzzleViewController.swift
//  TimeWaster
//
//  Created by user180525 on 12/3/20.
//

import UIKit

class SlidingPuzzleViewController: UIViewController {

    var name = "___"
    var time = 0
    var diff = 3
    @IBOutlet weak var difficultyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        difficultyLabel.text = String(diff) + " x " + String(diff) + " Puzzle"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SlidingScoresViewController
        nextVC.navigationItem.title = "Sliding High Scores"
        nextVC.getDiff = self.diff
        nextVC.getTime = self.time
        nextVC.getName = self.name
    }
    
    @IBAction func winGame(_ sender: UIButton) {
        let alert = UIAlertController(title: "You Won!", message: "Congratulations!\nEnter your name to see if you rank in the top 5.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Enter Name"
        })
        let okAction = UIAlertAction(title: "Enter", style: .default, handler: { action -> Void in
            let savedText = alert.textFields![0] as UITextField
            self.name = savedText.text ?? ""
            self.gotto()
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func gotto() {
        performSegue(withIdentifier: "slidingScoresLink", sender: self)
    }
    
    @IBAction func showHighScores(_ sender: UIButton) {
        performSegue(withIdentifier: "slidingScoresLink", sender: self)
    }
    
}
