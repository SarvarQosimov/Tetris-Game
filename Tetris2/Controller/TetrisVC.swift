//
//  TetrisVC.swift
//  Tetris2
//
//  Created by Sarvar Qosimov on 12/05/23.
//

import UIKit
import AVFoundation

class TetrisVC: UIViewController {
    
    //MARK: - views
    var backgroundImg = UIImageView()
    let gameArea      = UIView()
    var scoreLbl      = UILabel()
    let nextBrickView = UIView()
    let pauseBtn      = UIButton()
    let levelLbl      = UILabel()
    let lvlLbl        = UILabel()
    var addedViews    = [UIView]()
    
    //MARK: Variables
    var viewModel = TetrisViewModel()
    var permission = Permession()
    var typeSorting = TypeSorting()
    var audioPlayer: AVAudioPlayer?
    var timer: Timer!
    var currentViews = [
        UIView(),
        UIView(),
        UIView(),
        UIView(),
    ]
    
    var nextViews = [
        UIView(),
        UIView(),
        UIView(),
        UIView(),
    ]
    
    var isAllowedToLeft     = false
    var isAllowedToRight    = false
    var isAllowedMoveToDown = false
    var isSwipedRight       = true
    var isStopped           = false
    
    var curLocCopy = [Location]()
    var swipingSignal = false {
        didSet{
            if turnedSignal && !swipingSignal {
                turnedSignal = swipingSignal
            } else if !turnedSignal && swipingSignal {
                turnedSignal = swipingSignal
            }
        }
    }
    var turnedSignal = false {
        didSet{
            curLocCopy = BrickModel.currentLocations
            TetrisVC.turnedX = curLocXEachSwipe
        }
    }
    var curLocXEachSwipe = 0.0
    static var turnedX = 0.0
    var fullLineCordinates = [Int]()
    var scoreCount = 0
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.4550923109, green: 0.2056671381, blue: 0.06379314512, alpha: 1)
        setupViews()
        createView()
        createNextBrick()
        
        for _ in 0...19 {
            fullLineCordinates.append(0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BrickModel.addedLocations.removeAll()
        timer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(timerAction(_:)), userInfo: nil, repeats: true)
    }
    
    //MARK: setupAudioPlayer
    func setupAudioPlayer() {
        if let soundUrl = Bundle.main.url(forResource: "click", withExtension: "mp3") {
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundID)
            AudioServicesPlaySystemSoundWithCompletion(soundID) {
                AudioServicesDisposeSystemSoundID(soundID)
            }
        }
    }
    
    //MARK: timerAction
    @objc func timerAction(_ sender: Any) {
        
        isAllowedMoveToDown = viewModel.isAllowedMoveToDown()
        ///` moveDown
        if isAllowedMoveToDown && !Board.isValidDown() && !isStopped {
            for i in 0...3 {
                BrickModel.currentLocations[i].currentY += 30
            }
            drawView()
        } else if !isStopped {
            ///` add to addedBricks
            setupAudioPlayer()
            for curBricks in BrickModel.currentLocations {
                BrickModel.addedLocations.append(curBricks)
            }
            
            for i in BrickModel.currentLocations {
                if i.currentY == 30 {
                    isStopped = true
                    
                    let vc = PauseController(isGameOver: true, delegate: self, currentScore: scoreCount)
                    vc.modalPresentationStyle = .overFullScreen
                    present(vc, animated: false)
                }
            }
            
            scoreCount += 40
            scoreLbl.text = "\(scoreCount)"
            
            if scoreCount > 1000 && scoreCount < 2000{
                timer.invalidate()
                timer = nil
                timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(timerAction(_:)), userInfo: nil, repeats: true)
                lvlLbl.text = "Medium"
                lvlLbl.textColor = .systemYellow
            } else if scoreCount > 2000 {
                timer.invalidate()
                timer = nil
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction(_:)), userInfo: nil, repeats: true)
                lvlLbl.text = "Hard"
                lvlLbl.textColor = .red
            }
            
            createViewForAdded(points: BrickModel.currentLocations)
            
            for i in BrickModel.currentLocations.enumerated() {
                let whichLine = i.element.currentY/30
                fullLineCordinates[Int(whichLine)] += 1
            }
            
            ///` check is Full Row or not
            for i in fullLineCordinates.enumerated() {
                if i.element % 10 == 0 && i.element >= 10{
                    // clear line
                    clearLine(numberOfLine: i.offset)
                    dropBricks(cleanedLine: i.offset)
                }
            }
            
            ///`    change type of brick
            BrickModel.currentLocations = typeSorting.sortByType().2
            BrickModel.typeOfBrick = typeSorting.sortByType().3
            
            updateNextView()
            BrickModel.position = .down
        }
    }
    
    //MARK: createNextBrick
    func createNextBrick() {
        var fromLeft = 0.0
        var fromBottom = 0.0
        for view in nextViews.enumerated() {
            nextBrickView.addSubview(view.element)
            view.element.backgroundColor = #colorLiteral(red: 0.998267591, green: 0.7837663293, blue: 0.166406095, alpha: 1)
            view.element.layer.borderColor = #colorLiteral(red: 0.3108820617, green: 0.1948943436, blue: 0.1113741472, alpha: 1)
            view.element.layer.borderWidth = 0.5
            view.element.layer.cornerRadius = 1
            view.element.clipsToBounds = true
            view.element.translatesAutoresizingMaskIntoConstraints = false
            
            switch view.offset {
            case 0: fromLeft = 5 ; fromBottom = 30
            case 1: fromLeft = 15 ; fromBottom = 30
            case 2: fromLeft = 15 ; fromBottom = 20
            default: fromLeft = 25 ; fromBottom = 20
            }
            
            NSLayoutConstraint.activate([
                view.element.widthAnchor.constraint(equalToConstant: 10),
                view.element.heightAnchor.constraint(equalToConstant: 10),
                view.element.leftAnchor.constraint(equalTo: nextBrickView.leftAnchor, constant: fromLeft),
                view.element.bottomAnchor.constraint(equalTo: nextBrickView.bottomAnchor, constant: -fromBottom)
            ])
            
        }
    }
    
    //MARK: updateNextView
    func updateNextView() {
        var x = [Double]()
        var y = [Double]()
        x = typeSorting.sortByType().4.0
        y = typeSorting.sortByType().4.1
        
        for view in nextViews.enumerated() {
            view.element.frame.origin = CGPoint(
                x: x[view.offset] , y: y[view.offset]
            )
        }
    }
    
    //MARK: panGesture
    @objc func panGesture(_ gesture: UIPanGestureRecognizer){
        let location = gesture.location(in: gameArea)
        let velocity = gesture.velocity(in: gameArea)
        let translation = gesture.translation(in: gameArea)
        
        ///`    speedly down
        if abs(translation.x) < abs(translation.y) && translation.y > 50 {
            ///`    speedly move
            while isAllowedMoveToDown && !Board.isValidDown() {
                speedlyMove(shouldStop: location.y)
            }
            gesture.state = .ended
        }
        
        curLocXEachSwipe = location.x
        
        if gesture.state == .began {
            // user started swiping
            curLocCopy = BrickModel.currentLocations
            TetrisVC.turnedX = location.x
            
            if velocity.x > 0 {
                swipingSignal = true
                turnedSignal = true
            } else if velocity.x < 0 {
                swipingSignal = false
                turnedSignal = false
            }
            
        } else if gesture.state == .changed {
            
            if velocity.x > 0 {
                isSwipedRight = true
                swipingSignal = true
            } else if velocity.x < 0 {
                isSwipedRight = false
                swipingSignal = false
            }
            
            checkAndMoveHorizontally()
            drawView()
        }
    }
    
    //MARK: checkAndMoveHorizontally
    func checkAndMoveHorizontally(){
        var cnt = 0
        while true {
            cnt += 1
            let check_R_and_L = permission.checkRightAndLeft(
                curLocationCopy: curLocCopy,
                howMuch: 30*Int(CGFloat(cnt)),
                isSwipedRight: isSwipedRight,
                eachSwiped: curLocXEachSwipe
            )
            
            let difference = curLocXEachSwipe-TetrisVC.turnedX
            //
            if abs(difference)  > 30*CGFloat(cnt)     &&
                abs(difference)  < 30*CGFloat(cnt)+30  &&
                !check_R_and_L {
                viewModel.moveRightOrLeft(
                    curLocationCopy: curLocCopy,
                    howMuch: 30*Int(cnt),
                    isSwipedRight
                )
                break
            }
            //
            if cnt == 7 {
                break
            }
        }
    }
    
    //MARK: tapped
    @objc func tapped(_ gesture: UITapGestureRecognizer){
        changePosition()
    }
    
    //MARK: pausePressed
    @objc func pausePressed(_ sender: Any){
        isStopped = true
        
        let vc = PauseController(isGameOver: false, delegate: self, currentScore: scoreCount)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
    
    //MARK: dropBricks
    func dropBricks(cleanedLine: Int) {
        for view in addedViews.enumerated() {
            if view.element.frame.origin.y/30 != 570 && view.element.frame.origin.y/30 < CGFloat(cleanedLine) {
                UIView.animate(withDuration: 1) { [self] in
                    addedViews[view.offset].frame.origin.y += 30
                }
            }
        }
        
        for point in BrickModel.addedLocations.enumerated() {
            if point.element.currentY/30 != 570 && point.element.currentY/30 < CGFloat(cleanedLine) {
                BrickModel.addedLocations[point.offset].currentY += 30
            }
        }
        
        fullLineCordinates.remove(at: cleanedLine)
        fullLineCordinates.insert(0, at: 0)
    }
    
    //MARK: reset
    func reset() {
        for view in addedViews {
            view.removeFromSuperview()
        }
        addedViews.removeAll()
        BrickModel.addedLocations.removeAll()
        BrickModel.currentLocations = SBrick.beginningCordinates
        BrickModel.typeOfBrick = .s
        BrickModel.position = .down
        curLocXEachSwipe = 0.0
        TetrisVC.turnedX = 0.0
        isSwipedRight = true
        fullLineCordinates = [Int]()
        swipingSignal = true
        turnedSignal = true
        isStopped = false
        scoreCount = 0
        scoreLbl.text = "0"
        //TODO: -  levelni easy qilish
        timer.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(timerAction(_:)), userInfo: nil, repeats: true)
        lvlLbl.text = "Easy"
        lvlLbl.textColor = .green
        
        createNextBrick()
        for _ in 0...19 {
            fullLineCordinates.append(0)
        }
    }
    
    //MARK: speedlyMove
    func speedlyMove(shouldStop: CGFloat){
        for i in 0...3 {
            if BrickModel.currentLocations[i].currentY + 30 <= 570 && BrickModel.currentLocations[i].currentY <= shouldStop {
                isAllowedMoveToDown = true
            } else {
                isAllowedMoveToDown = false
                break
            }
        }
        
        if isAllowedMoveToDown && !Board.isValidDown() {
            for i in 0...3 {
                BrickModel.currentLocations[i].currentY += 30
            }
        }
        drawView()
    }
    
    //MARK: changeCordinatesX
    func changeCordinatesX(howMuch: [CGFloat]){
        for point in howMuch.enumerated() {
            BrickModel.currentLocations[point.offset].currentX += point.element
        }
    }
    
    //MARK: changeCordinatesY
    func changeCordinatesY(howMuch: [CGFloat]){
        for point in howMuch.enumerated() {
            BrickModel.currentLocations[point.offset].currentY += point.element
        }
    }
    
    //MARK: nextPositionX
    static func nextPositionX(cordinates: [Location],howMuch: [CGFloat]) -> [Location]{
        var corCopy = cordinates
        
        for point in howMuch.enumerated() {
            corCopy[point.offset].currentX += point.element
        }
        
        return corCopy
    }
    
    //MARK: nextPositionY
    static func nextPositionY(cordinates: [Location],howMuch: [CGFloat]) -> [Location]{
        var corCopy = cordinates
        
        for point in howMuch.enumerated() {
            corCopy[point.offset].currentY += point.element
        }
        
        return corCopy
    }
    
    //MARK: changePosition
    func changePosition(){
        (isAllowedToRight,isAllowedToLeft) = Board.isPermittedToNextPosition()
        
        var howMuchForRight: ([CGFloat],[CGFloat]) = ([],[])
        var howMuchForLeft: ([CGFloat],[CGFloat]) = ([],[])
        
        howMuchForRight = Board.typeSorting.sortByType().0
        howMuchForLeft  = Board.typeSorting.sortByType().1
        
        ///` able to change position (right)
        if isAllowedToRight {
            changeCordinatesX(howMuch: howMuchForRight.0)
            changeCordinatesY(howMuch: howMuchForRight.1)
            
            switch BrickModel.position {
            case .down:
                BrickModel.position = .right
            case .right:
                BrickModel.position = .up
            case .up:
                BrickModel.position = .left
            case .left:
                BrickModel.position = .down
            }
        }
        
        ///` able to change position (left)
        if isAllowedToLeft {
            changeCordinatesX(howMuch: howMuchForLeft.0)
            changeCordinatesY(howMuch: howMuchForLeft.1)
            
            switch BrickModel.position {
            case .down:
                BrickModel.position = .right
            case .right:
                BrickModel.position = .up
            case .up:
                BrickModel.position = .left
            case .left:
                BrickModel.position = .down
            }
        }
        drawView()
    }
    
    //MARK: drawView
    func drawView(){
        for point in BrickModel.currentLocations.enumerated() {
            currentViews[point.offset].frame.origin.x = point.element.currentX
            currentViews[point.offset].frame.origin.y = point.element.currentY
        }
    }
    
}

extension TetrisVC: PauseDelegate {
    //MARK: Protocol func
    func backToHome() {
        reset()
        timer.invalidate()
        timer = nil
    }
    
    func continusGame() {
        isStopped = false
    }
    
    func restartGame() {
        reset()
    }
}
