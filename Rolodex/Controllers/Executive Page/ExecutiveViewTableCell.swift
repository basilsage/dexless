//
//  ExecutiveViewTableCell.swift
//  Rolodex
//
//  Created by DJ Satoda on 6/11/21.
//  Copyright © 2021 DJ Satoda. All rights reserved.
//

import Foundation
import UIKit

class ExecutiveViewTableCell: UITableViewCell {

    //MARK: UI Elements
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let dueDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.rgb(red: 253, green: 118, blue:  67)
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    //MARK: Init Methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let frameWidth : CGFloat = UIScreen.main.bounds.width
        
        addSubview(nameLabel)
        nameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 0, width: frameWidth, height: 0)
        
        addSubview(dueDateLabel)
        dueDateLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 20, width: frameWidth, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
