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
        
    }


}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [2, 5][section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let identifier = ["cell_month", "cell_week"][indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            return cell
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let scope: FSCalendarScope = (indexPath.row == 0) ? .month : .week
            self.calendar.setScope(scope, animated: self.animationSwitch.isOn)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

