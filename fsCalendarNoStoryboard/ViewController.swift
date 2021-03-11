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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mainView)
        mainView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingRight: 10)
        
        mainView.addSubview(calendar)
        calendar.anchor(top: mainView.topAnchor, left: mainView.leftAnchor, right: mainView.rightAnchor)
        calendar.setHeight(height: 300)
        
        mainView.addSubview(tableView)
        tableView.anchor(top: calendar.bottomAnchor, left:mainView.leftAnchor, bottom: mainView.bottomAnchor, right: mainView.rightAnchor)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Test Cell"
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

