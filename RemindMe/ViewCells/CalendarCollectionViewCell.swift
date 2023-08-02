//
//  CalendarCollectionViewCell.swift
//  RemindMe
//
//  Created by VM on 17/07/23.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    static let identifier = "CalendarCollectionViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var isDate:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 4
        // Initialization code
    }
    
    func configure(title:String, isSelected: Bool, isWeekDays: Bool) {
        titleLabel.text = ""
        self.isSelected(isSelected)
          
        if isWeekDays || title.isEmpty{
            titleLabel.textColor = .gray
            isDate = false
        } else{
            isDate = true
        }
        
        titleLabel.text = title
    }
    
    func isSelected(_ status: Bool){
        if status{
            contentView.backgroundColor = .blue
            contentView.layer.opacity = 0.6
            titleLabel.textColor = .white
        } else{
            contentView.backgroundColor = .clear
            contentView.layer.opacity = 1
            titleLabel.textColor = .black
        }
    }
    
    static func nib() -> UINib{
        return UINib(nibName: CalendarCollectionViewCell.identifier, bundle: nil)
    }
    
}
