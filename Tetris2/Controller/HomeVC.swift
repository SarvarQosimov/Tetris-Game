//
//  HomeVC.swift
//  Tetris2
//
//  Created by Sarvar Qosimov on 16/07/23.
//

import UIKit

class HomeVC: UIViewController {
    
    //MARK: - views
    var timer: Timer!
    var backgroundImg = UIImageView()
    var startBtn = UIButton()
    var historyBtn = UIButton()
    var recordLbl = UILabel()
    var trophyImg = UIImageView()
    
    //MARK: - variables
    var record_of_last_10_Game = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.backButtonTitle = "Home"
        getRecord()
        setupViews()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            changeImage()
        }
        timer.fire()
    }
    
        //MARK: - actions
    @objc private func startPressed(_ sender: Any){
        let vc = TetrisVC()
        timer.invalidate()
        timer = nil
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
    
    @objc private func historyPressed(_ sender: Any){
        navigationController?.pushViewController(GameHistoryVC(), animated: true)
    }
    
    //MARK: - functions
    private func setupViews(){
        view.addSubview(backgroundImg)
        backgroundImg.translatesAutoresizingMaskIntoConstraints = false
        backgroundImg.image = UIImage(named: "homeImg")
        
        NSLayoutConstraint.activate([
            backgroundImg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            backgroundImg.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backgroundImg.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            backgroundImg.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        view.addSubview(startBtn)
        startBtn.translatesAutoresizingMaskIntoConstraints = false
        startBtn.setTitle("Start game", for: .normal)
        startBtn.titleLabel?.font = UIFont(name: Keys.APP_FONT, size: 25)
        startBtn.setTitleColor(.white, for: .normal)
        startBtn.backgroundColor = #colorLiteral(red: 0.8193324208, green: 0.8844072819, blue: 0.1900583208, alpha: 1)
        startBtn.layer.cornerRadius = 16
        startBtn.clipsToBounds = true
        startBtn.addTarget(self, action: #selector(startPressed(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            startBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            startBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            startBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(historyBtn)
        historyBtn.translatesAutoresizingMaskIntoConstraints = false
        historyBtn.setTitle("Game history", for: .normal)
        historyBtn.titleLabel?.font = UIFont(name: Keys.APP_FONT, size: 25)
        historyBtn.setTitleColor(.white, for: .normal)
        historyBtn.backgroundColor = #colorLiteral(red: 0.4724678993, green: 0.8243483901, blue: 0.8538994193, alpha: 1)
        historyBtn.layer.cornerRadius = 16
        historyBtn.clipsToBounds = true
        historyBtn.addTarget(self, action: #selector(historyPressed(_:)), for: .touchUpInside)

        
        NSLayoutConstraint.activate([
            historyBtn.topAnchor.constraint(equalTo: startBtn.bottomAnchor, constant: 33),
            historyBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            historyBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            historyBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(recordLbl)
        recordLbl.translatesAutoresizingMaskIntoConstraints = false
        recordLbl.textColor = .white
        recordLbl.text = "Your Record: \(record_of_last_10_Game) "
        recordLbl.font = UIFont(name: Keys.APP_FONT, size: 25)
        NSLayoutConstraint.activate([
            recordLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordLbl.bottomAnchor.constraint(equalTo: startBtn.topAnchor, constant: -100)
        ])
        
        view.addSubview(trophyImg)
        trophyImg.translatesAutoresizingMaskIntoConstraints = false
        trophyImg.image = UIImage(systemName: "trophy")
        trophyImg.tintColor = .yellow
        
        NSLayoutConstraint.activate([
            trophyImg.bottomAnchor.constraint(equalTo: startBtn.topAnchor, constant: -100),
            trophyImg.rightAnchor.constraint(equalTo: recordLbl.leftAnchor, constant: -5),
            trophyImg.heightAnchor.constraint(equalToConstant: 40),
            trophyImg.widthAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    private func changeImage(){
        UIView.animate(withDuration: 1) { [self] in
            if trophyImg.image == UIImage(systemName: "trophy") {
                trophyImg.image = UIImage(systemName: "trophy.fill")
            } else {
                trophyImg.image = UIImage(systemName: "trophy")
            }
        }
    }
    
    private func getRecord(){
        let gameHistory = UserDefaults.standard.array(forKey: Keys.LAST_10_GAME_HISTORY) as? [Int] ?? [Int]()
        if let record = gameHistory.max() {
            record_of_last_10_Game = record
        }
    }
    
}
