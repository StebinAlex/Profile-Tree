//
//  TreeView.swift
//  Tree
//
//  Created by Stebin Alex on 29/12/21.
//

import UIKit

class TreeView: UIView {

    //MARK:- Views
    let scrollView: UIScrollView = {
        let s = UIScrollView()
        s.backgroundColor = .white
        s.showsVerticalScrollIndicator = true
        s.showsHorizontalScrollIndicator = false
        s.isScrollEnabled = true
        return s
    }()
    
    let baseView: UIView = {
        let s = UIView()
        return s
    }()
     
    //MARK:- Frame
    var mainNodeFrame: CGRect {
        get {
            return CGRect(x: 20, y: 20, width: frame.width - 40, height: 60)
        }
    }
     
    private func subNodeFrame(index: Int, previousValue: TreeModel?) -> CGRect {
        
        var y: CGFloat = 100
        if let prevFrame = previousSubNodeFrame {
            y = prevFrame.origin.y + 80
        }
        
        if let prev = previousValue {
            if prev.selected {
                y += CGFloat((prev.items?.count ?? 0) * 80)
            }
        }
        return CGRect(x: frame.width - ( mainNodeFrame.width * 0.8 + 20), y: y, width: mainNodeFrame.width * 0.8, height: 60)
    }
    
    private func childNodeFrame(index: Int) -> CGRect {
        var y: CGFloat = 0
        if let prevFrame = previousSubNodeFrame {
            y = prevFrame.origin.y + 80
        }
        y += CGFloat(index * 80)
        return CGRect(x: frame.width - ( mainNodeFrame.width * 0.6 + 20), y: y, width: mainNodeFrame.width * 0.6, height: 60)
    }
    
    
    private var mainNodeStartingPoint: CGPoint {
        get {
            let main = mainNodeFrame
            return CGPoint(x: main.origin.x + (main.width * 0.125), y: main.origin.y + main.height)
        }
    }
    
    
    //MARK:- Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var data: TreeModel?
    
    fileprivate func createSubViews(_ data: TreeModel) {
        baseView.addSubview(createMainNode(data))
        scrollView.layer.addSublayer(createCircle(center: mainNodeStartingPoint, radius: 8, color: UIColor(named: "MainColor")!))
        
        if data.items != nil && data.selected {
            if let subItems = data.items {
                for i in 0..<subItems.count {
                    let subNode = createSubNode(subItems[i], previousData: i > 0 ? subItems[i-1] : nil, index: i)
                    baseView.addSubview(subNode)
                    let point = CGPoint(x: subNode.frame.origin.x + 2.5, y: subNode.frame.origin.y + (subNode.frame.height / 2))
                    scrollView.layer.addSublayer(createConnectingPath(node: data, startingPoint: CGPoint(x: mainNodeStartingPoint.x,y: mainNodeStartingPoint.y + 8), endPoint: point, color: UIColor(named: "MainColor")!))
                    scrollView.layer.addSublayer(createCircle(center: point, color: UIColor(named: "MainColor")!))
                    
                    if subItems[i].items != nil && subItems[i].selected {
                        if let childItems = subItems[i].items {
                            let subBottomPoint = CGPoint(x: subNode.frame.origin.x + (subNode.frame.width * 0.125), y: subNode.frame.origin.y + subNode.frame.height)
                            scrollView.layer.addSublayer(createCircle(center: subBottomPoint, radius: 8))
                            for j in 0..<childItems.count {
                                
                                let childNode = createChildNode(childItems[j], childIndex: j)
                                baseView.addSubview(childNode)
                                let childPoint = CGPoint(x: childNode.frame.origin.x + 2.5, y: childNode.frame.origin.y + (subNode.frame.height / 2))
                                scrollView.layer.addSublayer(createConnectingPath(node: subItems[i], startingPoint: CGPoint(x: subBottomPoint.x, y: subBottomPoint.y + 8), endPoint: childPoint))
                                scrollView.layer.addSublayer(createCircle(center: childPoint))
                            }
                        }
                    }
                }
            }
        }
        if let selectedNodeName = selectedNodeName {
            pathLayers.filter {$0.name == selectedNodeName}.map {$0.layer}.forEach{ (lyr) in
                progressAnimation(duration: 1.0, progressLayer: lyr)
            }
        } else {
            pathLayers.map{$0.layer}.forEach { (lyr) in
                progressAnimation(duration: 1.0, progressLayer: lyr)
            }
        }
    }
    
    var heightConstraint: NSLayoutConstraint?
    func setupData(_ data: TreeModel) {
        self.data = data
        var count = 1
        if data.items != nil && data.selected {
            count += data.items!.count
            for i in data.items! {
                if i.items != nil && i.selected {
                    count += i.items!.count
                }
            }
        }
        print(count)
        let height = count * 80
        scrollView.frame = bounds
        scrollView.contentSize = CGSize(width: frame.width, height: CGFloat(height))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.anchorToSuperView()
        
        scrollView.addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        baseView.anchorToSuperView()
        baseView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        heightConstraint = baseView.heightAnchor.constraint(equalToConstant: CGFloat(height))
        heightConstraint?.isActive = true
        createSubViews(data)
         
    }

    private func createMainNode(_ data: TreeModel) -> UIView {
        let main = UIView(frame: mainNodeFrame)
        main.backgroundColor = UIColor(named: "MainColor")
        main.layer.cornerRadius = main.frame.height/2
         
        /*let imgVw = UIImageView(frame: CGRect(x: main.frame.width - 58, y: 2, width: 56, height: 56))
        imgVw.image = UIImage(named: "me")
        imgVw.contentMode = .scaleAspectFill
        imgVw.layer.cornerRadius = imgVw.frame.height / 2
        imgVw.clipsToBounds = true
        main.addSubview(imgVw)*/
        
        let lbl = UILabel(frame: CGRect(x: 20, y: 0, width: main.frame.width - 40, height: main.frame.height))
        lbl.text = data.name
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20)
        main.addSubview(lbl)
         
