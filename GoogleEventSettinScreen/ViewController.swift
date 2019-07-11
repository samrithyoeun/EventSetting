//
//  AddEventViewController.swift
//  PathmazingVIP
//
//  Created by Samrith Yoeun on 7/8/19.
//  Copyright © 2019 Pathmazing. All rights reserved.
//

import UIKit
import FSCalendar
import GrowingTextView

class AddEventViewController: UIViewController {
    
    var startDate = Date()
    var endDate = Date()
    var startTime = Date()
    var endTime = Date()
    var reason = ""
    var duration = Double()
    var currenTextViewHeight = CGFloat(42.5)
    
    var displayTypes = ["Private", "Public"] {
        didSet {
            displayTypeTableViewHeight = displayTypes.count * 40
        }
    }
    
    var alarmOptions = ["None", "30 Mins Before", "10 Mins Before"] {
        didSet {
            notificatonTalbeViewHeight = alarmOptions.count * 40
        }
    }

    var displayTypeTableViewHeight = 160
    var notificatonTalbeViewHeight = 160
    
    @IBOutlet weak var eventNameTextView: GrowingTextView! {
        didSet {
            eventNameTextView.delegate = self
            eventNameTextView.maxHeight = 90
        }
    }
    var notificationOption = false
    var shouldCollapse = false
    var allDay = true
    
    var fromDayButton: UIButton?
    var toDayButton: UIButton?
    var placeHolderText = "Event Name"
    
    @IBOutlet weak var notificationOptionButton: UIButton!
    @IBOutlet weak var notificationOptionLabel: UILabel!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var noficationTypeTableView: UITableView! {
        didSet {
            noficationTypeTableView.delegate = self
            noficationTypeTableView.dataSource = self
        }
    }
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var reasonTextView: UITextView! {
        didSet {
            reasonTextView.delegate = self
            reasonTextView.text = placeHolderText
            reasonTextView.textColor = .lightGray
        }
    }
    //    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var displayTypeView: UIView!
    @IBOutlet weak var notificationHeaderView: UIView!
    @IBOutlet weak var fromDateView: UIView!
    @IBOutlet weak var toDateView: UIView!
    @IBOutlet weak var fromTimeLabel: UILabel!
    @IBOutlet weak var displayTypeLabel: UILabel!
    @IBOutlet weak var startDayLabel: UILabel! {
        didSet {
            
        }
    }
    
    @IBOutlet weak var endDayLabel: UILabel! {
        didSet {
          
        }
    }
    
    @IBOutlet weak var toTimeLabel: UILabel!
    @IBOutlet weak var datePickerView: UIView!
    
    @IBOutlet weak var uiSwitch: UISwitch! {
        didSet {
            uiSwitch.onTintColor = .blue
        }
    }
    
    @IBOutlet weak var toTimePickerView: UIDatePicker! {
        didSet {
            toTimePickerView.isHidden = true
        }
    }

    @IBOutlet weak var fromTimePickerView: UIDatePicker! {
        didSet {
            fromTimePickerView.isHidden = true
        }
    }
    
    @IBOutlet weak var fromDateCalendar: FSCalendar! {
        didSet {
            fromDateCalendar.delegate = self
        }
    }
    @IBOutlet weak var toDateCalendar: FSCalendar! {
        didSet {
            toDateCalendar.delegate = self
        }
    }
    
    @IBOutlet weak var displayTypeTableView: UITableView! {
        didSet {
            displayTypeTableView.delegate = self
            displayTypeTableView.dataSource = self
            
        }
    }
    
