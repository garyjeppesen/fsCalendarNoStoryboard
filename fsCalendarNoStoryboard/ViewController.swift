//
//  ViewController.swift
//  fsCalendarNoStoryboard
//
//  Created by Gary Jeppesen on 3/7/21.
//

import UIKit
import FSCalendar

private var heightConstraint: NSLayoutConstraint?

class ViewController: UIViewController {

    lazy var calendarMonthHeight:CGFloat = 300
    lazy var calendarWeekHeight:CGFloat = 150
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        return tv
    }()
    
    private let calendar: FSCalendar = {
        let cal = FSCalendar()
        return cal
    }()
    
    private let animationSwitch: UISwitch = {
        let sw = UISwitch()
        
        return sw
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightConstraint = NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: calendarMonthHeight)
        
        
        view.addSubview(mainView)
        mainView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingRight: 10)
        
        mainView.addSubview(calendar)
        calendar.anchor(top: mainView.topAnchor, left: mainView.leftAnchor, right: mainView.rightAnchor)
        calendar.addConstraint(heightConstraint!)
        
        mainView.addSubview(tableView)
        tableView.anchor(top: calendar.bottomAnchor, left:mainView.leftAnchor, bottom: mainView.bottomAnchor, right: mainView.rightAnchor, paddingTop: 16)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .month

    }
    
    deinit {
        print("\(#function)")
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [2, 5][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = "FSCalendarScopeMonth"
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = "FSCalendarScopeWeek"
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = "Test Cell"
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = "Lorem ipsum dolor sit er elit lamet"
            return cell
        }
    }
    
    // MARK:- UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: Section/Row: \(indexPath.section) / \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.calendar.setScope(.month, animated: false)
                self.calendar.heightConstraint?.constant = 300
            case 1:
                self.calendar.setScope(.week, animated: false)
                self.calendar.heightConstraint?.constant = 115
            default:
                self.calendar.heightConstraint?.constant = 115

            }
        self.view.layoutIfNeeded()
        }
        print("DEBUG: heightConstraint: \(calendar.heightConstraint)")
        print("DEBUG: bounds \(calendar.bounds.height)")
    }

}

extension ViewController: UIGestureRecognizerDelegate {

    // MARK:- UIGestureRecognizerDelegate

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.heightConstraint?.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
}