        return main
    }
    
    
    
    
    private var previousSubNodeFrame: CGRect?
    
    private func createSubNode(_ subData: TreeModel, previousData: TreeModel?, index: Int) -> UIView {
        let frame = subNodeFrame(index: index, previousValue: previousData)
        previousSubNodeFrame = frame
        let sub = UIView(frame: frame)
        sub.backgroundColor = .white
        sub.layer.cornerRadius = sub.frame.height/2
        sub.layer.borderWidth = 2.0
        sub.layer.borderColor = (UIColor(named: "SecondaryColor") ?? .gray).cgColor
        
        let lbl = UILabel(frame: CGRect(x: 70, y: 0, width: sub.frame.width - 90, height: sub.frame.height))
        lbl.text = subData.name
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 20)
        sub.addSubview(lbl)
        
        let imgVw = UIImageView(frame: CGRect(x: 20, y: 15, width: 30, height: 30))
        imgVw.image = subData.icon
        sub.addSubview(imgVw)
        
        let btn = UIButton(type: .system)
        btn.frame = sub.bounds
        btn.tag = index
        //btn.showsTouchWhenHighlighted = true
        btn.addTarget(self, action: #selector(btnPressed(_:)), for: .touchUpInside)
        sub.addSubview(btn)
        
        return sub
    }
    var selectedNodeName: String?
    @objc func btnPressed(_ sender: UIButton) {
        print("Pressed")
        for i in 0..<(data?.items!.count)!  {
            if i == sender.tag {
                let bool: Bool = data?.items![i].selected ?? true
                data?.items![i].selected = !bool
                selectedNodeName = data?.items![i].name
            }
        }
        
        if let data = data {
            var count = 1
            if data.items != nil && data.selected {
                count += data.items!.count
                for i in data.items! {
                    if i.items != nil && i.selected {
                        count += i.items!.count
                    }
                }
            }
            DispatchQueue.main.async { [self] in
                let height = count * 80
                scrollView.contentSize = CGSize(width: frame.width, height: CGFloat(height))
                heightConstraint?.isActive = false
                heightConstraint = baseView.heightAnchor.constraint(equalToConstant: CGFloat(height))
                heightConstraint?.isActive = true
                self.layoutIfNeeded()
                
                pathLayers.forEach({ (lyr) in
                    lyr.layer.removeFromSuperlayer()
                    lyr.layer.removeAllAnimations()
                })
                circleLayers.forEach({ (lyr) in
                    lyr.removeFromSuperlayer()
                    lyr.removeAllAnimations()
                })
                previousSubNodeFrame = nil
                baseView.subviews.forEach{$0.removeFromSuperview()}
                createSubViews(data)
            }
        }
    }
    
    
    private func createChildNode(_ childData: TreeModel, childIndex: Int) -> UIView {
        let child = UIView(frame: childNodeFrame(index: childIndex))
        child.backgroundColor = UIColor(named: "SecondaryColor") ?? .gray
        child.layer.cornerRadius = child.frame.height/2
        
        let lbl = MarqueeLabel(frame: CGRect(x: 20, y: 0, width: child.frame.width - 40, height: child.frame.height), duration: 15.0, fadeLength: 10.0)
        lbl.text = childData.name
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 17)
        child.addSubview(lbl)
         
        return child
    }
    
    
    //MARK:- Paths
    var circleLayers: [CAShapeLayer] = []
    var pathLayers: [PathLayer] = []
    private func createCircle(center: CGPoint,radius: CGFloat = 5, color: UIColor = UIColor(named: "SecondaryColor") ?? .gray ) -> CAShapeLayer {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: center.x, y: center.y), radius: radius, startAngle: -.pi/2, endAngle: .pi * 2, clockwise: true)
        let circleLayer = CAShapeLayer()
        circleLayer.path = path.cgPath
        circleLayer.fillColor = UIColor.white.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 2.0
        circleLayer.strokeColor = color.cgColor
        circleLayers.append(circleLayer)
        return circleLayer
    }
    
    
    private func findCornerOfPoints(startingPoint: CGPoint, endPoint: CGPoint) -> CGPoint {
        let point = CGPoint(x: startingPoint.y - 10, y: endPoint.x - 10)
        return point
    }
    
    private func findPreviosOfPoints(startingPoint: CGPoint, endPoint: CGPoint) -> CGPoint {
        let point = CGPoint(x: startingPoint.x - 20, y: endPoint.y + 20)
        print(startingPoint, point, endPoint)
        return point
    }
    
    private func createConnectingPath(node: TreeModel, startingPoint: CGPoint, endPoint: CGPoint, color: UIColor = UIColor(named: "SecondaryColor") ?? .gray) -> CAShapeLayer {
        let path = UIBezierPath()
        path.move(to: startingPoint)
        path.addLine(to: CGPoint(x: startingPoint.x, y: endPoint.y - 20))
        path.addArc(withCenter: CGPoint(x: path.currentPoint.x + 20, y: path.currentPoint.y), radius: 20, startAngle: .pi, endAngle: .pi/2 , clockwise: false)
        path.addLine(to: endPoint)
        let circleLayer = CAShapeLayer()
        circleLayer.path = path.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 2.0
        circleLayer.strokeColor = color.cgColor
        pathLayers.append(PathLayer(layer: circleLayer, name: node.name))
        
        return circleLayer
    }
    
    func progressAnimation(duration: TimeInterval, progressLayer: CAShapeLayer) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.fromValue = 0.0
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.duration = duration
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
 
