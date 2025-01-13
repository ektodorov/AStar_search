//
//  Node.swift
//  Astar_Swift
//

import Foundation
import UIKit

public class Node :Equatable, CustomStringConvertible {

    public static let STATE_NOT_VISITED = 0
    public static let STATE_OPEN = 1
    public static let STATE_CLOSED = 2
    
    var location :CGPoint
    var parent :Node?
    var F :Float = 0.0
    var G :Float = 0.0
    var H :Float = 0.0
    var state :Int = STATE_NOT_VISITED
    
    public init() {
        location = CGPoint(x: 0.0, y: 0.0)
    }
    
    public init(parent :Node) {
        self.location = CGPoint(x: 0.0, y: 0.0)
        self.parent = parent
    }
    
    public init(parent :Node, destination :CGPoint, moveCost :Float) {
        self.parent = parent;
        self.location = CGPoint(x: 0.0, y: 0.0)
        setF(destination: destination, moveCost: moveCost);
    }
    
    /**
     * Using Manhattan heuristic approximation - difference in current location x, y and destination x, y
     */
    public func setF(destination :CGPoint, moveCost :Float) {
        if let g = self.parent?.G {
            G = g + moveCost
        }
        H = Float(abs(self.location.x - destination.x) + (self.location.y - destination.y))
        F = G + H
    }
    
    public static func ==(lhs: Node, rhs: Node)->Bool {
        if(lhs === rhs) {return true}
        if(lhs.location == rhs.location) {
            return true
        }
        return false
    }
    
    public var description: String {
        return "Node: location=\(location)"
    }
    
}
