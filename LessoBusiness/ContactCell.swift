//
//  ContactCell.swift
//  LessoBusiness
//
//  Created by 罗伟聪 on 15/11/18.
//  Copyright © 2015年 LESSO. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    //@IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactTextLabel: UILabel!
    @IBOutlet weak var contactDetailTextLabel: UILabel!
    @IBOutlet weak var contactContentView: UIView!
    @IBOutlet weak var contactInitialLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //contactContentView.layer.masksToBounds = true
        contactContentView.layer.cornerRadius = contactContentView.frame.size.width/2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateInitialsColorForIndexPath(indexpath:NSIndexPath){
        let colorArray = [Constants.Colors.amethystColor,Constants.Colors.asbestosColor,Constants.Colors.emeraldColor,Constants.Colors.peterRiverColor,Constants.Colors.pomegranateColor,Constants.Colors.pumpkinColor,Constants.Colors.sunflowerColor]
        let randomValue = (indexpath.row + indexpath.section) % colorArray.count
        contactInitialLabel.backgroundColor = colorArray[randomValue]
    }
    
    func updateContactsinUI(contact:Customer, indexPath: NSIndexPath, subtitleType:SubtitleCellValue){
        self.contactTextLabel.text = contact.name as String
        self.contactDetailTextLabel.text = contact.tel
        self.contactInitialLabel.text = contact.contactInitials()
        updateInitialsColorForIndexPath(indexPath)
        contactContentView.layer.cornerRadius = contactContentView.frame.size.width/2

        //self.contactImageView.hidden = true
    }
    
}


public enum SubtitleCellValue{
    case Phonenumer
    case Email
    case Address
}