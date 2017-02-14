//
//  ViewController.swift
//  saveImagesAsGif
//
//  Created by 雪 禹 on 2/13/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let images = [ UIImage(named:"1.jpg")!,
                       UIImage(named:"2.jpg")!,
                       UIImage(named:"3.jpg")!,
                       UIImage(named:"4.jpg")!,
                       UIImage(named:"5.jpg")!]

        imageView.animationImages =   images
        
        imageView.animationDuration = 0.5
        imageView.startAnimating()
        
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory,
                                                           in: .userDomainMask).first
        let path = documentsURL!.appendingPathComponent("1.gif")
        createGIF(with: images, name: path, frameDelay: 0.1)
        print(path)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createGIF(with images: [UIImage], name: URL, loopCount: Int = 0, frameDelay: Double) {
        
        let destinationURL = name
        let destinationGIF = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypeGIF, images.count, nil)!
        
        // This dictionary controls the delay between frames
        // If you don't specify this, CGImage will apply a default delay
        let properties = [
            (kCGImagePropertyGIFDictionary as String): [(kCGImagePropertyGIFDelayTime as String): frameDelay]
        ]
        
        
        for img in images {
            // Convert an UIImage to CGImage, fitting within the specified rect
            let cgImage = img.cgImage
            // Add the frame to the GIF image
            CGImageDestinationAddImage(destinationGIF, cgImage!, properties as CFDictionary?)
        }
        
        // Write the GIF file to disk
        CGImageDestinationFinalize(destinationGIF)
    }
}

