//
//  PopOverViewController.swift
//  RemindMe
//
//  Created by VM on 21/07/23.
//

import UIKit

protocol PickerProtocol{
    func onPicked(title:String,type: PickerType)
}

enum PickerType{
   case year
   case month
}

class PopOverViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    var items: [String] = []
   var initalTitle = ""
    var delegate: PickerProtocol?
    var type: PickerType = PickerType.year
    
    static let identifier = "PopOverViewController"

    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        
        pickerView.delegate = self
        pickerView.selectRow(items.firstIndex(of: initalTitle) ?? 0, inComponent: 0, animated: false)
        
//        pickerView.
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: PopOverViewController.identifier, bundle: nil)
    }
    
    
    func configure(list:[String],initialFocusedTitle: String, delegate: PickerProtocol,type: PickerType){
        items = list
        initalTitle = initialFocusedTitle
        self.delegate = delegate
        self.type = type
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return items[row]
//    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let labelView = UILabel()
        labelView.text = items[row]
        labelView.textColor = .white
        labelView.textAlignment = .center
    return labelView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.onPicked(title: items[row],type: self.type)
    }
    
}
