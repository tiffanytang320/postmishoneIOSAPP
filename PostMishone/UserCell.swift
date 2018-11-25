//
//  UserCell.swift
//  PostMishone
//
//  Created by Tiffany Tang on 24/11/2018.
//  Copyright © 2018 Victor Liang. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // change frame of text label
        let textLabelRect = CGRect(origin: CGPoint(x: 75,y :textLabel!.frame.origin.y - 2), size: CGSize(width: textLabel!.frame.width, height: textLabel!.frame.height ))
        
        textLabel?.frame = textLabelRect
        
        let detailTextLabelRect = CGRect(origin: CGPoint(x: 75,y :detailTextLabel!.frame.origin.y + 2), size: CGSize(width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height ))
        
        detailTextLabel?.frame = detailTextLabelRect
        
        
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        // constraints
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
