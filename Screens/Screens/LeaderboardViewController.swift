//
//  LeaderboardViewController.swift
//  Screens
//
//  Created by Matthew Van Gorden on 10/25/19.
//  Copyright © 2019 Matthew Van Gorden. All rights reserved.
//

import UIKit

struct CellData : Codable {
    let name : String?
    let score : Int?
}

class LeaderboardViewController: UITableViewController  {
    
    var leaderboard = [CellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "LEADERBOARD") {
            leaderboard = try! PropertyListDecoder().decode([CellData].self, from: data)
        }
        
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: "custom")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboard.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom") as! CustomCell
        cell.name = leaderboard[indexPath.row].name
        cell.score = leaderboard[indexPath.row].score
        return cell
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .portrait
        }
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
