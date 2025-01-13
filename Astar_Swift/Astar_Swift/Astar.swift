//
//  Astar.swift
//  Astar_Swift
//

import Foundation
import UIKit

public class Astar {

    var mWorldYX :[[Int]];
    private var mArrayOpen :[Node];
    private var mArrayClosed :[Node];
    var mArrayPath :[Node];
    var mDestination :CGPoint?;

    public init() {
        mWorldYX = [[]]
        mArrayOpen = []
        mArrayClosed = []
        mArrayPath = []
    }
    
    public func findPath() {
        mDestination = findDestination()
        if mDestination == nil {
            return
        }
        let nodeStart = getStartNode()
        if nodeStart == nil {
            return
        }
        
        var nodeCurrent :Node?
        mArrayOpen.append(nodeStart!)
        while mArrayOpen.count > 0 {
            nodeCurrent = mArrayOpen.remove(at: 0)
            
            if nodeCurrent!.location.equalTo(mDestination!) {
                break
            }
            
            let arrayNeighbours = getNeighbourNodes(node: nodeCurrent!)
            
            for index in arrayNeighbours.indices {
                let nodeNeighbour = arrayNeighbours[index]
                if mArrayClosed.contains(nodeNeighbour) {
                    continue
                }
                if mArrayOpen.contains(nodeNeighbour) {
                    let tempG = nodeCurrent!.G + ConstantsA.MOVE_COST
                    let tempH = abs((nodeNeighbour.location.x - mDestination!.x) + (nodeNeighbour.location.y - mDestination!.y))
                    let tempF = tempG + Float(tempH)
                    if tempF < nodeNeighbour.F {
                        nodeNeighbour.parent = nodeCurrent
                        nodeNeighbour.F = tempF
                    }
                    continue
                }
                
                nodeNeighbour.parent = nodeCurrent
                nodeNeighbour.setF(destination: mDestination!, moveCost: ConstantsA.MOVE_COST)
                mArrayOpen.append(nodeNeighbour)
            }
            mArrayClosed.append(nodeCurrent!)
        }
        
        while nodeCurrent?.parent != nil {
            mArrayPath.insert(nodeCurrent!, at: 0)
            nodeCurrent = nodeCurrent?.parent
        }
    }

    private func findDestination()->CGPoint? {
        let height = mWorldYX.count
        let width = mWorldYX[0].count
        for x in 0..<width {
            for y in 0..<height {
                let symbol = mWorldYX[y][x]
                if symbol == AstarView.kSquareTarget {
                    let point = CGPoint(x: x, y: y)
                    return point
                }
            }
        }
        return nil
    }

    private func getStartNode()->Node? {
        let width = mWorldYX[0].count
        let height = mWorldYX.count
        for x in 0..<width {
            for y in 0..<height {
                let symbol = mWorldYX[y][x]
                if symbol == AstarView.kSquareStart {
                    let node = Node()
                    node.location = CGPoint(x: x, y: y)
                    return node
                }
            }
        }
        return nil
    }

    private func getNeighbourNodes(node :Node)->[Node] {
        var arrayNodes = Array<Node>()
        
        let x = Int(node.location.x)
        let y = Int(node.location.y)
        
        //Moving in 4 directions - East, West, North, South
        //If we can move diagonally, we should add cases for - NorthEast, SouthEast, NorthWest, SouthWest
        var index = x + 1
        if index < mWorldYX[y].count {
            let symbol = mWorldYX[y][index]
            if symbol == AstarView.kSquareSpace || symbol == AstarView.kSquareTarget {
                let node = Node()
                node.location = CGPoint(x: (index), y: y)
                arrayNodes.append(node)
            }
        }
        
        index = x - 1
        if index >= 0 {
            let symbol = mWorldYX[y][index]
            if symbol == AstarView.kSquareSpace || symbol == AstarView.kSquareTarget {
                let node = Node()
                node.location = CGPoint(x: index, y: y)
                arrayNodes.append(node)
            }
        }
        
        index = y + 1
        if index < mWorldYX.count {
            let symbol = mWorldYX[index][x]
            if symbol == AstarView.kSquareSpace || symbol == AstarView.kSquareTarget {
                let node = Node()
                node.location = CGPoint(x: x, y: index)
                arrayNodes.append(node)
            }
        }
        
        index = y - 1
        if index >= 0 {
            let symbol = mWorldYX[index][x]
            if symbol == AstarView.kSquareSpace || symbol == AstarView.kSquareTarget {
                let node = Node()
                node.location = CGPoint(x: x, y: index)
                arrayNodes.append(node)
            }
        }
        
        return arrayNodes
    }
}
