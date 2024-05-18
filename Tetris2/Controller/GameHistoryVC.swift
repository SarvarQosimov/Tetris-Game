//
//  GameHistoryVC.swift
//  Tetris2
//
//  Created by Sarvar Qosimov on 12/08/23.
//

import UIKit

class GameHistoryVC: UIViewController {
    
    var tableView = UITableView()
    var history = [Int]()
    var highesScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"
        history = UserDefaults.standard.array(forKey: Keys.LAST_10_GAME_HISTORY) as? [Int] ?? [Int]()
        
        if let maxValue = history.max() {
            highesScore = maxValue
        }
        
        setupViews()
    }
    
    private func setupViews(){
        view.backgroundColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorEffect = .none
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])
    }
    
}

extension GameHistoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Last game: \(history[indexPath.row])"
            cell.textLabel?.textColor = .red
        } else {
            cell.textLabel?.text = "\(history[indexPath.row])"
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        if history[indexPath.row] == highesScore {
            cell.textLabel?.textColor = .systemGreen
        }
        
        cell.backgroundColor = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: Keys.APP_FONT, size: 21)
        cell.selectionStyle = .none
        
        return cell
    }
    
}