    static func instantiate() -> AddEventViewController {
        let storyboard = UIStoryboard(name: "PublicHoliday", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! AddEventViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let footerView = UIView (frame: CGRect(x: 0, y: 0, width: displayTypeTableView.frame.size.width, height: 1))
        displayTypeTableView.tableFooterView = footerView
        fromDateView.frame.size.height = 40
        fromDateView.clipsToBounds = true
     
    }
    
    private func getTimeOffType() {
    
    }
    
    @IBAction func nextButtonDidTapped(_ sender: UIButton) {
     
    }
    
    
    @IBAction func fromDayButtonDidTapped(_ sender: Any) {
        let button = sender as! UIButton
        button.isEnabled = false
        fromDayButton = button
        
        if fromDateView.frame.size.height > 150 {
            if !fromTimePickerView.isHidden {
                fadeInStartDateCalendar()
                
            } else {
                hideFromDayCalendar()
            }
        } else {
            showFromDayCalendar()
        }
    }
    
    @IBAction func toDayButtonDidTapped(_ sender: UIButton) {
        toDayButton = sender
        toDayButton?.isEnabled = false
        if toDateView.frame.size.height > 150 {
            if !toTimePickerView.isHidden {
                fadeInEndDateCalendar()
                
            } else {
                hideToDateCalendar()
            }
            
        } else {
            showToDateCalendar()
        }
        
    }
    
    @IBAction func onSwitchValueChanged(_ sender: Any) {
        if allDay {
            showTimeButton()
        } else {
            hideTimeButton()
            
            if !toTimePickerView.isHidden {
                toTimePickerView.isHidden = true
                toDateCalendar.isHidden = false
            }
            
            if !fromTimePickerView.isHidden {
                fromTimePickerView.isHidden = true
                fromDateCalendar.isHidden = false
            }
        }
        
    }
    
    @IBAction func toTimeButtonDidTapped(_ sender: Any) {
        if allDay { return }
        
        if !toTimePickerView.isHidden && toDateView.frame.size.height > 150 && toDateCalendar.isHidden {
            hideToDateCalendar()
        } else {
            showToTimePicker()
        }
    }
    
    @IBAction func fromTimeButtonDidTapped(_ sender: Any) {
        if allDay { return }
        
        if !fromTimePickerView.isHidden && fromDateView.frame.size.height > 150 && fromDateCalendar.isHidden {
            hideFromDayCalendar()
        } else {
            showFromTimePicker()
        }
    }
    
    @IBAction func displayTypeButtonDidTapped(_ sender: Any) {
        let button = sender as! UIButton
        button.isEnabled = false
        if shouldCollapse {
            collapseDisPlayTypeTableView(button)
        } else {
            expandDisplayTypeTableView(button)
        }
    }
    
    @IBAction func notificationButtonDidTapped(_ sender: Any) {
        
        notificationOptionButton.isEnabled = false
        if notificationOption {
            collapseNotificationTableView(notificationOptionButton)
        } else {
            expandNotificationTableView(notificationOptionButton)
        }
    }
    
    @IBAction func startDateValueChanged(_ sender: UIDatePicker) {
        
    }
    
    @IBAction func endDateValueChanged(_ sender: UIDatePicker) {
        
        endTime = sender.date
    }
    
    
    @IBAction func closeButtonDidTapped(_ sender: UIButton) {
    
    }
    
}

extension AddEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == noficationTypeTableView {
            displayTypeLabel.text = "private"
            collapseNotificationTableView()
        } else {
            notificationOptionLabel.text = "private"
            collapseDisPlayTypeTableView()
        }
        
        
    }
}

extension AddEventViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == noficationTypeTableView {
            return alarmOptions.count
        } else {
            return displayTypes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeOffTypeTableViewCell") as! TimeOffTypeTableViewCell
        if tableView == noficationTypeTableView {
            cell.timeOffTypeLabel?.text = "10 minute"
        } else {
            cell.timeOffTypeLabel?.text = "Private"
        }
        
        return cell
    }
}

extension AddEventViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar == fromDateCalendar {
            fromDayButton?.isEnabled = true
            hideFromDayCalendar()
            
            startDate = date
            
        } else {
            print("to date")
            guard startDate < date  || Calendar.current.isDate(startDate, inSameDayAs: date) else {
                
                return
            }
            endDate = date
            
            endDayLabel.text = "HEllo"
            hideToDateCalendar()
            toDayButton?.isEnabled = true
        }
    }
}

extension AddEventViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        textView.textColor = .black
        
        if(textView.text == placeHolderText) {
            textView.text = ""
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "") {
            textView.text = self.placeHolderText
            textView.textColor = .lightGray
        }
    }
}

