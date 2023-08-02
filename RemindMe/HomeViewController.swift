//
//  ViewController.swift
//  RemindMe
//
//  Created by VM on 17/07/23.
//

import UIKit

class HomeViewController: UIViewController,PickerProtocol,ReminderFormProtocol {
    
    
    
    @IBOutlet weak var reminderCollectionView: UICollectionView!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var addReminderButton: UIImageView!
    
    let calendar = Calendar.current
    let crud = CRUD()
    var selectedDateItemIndex = 0
    
    let beginYear = 1947
    let endYear = 2100
    let totalRowsInAMonth = 7
    let totalMonthsInAYear = 12
    let firstDateOfMonth = 1
    let totalWeekDays = Date.totalWeekDays
    let totalMonthsName = Date.totalMonthsName
    var oneMonthItemsCount = 0
    let currentDate = Date()
    var reminders:[ReminderModel] = []
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchReminders()
        listView.layer.cornerRadius = 50
        listView.layer.cornerCurve = .continuous
        listView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        reminderCollectionView.layer.cornerRadius = 50
        reminderCollectionView.layer.cornerCurve = .continuous
        reminderCollectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        oneMonthItemsCount = totalWeekDays.count * totalRowsInAMonth
        selectedDateItemIndex = getDateItemIndex(currentDate)
        if let date = getDate(selectedDateItemIndex){
            selectDate(date)
        }
        
        calendarCollectionView.collectionViewLayout = self.generateCalendarLayout()
        reminderCollectionView.collectionViewLayout = self.generateReminderLayout()
        //        calendarCollectionView.alwaysBounceVertical = false
        reminderCollectionView.delegate = self
        reminderCollectionView.dataSource = self
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self
        
        calendarCollectionView.isScrollEnabled = false
        calendarCollectionView.register(CalendarCollectionViewCell.nib(),forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        
        reminderCollectionView.register(ReminderCollectionViewCell.nib(), forCellWithReuseIdentifier: ReminderCollectionViewCell.identifier)
        addReminderButton.isUserInteractionEnabled =  true
        addReminderButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTapForAddReminder(_: ))))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollToDate(currentDate)
    }
    
    @objc func onTapForAddReminder(_ sender : UITapGestureRecognizer){
        let reminderFormVC = ReminderFormViewController()
        reminderFormVC.delegate = self
        presentCenterPopup(self, reminderFormVC,sender: self.view,size: CGSize(width: 400, height: 600))
    }
    
    @IBAction func onYearButtonTap(_ sender: Any) {
        let popOver = PopOverViewController()
        var yearStringList:[String] = []
        for i in (beginYear...endYear){
            yearStringList.append(String(i))
        }
        popOver.configure(list: yearStringList,initialFocusedTitle: yearButton.titleLabel?.text ?? "",delegate: self,type: .year)
        presentPopover(self, popOver, sender: yearButton,size: CGSize(width: 100, height: 200), arrowDirection: .up)
        
    }
    
    @IBAction func onMonthButtonTap(_ sender: Any) {
        let popOver = PopOverViewController()
        popOver.configure(list: totalMonthsName,initialFocusedTitle:monthButton.titleLabel?.text ?? "",delegate: self,type: .month)
        presentPopover(self, popOver, sender: monthButton,size: CGSize(width: 100, height: 200), arrowDirection: .up)
        
    }
    
    func scrollToDate(_ date: Date) {
        let index = getDateItemIndex(date)
        let indexPath = IndexPath(item: index, section: 0)
        calendarCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
    }
    
    func onPicked(title: String, type: PickerType) {
        let selectedYear = Int(yearButton.titleLabel?.text ?? "") ?? 0
        let selectedMonth = (totalMonthsName.firstIndex(of: monthButton.titleLabel?.text ?? "") ?? 0) + 1
        
        switch type{
        case .year:
            scrollToDate(Date.dateFromValues(Int(title) ?? 0, selectedMonth, firstDateOfMonth))
            break
        case .month:
            scrollToDate(Date.dateFromValues(selectedYear, (totalMonthsName.firstIndex(of: title) ?? 0) + 1, firstDateOfMonth))
            break
        }
    }
    
    
    func fetchReminders(){
         reminders = crud.retrieveReminders()
        reminders.sort { $0.dateForRemind < $1.dateForRemind }
    }
    
    func onSave(isUpdate: Bool = false,newReminder: ReminderModel) {
        if isUpdate{
            return
        }
        crud.create(reminderData: newReminder){ reminder in
            LocalNotifications.dispatchNotification(reminder: reminder)
        }
        fetchReminders()
        reminderCollectionView.reloadData()
    }
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func generateReminderLayout()-> UICollectionViewLayout{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, repeatingSubitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func generateCalendarLayout() -> UICollectionViewLayout{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/CGFloat(totalWeekDays.count)), heightDimension: .fractionalHeight(1))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/CGFloat(totalRowsInAMonth)))
        let gridGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: totalWeekDays.count)
        let gridGroup = NSCollectionLayoutGroup.vertical(layoutSize: gridGroupSize, repeatingSubitem: group, count: totalRowsInAMonth)
        let scrollableGroup = NSCollectionLayoutGroup.horizontal(layoutSize: gridGroupSize, subitems: [gridGroup])
        let section  = NSCollectionLayoutSection(group: scrollableGroup)
        section.orthogonalScrollingBehavior = .paging
        
        section.visibleItemsInvalidationHandler = { [weak self] (items, offset, env) -> Void in
            guard let self = self else { return }
            let monthIndex = Int(round(offset.x / calendarCollectionView.frame.width)) + 1
            var month = monthIndex % totalMonthsInAYear
            if month == 0 {
                month = 12
            }
            monthButton.setTitle(totalMonthsName[month - 1], for: .normal)
            var year = (monthIndex / totalMonthsInAYear) + beginYear
            if month == 12{
                year -= 1
            }
            yearButton.setTitle(String(year), for: .normal)
            
        }
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calendarCollectionView{
            return oneMonthItemsCount*(endYear - beginYear + 1) * 12
        } else{
            return reminders.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == calendarCollectionView{
            let result = getDateCellTitle(indexPath.item)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as! CalendarCollectionViewCell
            cell.configure(title: result.0, isSelected: selectedDateItemIndex == indexPath.item, isWeekDays: result.1)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReminderCollectionViewCell.identifier, for: indexPath) as! ReminderCollectionViewCell
            
            cell.configure(index: indexPath.item,isLast: indexPath.item == reminders.count - 1,reminder: reminders[indexPath.item])
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == calendarCollectionView{
            if let currentCell = calendarCollectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell, currentCell.isDate{
                if let cell = calendarCollectionView.cellForItem(at: IndexPath(item: selectedDateItemIndex, section: 0)) as? CalendarCollectionViewCell, cell.isDate{
                    cell.isSelected(false)
                }
                currentCell.isSelected(true)
                if let date = getDate(indexPath.item){
                    selectDate(date)
                    
                }
                selectedDateItemIndex = indexPath.item
            }
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    private func getDateCellTitle(_ indexPathItem:Int)->(String,Bool){
        
        var title = ""
        
        if let date = getDate(indexPathItem){
            title = String(calendar.component(.day, from: date))
        }
        let index = indexPathItem % oneMonthItemsCount
        var isWeekDay = false
        if(index < totalWeekDays.count){
            title = totalWeekDays[index]
            isWeekDay = true
        }
        return (title,isWeekDay)
    }
    
    func selectDate(_ date: Date){
        dateLabel.text = date.formmatedDate()
        
    }
    
}
