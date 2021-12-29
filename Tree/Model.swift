//
//  Model.swift
//  Tree
//
//  Created by Stebin Alex on 29/12/21.
//

import UIKit

struct TreeModel {
    var name: String
    var type: NodeType
    var icon: UIImage?
    var selected: Bool = false
    var items: [TreeModel]?
}


enum NodeType {
    case main
    case sub
    case child
}

 
struct PathLayer {
    var layer: CAShapeLayer
    var name: String
}
