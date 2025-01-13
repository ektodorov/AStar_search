//
//  AstarView.swift
//  Astar_Swift
//

import Foundation
import UIKit

public class AstarView : UIView {
    
    public static let kSquareSpace = 0
    public static let kSquareWall = 1
    public static let kSquareStart = 2
    public static let kSquareTarget = 3
    public static let kSquarePath = 4
    public static let kSquareSize = 40
    public static var sSquareSize = 40
    private var mArraySquares :[CGRect]
    private var mArraySquaresPath :[CGRect]
    private var mSquareStart :CGRect?
    private var mSquareEnd :CGRect?
    var mArrayYX :[[Int]]
    private var mShapeLayerLines :CAShapeLayer
    private var mShapeLayerSquares :CAShapeLayer
    private var mShapeLayerPath :CAShapeLayer
    private var mShapeLayerStartEnd :CAShapeLayer
    private var mMultiplierWidth = 0
    private var mMultiplierHeight = 0
    private var mScale = 1
    private var mViewWidth :Int = 0
    private var mViewHeight :Int = 0
    private var mMapWidth :Int = 0
    private var mMapHeight :Int = 0
    var offsetX :CGFloat = 0
    var offsetY :CGFloat = 0
    private var translationX :CGFloat = 0
    private var translationY :CGFloat = 0
    private var mIsSetStart = false
    private var mIsSetEnd = false
    
    public required init?(coder aDecoder: NSCoder) {
        mArraySquares = []
        mArraySquaresPath = []
        mArrayYX = [[]]
        mShapeLayerLines = CAShapeLayer()
        mShapeLayerSquares = CAShapeLayer()
        mShapeLayerPath = CAShapeLayer()
        mShapeLayerStartEnd = CAShapeLayer()
        super.init(coder: aDecoder);
        loadViewFromNib()
    }
    
    public override init(frame: CGRect) {
        mArraySquares = []
        mArraySquaresPath = []
        mArrayYX = [[]]
        mShapeLayerLines = CAShapeLayer()
        mShapeLayerSquares = CAShapeLayer()
        mShapeLayerPath = CAShapeLayer()
        mShapeLayerStartEnd = CAShapeLayer()
        super.init(frame: frame);
        loadViewFromNib()
    }
    
    private func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        addSubview(view)
        
