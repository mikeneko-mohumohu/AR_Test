//
//  Box.swift
//  ARCompass
//
//  Created by 圭佑名生 on 2018/04/03.
//  Copyright © 2018年 mikeneko. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Plane: SCNNode {
    var anchor: ARPlaneAnchor!
    
    private var planeGeometry: SCNBox!
    
    init(anchor initAnchor: ARPlaneAnchor) {
        super.init()
     
        anchor = initAnchor
        
        planeGeometry = SCNBox(width: CGFloat(initAnchor.extent.x), height: 0.01, length: CGFloat(initAnchor.extent.z), chamferRadius: 0)
        
        let planeNode = SCNNode(geometry: planeGeometry)
        
        planeNode.position = SCNVector3Make(initAnchor.center.x, 0, initAnchor.center.z)
        
        planeNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: planeGeometry, options: nil))
        planeGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func update(anchor: ARPlaneAnchor) {
        planeGeometry.width = CGFloat(anchor.extent.x)
        planeGeometry.length = CGFloat(anchor.extent.z)
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        if let node = childNodes.first {
            node.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: planeGeometry, options: nil))
        }
    }
}
