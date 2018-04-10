//
//  ViewController.swift
//  ARCompass
//
//  Created by 圭佑名生 on 2018/04/03.
//  Copyright © 2018年 mikeneko. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var planes = Array<Plane>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        // Create a new scene
        //let scene = SCNScene(named: "plant.scnassets/indoor plant_02.scn")!
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return  }

        /*
        // 平面ジオメトリ作成
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        // 平面ジオメトリをグリーンの半透明に
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor.green.withAlphaComponent(0.5)
        plane.materials = [planeMaterial]
        
        // 平面ノード作成
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.transform =  SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        node.addChildNode(planeNode)
         */
        
        let plane = Plane(anchor: planeAnchor)
        
        node.addChildNode(plane)
        
        planes.append(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        for plane in planes {
            if plane.anchor.identifier == anchor.identifier,
                let anchor = anchor as? ARPlaneAnchor {
                plane.update(anchor: anchor)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        for (index, plane) in planes.enumerated().reversed() {
            if plane.anchor.identifier == anchor.identifier {
                planes.remove(at: index)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    @IBAction func sceneViewTapped(_ recognizer: UITapGestureRecognizer) {
        
        let tapPoint = recognizer.location(in: sceneView)
        
        let results = sceneView.hitTest(tapPoint, types: .existingPlaneUsingExtent)
        
        guard let hitResult = results.first else { return }
        
        /*
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        cube.firstMaterial?.diffuse.contents = UIColor.brown
        
        let cubeNode = SCNNode(geometry: cube)
        
        let cubeShape = SCNPhysicsShape(geometry: cube, options: nil)
        cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: cubeShape)
        
        cubeNode.position = SCNVector3Make(hitResult.worldTransform.columns.3.x
            , hitResult.worldTransform.columns.3.y + 0.1
            , hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(cubeNode)
         */
        
        let plantScene = SCNScene(named: "plant.scnassets/indoor plant_02.scn")!
        let node = plantScene.rootNode.childNodes[0]
        let modelShape = SCNPhysicsShape(node: node, options: nil)
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: modelShape)
        node.position = SCNVector3Make(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