// MARK: Animation on Time Off Type
extension AddEventViewController {
    
    private func collapseDisPlayTypeTableView(_ button: UIButton? = nil) {
        
        UIView.animate(withDuration: 0.3
            , animations: {
                self.displayTypeTableView.frame.size.height -= CGFloat(self.displayTypeTableViewHeight)
                self.datePickerView.frame.origin.y -= CGFloat(self.displayTypeTableViewHeight)
                //                self.bottomConstraint.constant -= CGFloat(self.displayTypeTableViewHeight)
                
        }) { (Bool) in
            self.displayTypeTableView.isHidden = true
            self.shouldCollapse = false
            button?.isEnabled = true
        }
    }
    
    private func expandDisplayTypeTableView(_ button: UIButton? = nil) {
        UIView.animate(withDuration: 0.3
            , animations: {
                self.displayTypeTableView.isHidden = false
                self.displayTypeTableView.frame.size.height += CGFloat(self.displayTypeTableViewHeight)
                self.datePickerView.frame.origin.y += CGFloat(self.displayTypeTableViewHeight)
                //                self.bottomConstraint.constant += CGFloat(self.displayTypeTableViewHeight)
        }) { (Bool) in
            self.shouldCollapse = true
            button?.isEnabled = true
        }
    }
    
    private func collapseNotificationTableView(_ button: UIButton? = nil) {
        
        UIView.animate(withDuration: 0.3
            , animations: {
                self.noficationTypeTableView.frame.size.height -= CGFloat(self.displayTypeTableViewHeight)
                self.noteView.frame.origin.y -= CGFloat(self.displayTypeTableViewHeight)
                //                self.bottomConstraint.constant -= CGFloat(self.displayTypeTableViewHeight)
                
        }) { (Bool) in
            self.noficationTypeTableView.isHidden = true
            self.notificationOption = false
            button?.isEnabled = true
        }
    }
    
    private func expandNotificationTableView(_ button: UIButton? = nil) {
        UIView.animate(withDuration: 0.3
            , animations: {
                self.noficationTypeTableView.isHidden = false
                self.noficationTypeTableView.frame.size.height += CGFloat(self.displayTypeTableViewHeight)
                self.noteView.frame.origin.y += CGFloat(self.displayTypeTableViewHeight)
                //                self.bottomConstraint.constant += CGFloat(self.displayTypeTableViewHeight)
        }) { (Bool) in
            self.notificationOption = true
            button?.isEnabled = true
        }
    }
}

// MARK: Animation on DateTimePicker and TimeButton
extension AddEventViewController {
    private func showTimeButton() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.fromTimeLabel.isHidden = false
            self.toTimeLabel.isHidden = false
            self.fromTimeLabel.backgroundColor = .lightGray
            self.toTimeLabel.backgroundColor = .lightGray
        }) { (Bool) in
            self.allDay = false
            self.fromTimeLabel.backgroundColor = .white
            self.toTimeLabel.backgroundColor = .white
        }
    }
    
    private func hideTimeButton() {
        fromTimeLabel.isHidden = true
        toTimeLabel.isHidden = true
        allDay = true
    }
    
    private func showFromTimePicker() {
        
        fromTimePickerView.isHidden = false
        if fromDateView.frame.size.height > 150 {
            fromDateCalendar.isHidden = true
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.fromDateCalendar.isHidden = true
                self.fromDateView.frame.size.height += 220
                self.toDateView.frame.origin.y += 220
                self.locationView.frame.origin.y += 220
                self.notificationHeaderView.frame.origin.y += 220
                self.noficationTypeTableView.frame.origin.y += 220
                self.noteView.frame.origin.y += 220
                
                //                self.bottomConstraint.constant += 220
            }, completion: nil)
        }
    }
    
    private func showToTimePicker() {
        toTimePickerView.isHidden = false
        
        if toDateView.frame.size.height > 150 {
            toDateCalendar.isHidden = true
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.toDateCalendar.isHidden = true
                self.toDateView.frame.size.height += 220
                self.locationView.frame.origin.y += 220
                self.notificationHeaderView.frame.origin.y += 220
                self.noficationTypeTableView.frame.origin.y += 220
                self.noteView.frame.origin.y += 220
                //                self.bottomConstraint.constant += 220
            }, completion: nil)
        }
    }
}

