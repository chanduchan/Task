//
//  NoteCell.swift
//  FrostAssignment
//
//  Created by Chandrasekhar K on 01/02/20.
//  Copyright © 2020 Chandrasekhar K. All rights reserved.
//

import UIKit
import CoreData


class NoteCell: UITableViewCell {
    
    @IBOutlet weak var imageObj: UIImageView!
    @IBOutlet weak var dateLabelObj: UILabel!
    @IBOutlet weak var titleLabelObj: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageObj.clipsToBounds = true
        imageObj.layer.cornerRadius = imageObj.bounds.size.height/2
    }
    
    
    func configureWithItem(item: NSManagedObject) {
        titleLabelObj?.text = item.value(forKeyPath: "title") as? String ?? ""
        descriptionLabel?.text = item.value(forKeyPath: "descriptions") as? String ?? ""
        
        if let inmage = item.value(forKeyPath: "image") as? Data{
            imageObj.image = UIImage(data: inmage)
        }else{
            imageObj.image = UIImage(named: "placeholder")
        }
        
        let date = item.value(forKeyPath: "date") as? Date ?? Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy h:mm aa"
        let finalStr = formatter.string(from: yourDate!)
        dateLabelObj.text = "Created at: \(finalStr)"
        
    }
    
}
