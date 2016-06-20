//
//  ViewController.swift
//  imagePickerDemo
//
//  Created by 雪 禹 on 6/20/16.
//  Copyright © 2016 XueYu. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    let imagePickerController = UIImagePickerController()
    var videoURL: NSURL?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func selectImageFromPhotoLibrary(sender: UIBarButtonItem) {
   
        
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image", "public.movie"]
 
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    
    func previewImageFromVideo(url:NSURL) -> UIImage? {
        let asset = AVAsset(URL:url)
        let imageGenerator = AVAssetImageGenerator(asset:asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value,2)
        
        do {
            let imageRef = try imageGenerator.copyCGImageAtTime(time, actualTime: nil)
            return UIImage(CGImage: imageRef)
        } catch {
            return nil
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        videoURL = info["UIImagePickerControllerReferenceURL"] as? NSURL
        
        print(videoURL)
        
        imageView.image = previewImageFromVideo(videoURL!)!
        
        imageView.contentMode = .ScaleAspectFit
        
        imagePickerController.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        imagePickerController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func videoTapped(sender: UITapGestureRecognizer) {
        
        print("button tapped")
        
        if let videoURL = videoURL{
            
            let player = AVPlayer(URL: videoURL)
            
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            presentViewController(playerViewController, animated: true){
                playerViewController.player!.play()
            }
        }

        
    }
    



}

