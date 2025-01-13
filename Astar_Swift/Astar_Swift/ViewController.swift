//
//  ViewController.swift
//  Astar_Swift
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var aStarView: AstarView!
    @IBOutlet weak var textFieldWidth: UITextField!
    @IBOutlet weak var textFieldHeight: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onShowPathTouchUp(_ sender: Any) {
        aStarView.clearPath()
        let astar = Astar()
        astar.mWorldYX = aStarView.mArrayYX
        astar.findPath()
        let count = astar.mArrayPath.count
        for x in 0..<count {
            let node = astar.mArrayPath[x]
            if node.location.equalTo(astar.mDestination!) {break}
            astar.mWorldYX[Int(node.location.y)][Int(node.location.x)] = AstarView.kSquarePath
        }
        self.aStarView.mArrayYX = astar.mWorldYX
        self.aStarView.displayPath(squareSize: AstarView.sSquareSize)
    }
    
    @IBAction func onClearTouchUp(_ sender: Any) {
        aStarView.clear()
    }
    
    @IBAction func onSetStartTouchUp(_ sender: Any) {
        aStarView.setStart()
    }
    
    @IBAction func onSetEndTouchUp(_ sender: Any) {
        aStarView.setEnd()
    }
    
    @IBAction func onCreateTouchUp(_ sender: Any) {
        var width = 10
        var height = 10
        if let strWidth = textFieldWidth.text {
            if let intWidth = Int(strWidth) {
                width = intWidth
            }
        }
        if let strHeight = textFieldHeight.text {
            if let intHeight = Int(strHeight) {
                height = intHeight
            }
        }
        aStarView.setSize(width: width * AstarView.sSquareSize, height: height * AstarView.sSquareSize)
    }
}

