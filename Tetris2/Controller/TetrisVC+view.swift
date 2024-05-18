//
//  TetrisVC+view.swift
//  Tetris2
//
//  Created by Sarvar Qosimov on 18/05/24.
//

import Foundation
import UIKit

extension TetrisVC {
    //MARK: setupViews
    func setupViews(){
        
        view.addSubview(backgroundImg)
        backgroundImg.translatesAutoresizingMaskIntoConstraints = false
        backgroundImg.image = UIImage(named: "backgroundImg")
        backgroundImg.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            backgroundImg.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backgroundImg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            backgroundImg.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            backgroundImg.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
        backgroundImg.addSubview(gameArea)
        gameArea.translatesAutoresizingMaskIntoConstraints = false
        gameArea.backgroundColor = #colorLiteral(red: 0.2443208694, green: 0.2593060434, blue: 0.2932620049, alpha: 1)
        gameArea.layer.cornerRadius = 3
        gameArea.clipsToBounds = true
        
        if UIDevice.current.name.contains("iPhone SE") {
            gameArea.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        } else {
            gameArea.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            gameArea.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            gameArea.widthAnchor.constraint(equalToConstant: 300),
            gameArea.heightAnchor.constraint(equalToConstant: 600)
        ])
        
        // add gestureRecognizer
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        
        gameArea.addGestureRecognizer(panRecognizer)
        gameArea.addGestureRecognizer(tapRecognizer)
        
        for i in 1...9 {
            let view = UIView.init(frame: CGRect(x: 300/10*i, y: 0, width: 1, height: 600))
            view.backgroundColor = #colorLiteral(red: 0.1816247106, green: 0.08545383066, blue: 0.01532023307, alpha: 1)
            gameArea.addSubview(view)
        }
        
        for i in 1...19 {
            let view = UIView.init(frame: CGRect(x: 0, y: 600/20*i, width: 300, height: 1))
            view.backgroundColor = #colorLiteral(red: 0.1816247106, green: 0.08545383066, blue: 0.01532023307, alpha: 1)
            gameArea.addSubview(view)
        }
        
