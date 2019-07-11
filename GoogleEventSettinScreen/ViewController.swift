//
//  TimeOffViewController.swift
//  PathmazingVIP
//
//  Created by Samrith Yoeun on 7/8/19.
//  Copyright © 2019 Pathmazing. All rights reserved.
//

import UIKit
import FSCalendar
import GrowingTextView

class TimeOffViewController: UIViewController {
    
    var startDate = Date()
    var endDate = Date()
    var startTime = Date()
    var endTime = Date()
    var reason = ""
    var duration = Double()
    var currenTextViewHeight = CGFloat(42.5)

    @IBOutlet weak var eventNameTextView: GrowingTextView! {
        didSet {
            eventNameTextView.delegate = self
            eventNameTextView.maxHeight = 90
        }
    }
    var shouldCollapse = false
    var allDay = true
    var timeOffTableHeight = 0
    var fromDayButton: UIButton?
    var toDayButton: UIButton?
    var placeHolderText = "Please specify your reason."
    
    @IBOutlet weak var scrollViewContentView: UIView!
    @IBOutlet weak var reasonTextView: UITextView! {
        didSet {
            reasonTextView.delegate = self
            reasonTextView.text = placeHolderText
            reasonTextView.textColor = .lightGray
        }
    }
    //    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeOffTypeView: UIView!
    @IBOutlet weak var fromDateView: UIView!
    @IBOutlet weak var toDateView: UIView!
    @IBOutlet weak var fromTimeLabel: UILabel!
    @IBOutlet weak var timeOffTypeLabel: UILabel!
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
    @IBOutlet weak var remainingAnnualLeave: UILabel!
    
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
    
    @IBOutlet weak var reasonView: UIView!
    
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
    
    @IBOutlet weak var timeOffTypeTableView: UITableView! {
        didSet {
            timeOffTypeTableView.delegate = self
            timeOffTypeTableView.dataSource = self
            
        }
    }
    
    static func instantiate() -> TimeOffViewController {
        let storyboard = UIStoryboard(name: "PublicHoliday", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! TimeOffViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let footerView = UIView (frame: CGRect(x: 0, y: 0, width: timeOffTypeTableView.frame.size.width, height: 1))
        timeOffTypeTableView.tableFooterView = footerView
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
    
    @IBAction func onTimeOffTypeButtonTapped(_ sender: Any) {
        let button = sender as! UIButton
        button.isEnabled = false
        if shouldCollapse {
            collapseTimeOffTypeTableView(button)
        } else {
            expandTimeOffTypeTableView(button)
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

extension TimeOffViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        collapseTimeOffTypeTableView()
    }
}

extension TimeOffViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeOffTypeTableViewCell") as! UITableViewCell
        
        cell.textLabel?.text = "Hello"
        return cell
    }
}

extension TimeOffViewController: FSCalendarDelegate {
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

extension TimeOffViewController: UITextViewDelegate {
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
extension TimeOffViewController {
    private func collapseTimeOffTypeTableView(_ button: UIButton? = nil) {
        
        UIView.animate(withDuration: 0.3
            , animations: {
                self.timeOffTypeTableView.frame.size.height -= CGFloat(self.timeOffTableHeight)
                self.datePickerView.frame.origin.y -= CGFloat(self.timeOffTableHeight)
                //                self.bottomConstraint.constant -= CGFloat(self.timeOffTableHeight)
                
        }) { (Bool) in
            self.timeOffTypeTableView.isHidden = true
            self.shouldCollapse = false
            button?.isEnabled = true
        }
    }
    
    private func expandTimeOffTypeTableView(_ button: UIButton? = nil) {
        UIView.animate(withDuration: 0.3
            , animations: {
                self.timeOffTypeTableView.isHidden = false
                self.timeOffTypeTableView.frame.size.height += CGFloat(self.timeOffTableHeight)
                self.datePickerView.frame.origin.y += CGFloat(self.timeOffTableHeight)
                //                self.bottomConstraint.constant += CGFloat(self.timeOffTableHeight)
        }) { (Bool) in
            self.shouldCollapse = true
            button?.isEnabled = true
        }
    }
}

// MARK: Animation on DateTimePicker and TimeButton
extension TimeOffViewController {
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
                self.reasonView.frame.origin.y += 220
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
                self.reasonView.frame.origin.y += 220
                //                self.bottomConstraint.constant += 220
            }, completion: nil)
        }
    }
}

// MARK : Animation on StartDate and EndDate Calendars
extension TimeOffViewController {
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
            self.reasonView.frame.origin.y += 220
            //            self.bottomConstraint.constant += 220
        }, completion: nil)
        
    }
    
    private func hideToDateCalendar() {
        self.toDayButton?.isEnabled = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.toDateView.frame.size.height -= 220
            self.reasonView.frame.origin.y -= 220
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
            self.reasonView.frame.origin.y += 220
            //            self.bottomConstraint.constant += 220
        }, completion:  nil)
    }
    
    private func hideFromDayCalendar() {
        fromDayButton?.isEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            self.fromDateView.frame.size.height -= 220
            self.toDateView.frame.origin.y -= 220
            self.reasonView.frame.origin.y -= 220
            //            self.bottomConstraint.constant -= 220
        }, completion: nil)
    }
}

extension TimeOffViewController: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        print("Height \(height)")
        let growingHeight = height - currenTextViewHeight
        if height > currenTextViewHeight {
            UIView.animate(withDuration: 0.5) {
                self.timeOffTypeTableView.frame.origin.y += 26.16
                self.timeOffTypeView.frame.origin.y += 26.16
                self.datePickerView.frame.origin.y += 26.16
            }
        } else if height < 45 {
            UIView.animate(withDuration: 0.5) {
                self.timeOffTypeTableView.frame.origin.y = 85
                self.timeOffTypeView.frame.origin.y -= 28
                self.datePickerView.frame.origin.y -= 28
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.timeOffTypeTableView.frame.origin.y -= 26.16
                self.timeOffTypeView.frame.origin.y -= 26.16
                self.datePickerView.frame.origin.y -= 26.16
            }
        }
    }
}
