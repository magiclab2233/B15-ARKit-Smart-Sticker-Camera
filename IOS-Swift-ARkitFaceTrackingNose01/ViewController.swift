//
//  ViewController.swift
//  IOS-Swift-ARkitFaceTrackingNose01
//
//  Created by Pooya on 2018-11-27.
//  Copyright © 2018 Soonin. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    private var faceNode:SCNNode?
    let noseOptions = ["nose01", "nose02", "nose03", "nose04", "nose05", "nose06", "nose07", "nose08", "nose09"]
    let features = ["nose"]
    var featureIndices = [[6]]
    
    private lazy var lab:UILabel = {
        let lab = UILabel(frame: CGRect(x: 50, y: 50, width: self.view.frame.size.width - 100, height: 200))
        lab.text = "点击鼻子，切换不同的贴纸造型"
        lab.textColor = .black
        lab.font = .boldSystemFont(ofSize: 30)
        lab.textAlignment = .center
        lab.backgroundColor = UIColor(white: 1, alpha: 0.3)
        lab.layer.cornerRadius = 12
        return lab
    }()
    
    private lazy var btn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.tag = 0
        btn.frame = CGRect(x: 50, y: 280, width: 200, height: 80)
        btn.setTitle("关闭网格", for: .normal)
        btn.backgroundColor = UIColor(white: 1, alpha: 0.3)
        btn.titleLabel?.font = .systemFont(ofSize: 30)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    private lazy var saveBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 50, y: 390, width: 80, height: 80)
        btn.setTitle("保存", for: .normal)
        btn.backgroundColor = UIColor(white: 1, alpha: 0.3)
        btn.titleLabel?.font = .systemFont(ofSize: 30)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        self.view.addSubview(lab)
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.view.addSubview(saveBtn)
        saveBtn.addTarget(self, action: #selector(saveSnapshotToPhotos), for: .touchUpInside)
    }
    
    @objc func btnClick() {
        if self.btn.tag == 0 {
            self.faceNode?.geometry?.firstMaterial?.transparency = 0.0
            btn.tag = 1
            btn.setTitle("开启网格", for: .normal)
        } else {
            self.faceNode?.geometry?.firstMaterial?.transparency = 1.0
            btn.tag = 0
            btn.setTitle("关闭网格", for: .normal)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuratio = ARFaceTrackingConfiguration()
        
        sceneView.session.run(configuratio)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        let results = sceneView.hitTest(location, options: nil)
        if let result = results.first,
            let node = result.node as? FaceNode {
            node.next()
        }
    }
    
    
    
    func updateFeatures(for node: SCNNode, using anchor: ARFaceAnchor) {
        print(featureIndices)
        for (feature, indices) in zip(features, featureIndices) {
            let child = node.childNode(withName: feature, recursively: false) as? FaceNode
            let vertices = indices.map { anchor.geometry.vertices[$0] }
            child?.updatePosition(for: vertices)
        }
    }
    
       // 捕获当前场景视图的快照并保存到相册
      @objc private func saveSnapshotToPhotos() {
           // 获取当前渲染图像
           let snapshotImage = sceneView.snapshot()
           
           // 保存图像到相册
           UIImageWriteToSavedPhotosAlbum(snapshotImage, self, #selector(imageSavedToAlbum(_:didFinishSavingWithError:contextInfo:)), nil)
       }
       
       // 处理保存操作的回调
       @objc func imageSavedToAlbum(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
           if let error = error {
               // 如果保存失败，显示错误信息
               let alert = UIAlertController(title: "错误", message: "保存图片失败: \(error.localizedDescription)", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "确定", style: .default))
               present(alert, animated: true, completion: nil)
           } else {
               // 保存成功，显示成功提示
               let alert = UIAlertController(title: "成功", message: "图片已经保存到相册", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "确定", style: .default))
               present(alert, animated: true, completion: nil)
           }
       }
       
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let device: MTLDevice!
        device = MTLCreateSystemDefaultDevice()
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return nil
        }
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)
                node.geometry?.firstMaterial?.fillMode = .lines
//        node.geometry?.firstMaterial?.transparency = 0.0
        self.faceNode = node
        
        let noseNode = FaceNode(with: noseOptions)
        noseNode.name = "nose"
        node.addChildNode(noseNode)
        updateFeatures(for: node, using: faceAnchor)
        
        return node
    }
    
    func renderer(
        _ renderer: SCNSceneRenderer,
        didUpdate node: SCNNode,
        for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
        updateFeatures(for: node, using: faceAnchor)
    }
    
    
}

