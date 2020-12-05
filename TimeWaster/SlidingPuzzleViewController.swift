//
//  SlidingPuzzleViewController.swift
//  TimeWaster
//
//  Created by user180525 on 12/3/20.
//

import UIKit

class SlidingPuzzleViewController: UIViewController {

    var name = ""
    var won = false
    var time = 0
    var diff = 3
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    
    var timer:Timer = Timer()
    var timerCounting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        difficultyLabel.text = "\(diff) x \(diff) Puzzle"
    }
    
    @IBAction func startStopButtonTapped(_ sender: UIButton) {
        if (timerCounting) {
            timerCounting = false
            timer.invalidate()
            startStopButton.setTitle("START", for: .normal)
            startStopButton.setTitleColor(UIColor.blue, for: .normal)
        }
        else {
            timerCounting = true
            startStopButton.setTitle("STOP", for: .normal)
            startStopButton.setTitleColor(UIColor.red, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reset Game?", message: "Are you sure you want to restart from a new game?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) -> Void in
        })
        let okAction = UIAlertAction(title: "Reset", style: .default, handler: {(action) -> Void in
            self.time = 0
            self.timer.invalidate()
            self.timerCounting = false
            self.startStopButton.setTitle("START", for: .normal)
            self.startStopButton.setTitleColor(UIColor.blue, for: .normal)
            self.timerLabel.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)    }
    
    @objc func timerCounter() {
        time += 1
        let count = secondsToHoursMinutesSecond(seconds: time)
        let timeString = makeTimeString(hours: count.0, minutes: count.1, seconds: count.2)
        timerLabel.text = timeString    }
    
    func secondsToHoursMinutesSecond(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d",hours)
        timeString += ":"
        timeString += String(format: "%02d",minutes)
        timeString += ":"
        timeString += String(format: "%02d",seconds)
        return timeString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SlidingScoresViewController
        nextVC.navigationItem.title = "Sliding High Scores"
        nextVC.getDiff = self.diff
        let temp = self.secondsToHoursMinutesSecond(seconds: self.time)
        nextVC.getTime = self.makeTimeString(hours: temp.0, minutes: temp.1, seconds: temp.2)
        nextVC.getName = self.name
        nextVC.won = self.won
    }
    
    @IBAction func winGame(_ sender: UIButton) {
        if (timerCounting) {
            timerCounting = false
            timer.invalidate()
            startStopButton.setTitle("START", for: .normal)
            startStopButton.setTitleColor(UIColor.blue, for: .normal)
            
            let alert = UIAlertController(title: "You Won!", message: "Congratulations!\nEnter your name to see if you rank in the top 5.", preferredStyle: .alert)
            alert.addTextField(configurationHandler: {(textField) in
                textField.placeholder = "Enter Name"
            })
            let okAction = UIAlertAction(title: "Enter", style: .default, handler: { action -> Void in
                let savedText = alert.textFields![0] as UITextField
                self.name = savedText.text ?? ""
                self.won = true
                self.gotto()
            })
            alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    @IBAction func diffButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Choose Difficulty Setting", message: "Current Difficulty: \(self.diff)\n\n\n\n\n\n", preferredStyle: .alert)
        
        let stepper = UIStepper(frame:CGRect(x: 87, y: 100, width: 250, height: 80))
        stepper.maximumValue = 10
        stepper.minimumValue = 3
        stepper.stepValue = 1.0
        stepper.value = Double(diff)
        stepper.isContinuous = true
        
        let action2 = UIAction(title: "Change Message", handler: { (action) in
            alert.message = "Current Difficulty: \(Int(stepper.value))\n\n\n\n\n\n"
        })
        
        stepper.addAction(action2, for: .valueChanged)
        alert.view.addSubview(stepper)
        
        
        let sliderAction = UIAlertAction(title: "OK", style: .default, handler: { (result : UIAlertAction) -> Void in
            self.diff = Int(stepper.value)
            self.difficultyLabel.text = "\(self.diff) x \(self.diff) Puzzle"
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(sliderAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func gotto() {
        performSegue(withIdentifier: "slidingScoresLink", sender: self)
    }
    
    @IBAction func showHighScores(_ sender: UIButton) {
        self.won = false
        performSegue(withIdentifier: "slidingScoresLink", sender: self)
    }
    
}
