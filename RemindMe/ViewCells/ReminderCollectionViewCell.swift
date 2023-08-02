//
//  ReminderCollectionViewCell.swift
//  RemindMe
//
//  Created by VM on 22/07/23.
//

import UIKit

class ReminderCollectionViewCell: UICollectionViewCell {
    static let identifier = "ReminderCollectionViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var topStrip1: UIView!
    @IBOutlet weak var topDot1: UIImageView!
    @IBOutlet weak var topStrip2: UIView!
    @IBOutlet weak var bottomDot2: UIImageView!
    @IBOutlet weak var bottomStrip2: UIView!
    @IBOutlet weak var bottomStrip1: UIView!
    @IBOutlet weak var bottomDot1: UIImageView!
    @IBOutlet weak var topDot2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStrips()
        
        // Initialization code
    }
    fileprivate func setUpTile(_ index: Int, _ isLast: Bool) {
        let angle = 3.14/32
        if index.isMultiple(of: 2){
            contentView.transform = CGAffineTransform(rotationAngle: angle)
        } else{
            contentView.transform = CGAffineTransform(rotationAngle: -angle)
        }
        
        topDot1.isHidden = false
        topDot2.isHidden = false
        topStrip1.isHidden = false
        topStrip2.isHidden = false
        
        bottomDot1.isHidden = false
        bottomDot2.isHidden = false
        bottomStrip1.isHidden = false
        bottomStrip2.isHidden = false
        if index == 0{
            topDot1.isHidden = true
            topDot2.isHidden = true
            topStrip1.isHidden = true
            topStrip2.isHidden = true
        }
        if isLast{
            bottomDot1.isHidden = true
            bottomDot2.isHidden = true
            bottomStrip1.isHidden = true
            bottomStrip2.isHidden = true
        }
    }
    
    func configure(index:Int,isLast: Bool,reminder: ReminderModel){
        setUpTile(index, isLast)
        bindData(reminder)
    }
    
    private func bindData(_ reminder:ReminderModel){
        titleLabel.text = reminder.title
        detailLabel.text = reminder.detail
        dateLabel.text = " \(reminder.dateForRemind.getTimeInAMPM()) "
        if let priorityLabel = priorityView.subviews.first as? UILabel{
            priorityLabel.text = reminder.priority.rawValue
        }
        switch reminder.priority{
        case .LOW:
            priorityView.backgroundColor = .blue
            break
        case .NORMAL:
            priorityView.backgroundColor = .orange
            break
        case .HIGH:
            priorityView.backgroundColor = .systemRed
            break
        }
    }
    
   private func setupStrips(){
        contentView.subviews.first?.layer.cornerRadius = 20
        let radius = 4.0
        dateLabel.layer.borderWidth = 1.5
        dateLabel.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        dateLabel.layer.cornerRadius = radius
        topStrip1.layer.cornerRadius = radius
        topStrip2.layer.cornerRadius = radius
        bottomStrip1.layer.cornerRadius = radius
        bottomStrip2.layer.cornerRadius = radius

        topStrip1.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        topStrip2.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        bottomStrip1.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        bottomStrip2.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

    }
    
    static func nib()->UINib{
        return UINib(nibName: ReminderCollectionViewCell.identifier, bundle: nil)
    }
}