// MARK : Animation on StartDate and EndDate Calendars
extension AddEventViewController {
    private func fadeInEndDateCalendar() {
        toDateCalendar.isHidden = false
        toTimePickerView.isHidden = true
        toDayButton?.isEnabled = true
        toDateCalendar.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.toDateCalendar.alpha = 1
        }, completion: nil)
    }
    
    private func fadeInStartDateCalendar() {
        fromDateCalendar.isHidden = false
        fromTimePickerView.isHidden = true
        fromDayButton?.isEnabled = true
        fromDateCalendar.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.fromDateCalendar.alpha = 1
        }, completion: nil)
    }
    
    private func showToDateCalendar() {
        self.toDayButton?.isEnabled = true
        self.toDateCalendar.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.toDateCalendar.alpha = 1
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.toDateView.frame.size.height += 220
            self.locationView.frame.origin.y += 220
            self.notificationHeaderView.frame.origin.y += 220
            self.noficationTypeTableView.frame.origin.y += 220
            self.noteView.frame.origin.y += 220
            
            //            self.bottomConstraint.constant += 220
        }, completion: nil)
        
    }
    
    private func hideToDateCalendar() {
        self.toDayButton?.isEnabled = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.toDateView.frame.size.height -= 220
            self.locationView.frame.origin.y -= 220
            self.notificationHeaderView.frame.origin.y -= 220
            self.noficationTypeTableView.frame.origin.y -= 220
            self.noteView.frame.origin.y -= 220
            //            self.bottomConstraint.constant -= 220
        }, completion: nil)
    }
    
    private func showFromDayCalendar() {
        
        fromDayButton?.isEnabled = true
        fromDateCalendar.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.fromDateCalendar.alpha = 1
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.fromDateView.frame.size.height += 220
            self.toDateView.frame.origin.y += 220
            self.locationView.frame.origin.y += 220
            self.notificationHeaderView.frame.origin.y += 220
            self.noficationTypeTableView.frame.origin.y += 220
            self.noteView.frame.origin.y += 220
            //            self.bottomConstraint.constant += 220
        }, completion:  nil)
    }
    
    private func hideFromDayCalendar() {
        fromDayButton?.isEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            self.fromDateView.frame.size.height -= 220
            self.toDateView.frame.origin.y -= 220
            self.locationView.frame.origin.y -= 220
            self.notificationHeaderView.frame.origin.y -= 220
            self.noficationTypeTableView.frame.origin.y -= 220
            self.noteView.frame.origin.y -= 220
            
            //            self.bottomConstraint.constant -= 220
        }, completion: nil)
    }
}

extension AddEventViewController: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        print("Height \(height)")
        let growingHeight = height - currenTextViewHeight
        if height > currenTextViewHeight {
            UIView.animate(withDuration: 0.5) {
                self.displayTypeTableView.frame.origin.y += 26.16
                self.displayTypeView.frame.origin.y += 26.16
                self.datePickerView.frame.origin.y += 26.16
                self.notificationHeaderView.frame.origin.y += 26.16
                self.noficationTypeTableView.frame.origin.y += 26.16
                self.noteView.frame.origin.y  += 26.16
            }
        } else if height < 50 {
            UIView.animate(withDuration: 0.2) {
                self.displayTypeTableView.frame.origin.y -= 45
                self.displayTypeView.frame.origin.y -= 45
                self.datePickerView.frame.origin.y -= 45
                self.notificationHeaderView.frame.origin.y -= 45
                self.noficationTypeTableView.frame.origin.y -= 45
                self.noteView.frame.origin.y -= 45
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.displayTypeTableView.frame.origin.y -= 26.16
                self.displayTypeView.frame.origin.y -= 26.16
                self.datePickerView.frame.origin.y -= 26.16
                self.notificationHeaderView.frame.origin.y -= 26.16
                self.noficationTypeTableView.frame.origin.y -= 26.16
                self.noteView.frame.origin.y -= 26.16
            }
        }
    }
}