        view.addSubview(nextBrickView)
        nextBrickView.translatesAutoresizingMaskIntoConstraints = false
        nextBrickView.backgroundColor = #colorLiteral(red: 0.2443208694, green: 0.2593060434, blue: 0.2932620049, alpha: 0.9)
        nextBrickView.layer.cornerRadius = 10
        nextBrickView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            nextBrickView.widthAnchor.constraint(equalToConstant: 40),
            nextBrickView.heightAnchor.constraint(equalToConstant: 60),
            nextBrickView.leadingAnchor.constraint(equalTo: gameArea.trailingAnchor, constant: 7),
            nextBrickView.topAnchor.constraint(equalTo: gameArea.topAnchor, constant: 125)
        ])
        
        let nextLbl = UILabel()
        view.addSubview(nextLbl)
        
        nextLbl.text = "Next"
        nextLbl.font = UIFont(name: Keys.APP_FONT, size: 15)
        nextLbl.textColor = .white
        nextLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nextLbl.leftAnchor.constraint(equalTo: nextBrickView.leftAnchor, constant: 0), //TODO: -  right
            nextLbl.bottomAnchor.constraint(equalTo: nextBrickView.topAnchor, constant: -10)
        ])
        view.addSubview(scoreLbl)
        scoreLbl.font = .boldSystemFont(ofSize: 21)
        scoreLbl.textColor = .white
        scoreLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scoreLbl.bottomAnchor.constraint(equalTo: gameArea.topAnchor, constant: -10),
            scoreLbl.centerXAnchor.constraint(equalTo: gameArea.centerXAnchor)
        ])
        
        view.addSubview(pauseBtn)
        pauseBtn.setImage(UIImage(named: "pauseImage"), for: .normal)
        pauseBtn.layer.cornerRadius = 20
        pauseBtn.clipsToBounds = true
        pauseBtn.tintColor = .white
        pauseBtn.setTitleColor(.white, for: .normal)
        pauseBtn.translatesAutoresizingMaskIntoConstraints = false
        pauseBtn.addTarget(self, action: #selector(pausePressed(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            pauseBtn.topAnchor.constraint(equalTo: gameArea.topAnchor, constant: 0),
            pauseBtn.leadingAnchor.constraint(equalTo: gameArea.trailingAnchor, constant: 10),
            pauseBtn.heightAnchor.constraint(equalToConstant: 40),
            pauseBtn.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        view.addSubview(levelLbl)
        levelLbl.translatesAutoresizingMaskIntoConstraints = false
        levelLbl.text = "Level:"
        levelLbl.font = UIFont(name: Keys.APP_FONT, size: 17)
        levelLbl.textColor = .white
        
        NSLayoutConstraint.activate([
            levelLbl.leadingAnchor.constraint(equalTo: gameArea.leadingAnchor),
            levelLbl.bottomAnchor.constraint(equalTo: gameArea.topAnchor, constant: -10)
        ])
        
        view.addSubview(lvlLbl)
        lvlLbl.translatesAutoresizingMaskIntoConstraints = false
        lvlLbl.text = "Esay"
        lvlLbl.font = UIFont(name: Keys.APP_FONT, size: 17)
        lvlLbl.textColor = .green
        
        NSLayoutConstraint.activate([
            lvlLbl.leftAnchor.constraint(equalTo: levelLbl.rightAnchor, constant: 5),
            lvlLbl.bottomAnchor.constraint(equalTo: gameArea.topAnchor, constant: -10)
        ])
        
    }

    //MARK: createView
    func createView(){
        for point in BrickModel.currentLocations.enumerated() {
            currentViews[point.offset].frame = CGRect(
                x: point.element.currentX,
                y: point.element.currentY,
                width: 31,
                height: 31
            )
            
            currentViews[point.offset].backgroundColor = #colorLiteral(red: 0.998267591, green: 0.7837663293, blue: 0.166406095, alpha: 1)
            currentViews[point.offset].layer.borderColor = #colorLiteral(red: 0.1816247106, green: 0.08545383066, blue: 0.01532023307, alpha: 1)
            currentViews[point.offset].layer.borderWidth = 0.5
            currentViews[point.offset].layer.cornerRadius = 3
            currentViews[point.offset].clipsToBounds = true
            gameArea.addSubview(currentViews[point.offset])
        }
    }
    
    //MARK: createViewForAdded
    func createViewForAdded(points: [Location]) {
        UIView.animate(withDuration: 0.0001) {[self] in
            for i in 0...3 {
                let view = UIView(frame: CGRect(
                    x: points[i].currentX,
                    y: points[i].currentY,
                    width: 30,
                    height: 30))
                view.backgroundColor = #colorLiteral(red: 0.998267591, green: 0.7837663293, blue: 0.166406095, alpha: 1)
                view.layer.borderWidth = 0.5
                view.layer.cornerRadius = 3
                view.clipsToBounds = true
                gameArea.addSubview(view)
                addedViews.append(view)
            }
        }
    }
    
    //MARK: clearLine
    func clearLine(numberOfLine: Int) {
        var decreaseView = 0
        for j in addedViews.enumerated() {
            if j.element.frame.origin.y/30 == CGFloat(numberOfLine) {
                
                UIView.animate(withDuration: 0.1) { [self] in
                    addedViews[j.offset-decreaseView].removeFromSuperview()
                    addedViews.remove(at: j.offset-decreaseView)
                }
                decreaseView += 1
            }
        }
        
        var decreaseCordinates = 0
        for points in BrickModel.addedLocations.enumerated() {
            if points.element.currentY/30 == CGFloat(numberOfLine) {
                BrickModel.addedLocations.remove(at: points.offset-decreaseCordinates)
                decreaseCordinates += 1
            }
        }
    }
    
}
