//
//  ViewController.swift
//  ARDicee
//
//  Created by Aleksandr Kurdiukov on 12.04.21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   self.sceneView.debugOptions = [.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
     //   sceneView.showsStatistics = true
        
       // let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
        let sphere = SCNSphere(radius: 0.3)



        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/mars.jpeg")
        sphere.materials = [material]

        let node = SCNNode()
        node.position = SCNVector3(0, 0.1, -0.5)
        node.geometry = sphere
        
        sceneView.scene.rootNode.addChildNode(node)
        
            //    sceneView.autoenablesDefaultLighting = true
        
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.dae")!
//        sceneView.scene = diceScene
//
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//            diceNode.position = SCNVector3(0, 0, -0.3)

  //          sceneView.scene.rootNode.addChildNode(diceNode)
     //   }
        
//                // Create a new scene
//                let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//                // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
    //    configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            
//            let planeAncor = anchor as! ARPlaneAnchor
//            let size: (x: CGFloat, z: CGFloat) = (CGFloat(planeAncor.extent.x), CGFloat(planeAncor.extent.z))
//
//            let plane = SCNPlane(width: size.x, height: size.z)
//
//            let planeNode = SCNNode()
//            planeNode.position = SCNVector3(planeAncor.center.x, 0, planeAncor.center.z)
//            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
//
//            let gridMaterial = SCNMaterial()
//            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
//
//            plane.materials = [gridMaterial]
//            planeNode.geometry = plane
//
//            node.addChildNode(planeNode)
        }
    }
}
