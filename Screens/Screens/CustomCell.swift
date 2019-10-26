//
//  CustomCell.swift
//  Screens
//
//  Created by Matthew Van Gorden on 10/25/19.
//  Copyright © 2019 Matthew Van Gorden. All rights reserved.
//

import Foundation
import UIKit

class CustomCell : UITableViewCell {
    
    var name : String?
    var score : Int?
    
    var nameView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var scoreView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(nameView)
        self.addSubview(scoreView)
        
        nameView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nameView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        nameView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        scoreView.leftAnchor.constraint(equalTo: self.nameView.rightAnchor).isActive = true
        scoreView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scoreView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        scoreView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let name = name {
            nameView.text = name
        }
        if let score = score {
            scoreView.text = String(score)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
