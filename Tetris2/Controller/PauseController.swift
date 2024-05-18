//
//  PauseController.swift
//  Tetris2
//
//  Created by Sarvar Qosimov on 16/05/24.
//

import UIKit

class PauseController: UIViewController {
    
    //MARK: - views
    let appNameLabel = UILabel()
    
    //MARK: - variables
    var last10History = [Int]()
    var delegate: PauseDelegate?
    var isGameOver = false
    var currentScore = 0
    
    //MARK: - init
    init(isGameOver: Bool, delegate: PauseDelegate, currentScore: Int) {
        self.isGameOver = isGameOver
        self.delegate = delegate
        self.currentScore = currentScore
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    //MARK: - objc functions
    @objc private func  continueAction(_ sender: Any) {
        delegate?.continusGame()
        dismiss(animated: false)
    }
    
    @objc private func  restartAction(_ sender: Any) {
        saveHistory()
        
        delegate?.restartGame()
        dismiss(animated: false)
    }
    
    @objc private func  homeAction(_ sender: Any) {
        saveHistory()
        
        delegate?.backToHome()
        let nc = UINavigationController(rootViewController: HomeVC())
        UIApplication.shared.keyWindow?.rootViewController = nc
    }
    
    private func saveHistory(){
        last10History = UserDefaults.standard.array(forKey: Keys.LAST_10_GAME_HISTORY) as? [Int] ?? [Int]()
        
        if last10History.count == 10 {
            last10History.removeLast()
            last10History.insert(currentScore, at: 0)
        } else {
            last10History.insert(currentScore, at: 0)
        }
        
        UserDefaults.standard.set(last10History, forKey: Keys.LAST_10_GAME_HISTORY)
    }
    
    private func initViews(){
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.45)
        
        view.addSubview(appNameLabel)
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.font = UIFont(name: Keys.APP_FONT, size: 33)
        appNameLabel.numberOfLines = 0
        
        let buttonsStack = UIStackView()
        view.addSubview(buttonsStack)
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.spacing = 15
        buttonsStack.axis = .vertical
        
        if !isGameOver {
            buttonsStack.addArrangedSubview(
                buttonBuilder("Continue", action: #selector(continueAction(_:)))
            )
        } else {
            appNameLabel.textColor = .red
            appNameLabel.text = """
                                Game
                                    Over
                                """
        }
        
        buttonsStack.addArrangedSubview(
            buttonBuilder("Restart", action: #selector(restartAction(_:)))
        )
        
        buttonsStack.addArrangedSubview(
            buttonBuilder("Home", action: #selector(homeAction(_:)))
        )
        
        NSLayoutConstraint.activate([
            appNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    private func buttonBuilder(_ title: String, action: Selector) -> UIButton {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.backgroundColor = .systemMint
        button.titleLabel?.font = UIFont(name: Keys.APP_FONT, size: 21)
        button.titleLabel?.textColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return button
    }
    
}
