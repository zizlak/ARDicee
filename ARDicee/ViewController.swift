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
    
    //MARK: - Properties
    
    var diceArray = [SCNNode]()
    
    @IBOutlet var sceneView: ARSCNView!
    
    
    //MARK: - IB Methods
    
    @IBAction func deleteTapped(_ sender: UIBarButtonItem) {
        if !diceArray.isEmpty {
            for dice in diceArray {
                dice.removeFromParentNode()
            }
        }
        
    }
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    //MARK: - LifeCicle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.sceneView.debugOptions = [.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        // sceneView.showsStatistics = true
        
        // let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
        // let sphere = SCNSphere(radius: 0.3)
        //
        //
        //        let material = SCNMaterial()
        //        material.diffuse.contents = UIImage(named: "art.scnassets/mars.jpeg")
        //        sphere.materials = [material]
        //
        //        let node = SCNNode()
        //        node.position = SCNVector3(0, 0.1, -0.5)
        //        node.geometry = sphere
        //
        //        sceneView.scene.rootNode.addChildNode(node)
        //
        sceneView.autoenablesDefaultLighting = true
        
        
        
        // Create a new scene
        //   let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //   sceneView.scene = scene
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
    
    
    
    
    //MARK: - Decie Rendering Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            let results = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
            if !results.isEmpty {
                let hitResult = results.first!
                putDice(to: hitResult)
            }
        }
    }
    
    private func putDice(to location: ARHitTestResult) {
        
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.dae")!
        //   sceneView.scene = diceScene
        
        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
            
            diceNode.position = SCNVector3(
                location.worldTransform.columns.3.x,
                location.worldTransform.columns.3.y,
                //  + diceNode.boundingSphere.radius
                location.worldTransform.columns.3.z)
            
            self.diceArray.append(diceNode)
            
            
            sceneView.scene.rootNode.addChildNode(diceNode)
            
            roll(dice: diceNode)
            
        }
    }
    
    
    
    private func roll(dice: SCNNode) {
        func randomFace() -> CGFloat {
            return CGFloat(Float((arc4random_uniform(4) + 1)) * (Float.pi/2)) * 5
        }
        let randomX = randomFace()
        let randomZ = randomFace()
        
        dice.runAction(SCNAction.rotateBy(
                        x: randomX,
                        y: 0,
                        z: randomZ,
                        duration: 1))
    }
    
    private func rollAll() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    
    
    //MARK: - ARSCNViewDelegete Methods
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAncor = anchor as? ARPlaneAnchor else { return }
        
        let planeNode = createPlane(with: planeAncor)
        
        node.addChildNode(planeNode)
    }
    
    private func createPlane(with planeAncor: ARPlaneAnchor) -> SCNNode {
        let size: (x: CGFloat, z: CGFloat) = (CGFloat(planeAncor.extent.x), CGFloat(planeAncor.extent.z))
        
        let plane = SCNPlane(width: size.x, height: size.z)
        
        let planeNode = SCNNode()
        planeNode.position = SCNVector3(planeAncor.center.x, 0, planeAncor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        
        plane.materials = [gridMaterial]
        planeNode.geometry = plane
        
        return planeNode
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
