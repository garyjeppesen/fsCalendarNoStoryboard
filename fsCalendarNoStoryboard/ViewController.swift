//
//  ViewController.swift
//  fsCalendarNoStoryboard
//
//  Created by Gary Jeppesen on 3/7/21.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {

    private let mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
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
        
        view.addSubview(mainView)
        mainView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingRight: 10)
        
        mainView.addSubview(calendar)
        calendar.anchor(top: mainView.topAnchor, left: mainView.leftAnchor, right: mainView.rightAnchor)
        calendar.setHeight(height: 300)
        
        mainView.addSubview(tableView)
        tableView.anchor(top: calendar.bottomAnchor, left:mainView.leftAnchor, bottom: mainView.bottomAnchor, right: mainView.rightAnchor, paddingTop: 16)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.calendar.scope = .week

    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.heightConstraint?.constant = bounds.height
        self.calendar.layoutIfNeeded()
        self.tableView.layoutIfNeeded()
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
            let scope: FSCalendarScope = (indexPath.row == 0) ? .month : .week
            self.calendar.setScope(scope, animated: false)
        }
        print("DEBUG: heightConstraint: \(calendar.heightConstraint)")
        print("DEBUG: bounds \(calendar.bounds.height)")
    }

}

