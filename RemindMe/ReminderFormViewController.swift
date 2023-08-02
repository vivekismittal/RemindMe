//
//  ReminderFormViewController.swift
//  RemindMe
//
//  Created by VM on 31/07/23.
//

import UIKit

protocol ReminderFormProtocol{
    func onSave(isUpdate:Bool,newReminder: ReminderModel)
}

class ReminderFormViewController: UIViewController {
    @IBOutlet weak var pickDate: UIDatePicker!
    @IBOutlet weak var reminderDetailView: UITextView!
    @IBOutlet weak var prioritySelector: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    var delegate: ReminderFormProtocol? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        prioritySelector.removeAllSegments()
        for (index,priority) in ReminderPriority.allCases.enumerated() {
            prioritySelector.insertSegment(withTitle: priority.rawValue, at: index, animated: false)
        }
        prioritySelector.selectedSegmentIndex = ReminderPriority.allCases.firstIndex(of: .NORMAL) ?? 1
        prioritySelector.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        setButton(false)
    }
    
    func setButton(_ isEnable: Bool){
        saveBtn.isEnabled = isEnable
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        setButton(!(textField.text?.isEmpty ?? true))

    }
    
    func getReminder()->ReminderModel?{
        if let title = titleTextField.text {
            return ReminderModel(title: title, dateForRemind:pickDate.date,detail: reminderDetailView.text,priorityCase: ReminderPriority.allCases[prioritySelector.selectedSegmentIndex])
        }
        return nil
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        if let reminder = getReminder(){
            delegate?.onSave(isUpdate: false, newReminder: reminder)
            dismiss(animated: true)
        }
    }
    
   
    
}
