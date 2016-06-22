//
//  FaceViewController.swift
//  faceDetectionDemo2
//
//  Created by 雪 禹 on 6/21/16.
//  Copyright © 2016 XueYu. All rights reserved.
//

import UIKit
import AVFoundation

class FaceViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    var faceRectCALayer: CALayer!
    
    private var currentCameraFace: AVCaptureDevice?
    private var sessionQueue: dispatch_queue_t = dispatch_queue_create("videoQueue", DISPATCH_QUEUE_SERIAL)
    
    private var session: AVCaptureSession!
    private var backCameraDevice: AVCaptureDevice?
    private var frontCameraDevice: AVCaptureDevice?
    private var metadataOutput: AVCaptureMetadataOutput!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSession()
        setupPreview()
        setupFace()
        startSession()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Setup session and preview
    
    func setupSession(){
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        let avaliableCameraDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for device in avaliableCameraDevices as! [AVCaptureDevice]{
            if device.position == .Back {
                backCameraDevice = device
            } else if device.position == .Front{
                frontCameraDevice = device
            }
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCameraDevice)
            if session.canAddInput(input){
                session.addInput(input)
            }
        } catch {
            print("Error handling the camera Input: \(error)")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()

        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: sessionQueue)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeFace]
        }
        

    }
    
    
    func setupPreview(){
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    
    
    func startSession() {
        if !session.running{
            session.startRunning()
        }
    }
    
    func setupFace(){
        faceRectCALayer = CALayer()
        faceRectCALayer.zPosition = 1
        faceRectCALayer.borderColor = UIColor.redColor().CGColor
        faceRectCALayer.borderWidth = 3.0

        previewLayer.addSublayer(faceRectCALayer)
    }
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        var faces = [CGRect]()
        
        for metadataObject in metadataObjects as! [AVMetadataObject] {
            if metadataObject.type == AVMetadataObjectTypeFace {
                    let transformedMetadataObject = previewLayer.transformedMetadataObjectForMetadataObject(metadataObject)
                    let face = transformedMetadataObject.bounds
                    faces.append(face)
            }
        }
        
        print("FACE",faces)
        
        if faces.count > 0 {
            setlayerHidden(false)
            dispatch_async(dispatch_get_main_queue(), {
                () -> Void in
                self.faceRectCALayer.frame = self.findMaxFaceRect(faces)
            })
        } else {
            setlayerHidden(true)
        }
    }
    
    func setlayerHidden(hidden: Bool) {
        if (faceRectCALayer.hidden != hidden){
            print("hidden:" ,hidden)
            dispatch_async(dispatch_get_main_queue(), { 
                () -> Void in
                self.faceRectCALayer.hidden = hidden
            })
        }
    }
    
    func findMaxFaceRect(faces : Array<CGRect>) -> CGRect {
        if (faces.count == 1) {
            return faces[0]
        }
        var maxFace = CGRect.zero
        var maxFace_size = maxFace.size.width + maxFace.size.height
        for face in faces {
            let face_size = face.size.width + face.size.height
            if (face_size > maxFace_size) {
                maxFace = face
                maxFace_size = face_size
            }
        }
        return maxFace
    }
    

    

}