        let recognizer :UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.onTapGesture(_:)))
        self.addGestureRecognizer(recognizer)
        let panRecognizer :UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.onPanGesture(_:)))
        self.addGestureRecognizer(panRecognizer)
        let pinchRecognizer :UIPinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(self.onPinchGesture(_:)))
        self.addGestureRecognizer(pinchRecognizer)
        
        self.layer.addSublayer(mShapeLayerLines)
        self.layer.addSublayer(mShapeLayerSquares)
        self.layer.addSublayer(mShapeLayerPath)
        self.layer.addSublayer(mShapeLayerStartEnd)
        
        //print("\(#line), \(#function), self.width=\(view.frame.width), self.height=\(view.frame.height)")
        mViewWidth = Int(view.frame.width)
        mViewHeight = Int(view.frame.height)
        
        setSize(width: mViewWidth, height: mViewHeight)
    }
    
    public func setSize(width: Int, height: Int) {
        mMapWidth = width
        mMapHeight = height
        //fill mArrayYX
        mMultiplierWidth = Int(width / AstarView.sSquareSize)
        mMultiplierHeight = Int(height / AstarView.sSquareSize)
        mArrayYX.removeAll()
        for indexY in 0..<mMultiplierHeight {
            mArrayYX.append([])
            for _ in 0..<mMultiplierWidth {
                mArrayYX[indexY].append(AstarView.kSquareSpace)
            }
        }
        print("\(#line), \(#function), mArrayYX.count=\(mArrayYX.count), mArrayYX[0].count=\(mArrayYX[0].count)")
        
        displayGrid(width: width, height: height, squareSize: AstarView.sSquareSize)
    }
    
    public func displayGrid(width: Int, height: Int, squareSize: Int) {
        let mapWidth = squareSize * mMultiplierWidth
        let mapHeight = squareSize * mMultiplierHeight
        
        //draw lines
        let path = UIBezierPath()
        var positionX = 0
        var positionY = Int(offsetY)
        if offsetX > 0.0 {positionX = Int(offsetX)}
        //draw horizontal lines
        while (positionY <= self.mViewHeight && positionY <= (mMapHeight + Int(offsetY))) {
            var endX :Double
            if mapWidth > mViewWidth && offsetX >= 0.0 {
                endX = Double(mViewWidth)
            } else {
                endX = Double(mapWidth + Int(offsetX))
            }
            if Int(endX) > self.mViewWidth {
                endX = Double(self.mViewWidth)
            }
            if positionY >= 0 {
                path.move(to: CGPoint(x: positionX, y: positionY))
                path.addLine(to: CGPoint(x: endX, y: Double(positionY)))
            }
            positionY += squareSize
        }
        positionX = Int(offsetX)
        positionY = 0
        if offsetY > 0.0 {positionY = Int(offsetY)}
        //draw vertical lines
        while (positionX <= self.mViewWidth && positionX <= (mMapWidth + Int(offsetX))) {
            var endY :Double
            if mapHeight > mViewHeight && offsetY >= 0.0 {
                endY = Double(mViewHeight)
            } else {
                endY = Double(mapHeight + Int(offsetY))
            }
            if Int(endY) > self.mViewHeight {
                endY = Double(self.mViewHeight)
            }
            path.move(to: CGPoint(x: positionX, y: positionY))
            path.addLine(to: CGPoint(x: Double(positionX), y: endY))
            positionX += squareSize
        }
        
        path.close()
        mShapeLayerLines.path = path.cgPath
        mShapeLayerLines.lineWidth = 2.0
        mShapeLayerLines.strokeColor = UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0).cgColor

        displaySquares(squareSize: squareSize)
    }
    
    public func displaySquares(squareSize :Int) {
        mArraySquares.removeAll()
        for indexY in mArrayYX.indices {
            for indexX in mArrayYX[indexY].indices {
                let code = mArrayYX[indexY][indexX]
                if((indexX * squareSize) + Int(offsetX) > self.mViewWidth)
                    || ((indexY * squareSize) + Int(offsetY) > self.mViewHeight)
                {
                    if code == AstarView.kSquareStart {
                        mSquareStart = nil
                    } else if code == AstarView.kSquareTarget {
                        mSquareEnd = nil
                    }
                    continue
                }
                if code == AstarView.kSquareWall {
                    mArraySquares.append(CGRect.init(x: indexX * squareSize, y: indexY * squareSize, width: squareSize, height: squareSize))
                } else if code == AstarView.kSquareStart {
                    mSquareStart = CGRect.init(x: indexX * squareSize, y: indexY * squareSize, width: squareSize, height: squareSize)
                } else if code == AstarView.kSquareTarget {
                    mSquareEnd = CGRect.init(x: indexX * squareSize, y: indexY * squareSize, width: squareSize, height: squareSize)
                }
            }
        }
        
        //fill squares
        let pathSquare = UIBezierPath()
        for rect in mArraySquares {
            var x = rect.origin.x + rect.width + offsetX
            var y = rect.origin.y + rect.height + offsetY
            if Int(x) > self.mViewWidth {x = CGFloat(self.mViewWidth)}
            if Int(y) > self.mViewHeight {y = CGFloat(self.mViewHeight)}
            pathSquare.move(to: CGPoint(x: rect.origin.x + offsetX, y: rect.origin.y + offsetY))
            pathSquare.addLine(to: CGPoint(x: x, y: rect.origin.y + offsetY))
            pathSquare.addLine(to: CGPoint(x: x, y: y))
            pathSquare.addLine(to: CGPoint(x: rect.origin.x + offsetX, y: y))
            pathSquare.addLine(to: CGPoint(x: rect.origin.x + offsetX, y: rect.origin.y + offsetY))
        }
        
        let pathStartEnd = UIBezierPath()
        if mSquareStart != nil {
            let rect = mSquareStart!
            var x = rect.origin.x + rect.width + offsetX
            var y = rect.origin.y + rect.height + offsetY
            if Int(x) > self.mViewWidth {x = CGFloat(self.mViewWidth)}
            if Int(y) > self.mViewHeight {y = CGFloat(self.mViewHeight)}
            pathStartEnd.move(to: CGPoint(x: rect.origin.x + offsetX, y: rect.origin.y + offsetY))
            pathStartEnd.addLine(to: CGPoint(x: x, y: rect.origin.y + offsetY))
            pathStartEnd.addLine(to: CGPoint(x: x, y: y))
            pathStartEnd.addLine(to: CGPoint(x: rect.origin.x + offsetX, y: y))
            pathStartEnd.addLine(to: CGPoint(x: rect.origin.x + offsetX, y: rect.origin.y + offsetY))
        }
        if mSquareEnd != nil {
            let rect = mSquareEnd!
            var x = rect.origin.x + rect.width + offsetX
            var y = rect.origin.y + rect.height + offsetY
            if Int(x) > self.mViewWidth {x = CGFloat(self.mViewWidth)}
            if Int(y) > self.mViewHeight {y = CGFloat(self.mViewHeight)}
            pathStartEnd.move(to: CGPoint(x: rect.origin.x + offsetX, y: rect.origin.y + offsetY))
            pathStartEnd.addLine(to: CGPoint(x: x, y: rect.origin.y + offsetY))
            pathStartEnd.addLine(to: CGPoint(x: x, y: y))
            pathStartEnd.addLine(to: CGPoint(x: rect.origin.x + offsetX, y: y))
            pathStartEnd.addLine(to: CGPoint(x: rect.origin.x + offsetX, y: rect.origin.y + offsetY))
        }
        
        if(mSquareStart != nil || mSquareEnd != nil) {pathStartEnd.close()}
        if mArraySquares.count > 0 {pathSquare.close()}
        mShapeLayerSquares.fillColor = UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
        mShapeLayerSquares.path = pathSquare.cgPath
        mShapeLayerStartEnd.fillColor = UIColor.init(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0).cgColor
            mShapeLayerStartEnd.path = pathStartEnd.cgPath
        
        displayPath(squareSize: AstarView.sSquareSize)
    }
    
    public func displayPath(squareSize :Int) {
        mArraySquaresPath.removeAll()
        for indexY in mArrayYX.indices {
            for indexX in mArrayYX[indexY].indices {
                let code = mArrayYX[indexY][indexX]
                if code == AstarView.kSquarePath {
                    if((indexX * squareSize) + Int(offsetX) > self.mViewWidth)
                        || ((indexY * squareSize) + Int(offsetY) > self.mViewHeight)
                    {
                        continue
                    }
                    mArraySquaresPath.append(CGRect.init(x: indexX * squareSize, y: indexY * squareSize, width: squareSize, height: squareSize))
                }
            }
        }
        
        //fill squares
        let pathSquare = UIBezierPath()
        for rect in mArraySquaresPath {
            var x = rect.origin.x + rect.width + offsetX
            var y = rect.origin.y + rect.height + offsetY
            if Int(x) > self.mViewWidth {x = CGFloat(self.mViewWidth)}
            if Int(y) > self.mViewHeight {y = CGFloat(self.mViewHeight)}
            pathSquare.move(to: CGPoint(x: rect.origin.x + offsetX, y: rect.origin.y + offsetY))
            pathSquare.addLine(to: CGPoint(x: x, y: rect.origin.y + offsetY))
            pathSquare.addLine(to: CGPoint(x: x, y: y))
            pathSquare.addLine(to: CGPoint(x: rect.origin.x + offsetX, y: y))
            pathSquare.addLine(to: CGPoint(x: rect.origin.x + offsetX, y: rect.origin.y + offsetY))
        }
        
        if mArraySquaresPath.count > 0 {pathSquare.close()}
        mShapeLayerPath.fillColor = UIColor.init(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0).cgColor
        mShapeLayerPath.path = pathSquare.cgPath
    }
    
    public func setStart() {
        mIsSetStart = true
        mIsSetEnd = false
        let width = mArrayYX[0].count
        let height = mArrayYX.count
        for x in 0..<width {
            for y in 0..<height {
                let symbol = mArrayYX[y][x]
                if symbol == AstarView.kSquareStart {
                    mArrayYX[y][x] = AstarView.kSquareSpace
                }
            }
        }
    }
    
    public func setEnd() {
        mIsSetEnd = true
        mIsSetStart = false
        let width = mArrayYX[0].count
        let height = mArrayYX.count
        for x in 0..<width {
            for y in 0..<height {
                let symbol = mArrayYX[y][x]
                if symbol == AstarView.kSquareTarget {
                    mArrayYX[y][x] = AstarView.kSquareSpace
                }
            }
        }
    }
    
    public func clear() {
        mSquareStart = nil
        mSquareEnd = nil
        for indexY in mArrayYX.indices {
            for indexX in mArrayYX[indexY].indices {
                mArrayYX[indexY][indexX] = AstarView.kSquareSpace
            }
        }
        displaySquares(squareSize: AstarView.sSquareSize)
    }
    
    public func clearPath() {
        let width = mArrayYX[0].count
        let height = mArrayYX.count
        for x in 0..<width {
            for y in 0..<height {
                let symbol = mArrayYX[y][x]
                if symbol == AstarView.kSquarePath {
                    mArrayYX[y][x] = AstarView.kSquareSpace
                }
            }
        }
    }
    
    @objc func onTapGesture(_ tapGestureRecognizer :UITapGestureRecognizer) {
        let touchPoint :CGPoint = tapGestureRecognizer.location(in: self)
        
        let alphaX = Int(touchPoint.x - self.offsetX)
        let alphaY = Int(touchPoint.y - self.offsetY)
        let indexX = alphaX / AstarView.sSquareSize
        let indexY = alphaY / AstarView.sSquareSize
        if (indexX >= mMultiplierWidth
            || indexY >= mMultiplierHeight
            || alphaX < 0
            || alphaY < 0)
        {
            return
        }
        
        var value = mArrayYX[indexY][indexX]
        //print("\(#function), touchPoint=\(touchPoint), indexX=\(indexX), indexY=\(indexY), value=\(value), offsetX=\(offsetX)")
        if value == AstarView.kSquareSpace {
            value = AstarView.kSquareWall
        } else if value == AstarView.kSquareWall {
            value = AstarView.kSquareSpace
        }
        if mIsSetStart {
            mIsSetStart = false
            value = AstarView.kSquareStart
        } else if mIsSetEnd {
            mIsSetEnd = false
            value = AstarView.kSquareTarget
        }
        mArrayYX[indexY][indexX] = value
        
        displaySquares(squareSize: AstarView.sSquareSize)
    }
    
    @objc func onPanGesture(_ panGestureRecognizer :UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: self)
        //print("\(#function), translation=\(translation), state=\(panGestureRecognizer.state.rawValue)")
        
        if(mMapWidth > mViewWidth) {
            self.offsetX = self.translationX + translation.x
            if(self.offsetX > 0) {
                self.offsetX = 0
            }
        }
        if(mMapHeight > mViewHeight) {
            self.offsetY = self.translationY + translation.y
            if(self.offsetY > 0) {
                self.offsetY = 0
            }
        }

        if panGestureRecognizer.state == UIGestureRecognizerState.ended {
            self.translationX = self.offsetX
            self.translationY = self.offsetY
        }
        
        displayGrid(width: mMapWidth, height: mMapHeight, squareSize: AstarView.sSquareSize)
    }
    
    @objc func onPinchGesture(_ pinchGestureRecognizer :UIPinchGestureRecognizer) {
        //print("\(#line), \(#function), scale=\(pinchGestureRecognizer.scale)")
        if pinchGestureRecognizer.scale <= 1.0 {
            AstarView.sSquareSize = Int(CGFloat(AstarView.kSquareSize) * pinchGestureRecognizer.scale)
        } else {
            AstarView.sSquareSize = Int(CGFloat(AstarView.sSquareSize) * pinchGestureRecognizer.scale)
        }
        if AstarView.sSquareSize > AstarView.kSquareSize {
            AstarView.sSquareSize = AstarView.kSquareSize
        }
        
        mMapWidth = mMultiplierWidth * AstarView.sSquareSize
        mMapHeight = mMultiplierHeight * AstarView.sSquareSize
        
        displayGrid(width: mMapWidth, height: mMapHeight, squareSize: AstarView.sSquareSize)
    }
}
