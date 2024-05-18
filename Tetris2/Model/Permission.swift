//
//  Permission.swift
//  Tetris2
//
//  Created by Sarvar Qosimov on 16/07/23.
//

import Foundation

class Permession {
    func checkRightAndLeft(curLocationCopy: [Location], howMuch: Int, isSwipedRight: Bool, eachSwiped: Double) -> Bool {
        
        var nextBrickCor = curLocationCopy
        if isSwipedRight {
            for i in curLocationCopy.enumerated() {
                nextBrickCor[i.offset].currentX = i.element.currentX + CGFloat(howMuch)
            }
            
             for i in nextBrickCor {
                 if i.currentX > 270 {
                     return true
                 }
             }
        } else {
            for i in curLocationCopy.enumerated() {
                nextBrickCor[i.offset].currentX = i.element.currentX - CGFloat(howMuch)
            }
            
         for i in nextBrickCor {
             if i.currentX < 0 {
                 return true
             }
         }
          
        }
        
        //check added that are there exist some brick
        for points in BrickModel.addedLocations {
                if nextBrickCor.contains(points) {
                    TetrisVC.turnedX = eachSwiped
                    return true
            }
        }
                return false
    }
}
