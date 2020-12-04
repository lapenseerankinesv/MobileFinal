//
//  ViewController.swift
//  TimeWaster
//
//  Created by user180525 on 12/3/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func slidingPuzzleButton(_ sender: UIButton) {
        performSegue(withIdentifier: "slidingLink", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SlidingPuzzleViewController
        nextVC.navigationItem.title = "Silding Puzzle"
    }
    
}

