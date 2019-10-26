//
//  GameOverViewController.swift
//  Screens
//
//  Created by Matthew Van Gorden on 10/25/19.
//  Copyright © 2019 Matthew Van Gorden. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    var leaderboard = [CellData]()
    
    @IBOutlet weak var submit_button: UIButton!
    @IBOutlet weak var player_name: UITextField!
    @IBOutlet weak var score_num: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        score_num.text = String(score)
        
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "LEADERBOARD") {
            leaderboard = try! PropertyListDecoder().decode([CellData].self, from: data)
        }

        setupTextFields()
    }
    
    @IBAction func submitScore(_ sender: Any) {
        
        if(player_name.text == "") {
            return
        }
        
        let submission = CellData.init(name: player_name.text, score: score)
        
        leaderboard.append(submission)
        leaderboard.sort { (lhs: CellData, rhs: CellData) -> Bool in
            return lhs.score! > rhs.score!
        }
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(leaderboard), forKey: "LEADERBOARD")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(identifier: "Splash View Controller") as! SplashViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        player_name!.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
