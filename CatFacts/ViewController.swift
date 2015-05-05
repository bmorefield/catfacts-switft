//
//  ViewController.swift
//  CatFacts
//
//  Created by Bill Morefield on 6/3/14.
//  Copyright (c) 2014 Bill Morefield. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var catFact: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get size of the image view in pixels
        var imageWidth = Int(self.catImage.frame.size.width) * Int(UIScreen.mainScreen().scale);
        var imageHeight = Int(self.catImage.frame.size.height) * Int(UIScreen.mainScreen().scale);
        
        // Load photo
        loadCatPhoto(imageWidth, imageHeight: imageHeight)
        
        // Load Fact
        loadCatFact()
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCatPhoto(imageWidth: Int, imageHeight: Int)
    {
        // Now load a cat photo
        var placeKittenUrl = "http://placekitten.com/g/\(imageWidth)/\(imageHeight)"
        let url = NSURL(fileURLWithPath: placeKittenUrl)
        var urlRequest = NSURLRequest(URL: url!)
        let urlConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlSession = NSURLSession(configuration: urlConfig)
        var dataTask : NSURLSessionDataTask = urlSession.dataTaskWithRequest(urlRequest, completionHandler:
            {data, response, error in
                if(error == nil)
                {
                    let downloadedImage:UIImage = UIImage(data: data)!
                        dispatch_async(dispatch_get_main_queue(), {
                            self.catImage.image = downloadedImage;
                            self.catImage.setNeedsDisplay()
                        })
                        println("Loaded Cat Image Sized \(imageWidth) x \(imageHeight)")
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.catImage.image = nil;
                        self.catImage.setNeedsDisplay()
                    })
                    println("Error Getting Image \(error)")
                }
            })
        
        // Start the download
        dataTask.resume()
    }
    
    func loadCatFact()
    {
        // Now load a fact abouts cats
        var catFactUrl = "http://catfacts-api.appspot.com/api/facts?number=1"
        var url = NSURL(fileURLWithPath: catFactUrl)
        var urlRequest = NSURLRequest(URL: url!)
        let urlConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let urlSession = NSURLSession(configuration: urlConfig)
        var dataTask :NSURLSessionDataTask = urlSession.dataTaskWithRequest(urlRequest, completionHandler:
            {data, response, error in
                if(error == nil)
                {
                    var dataDictonary: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                    var returnedFacts = dataDictonary["facts"] as! NSArray
                    var firstFact = "\(returnedFacts[0])"
                    dispatch_async(dispatch_get_main_queue(), {
                        self.catFact.text = firstFact
                        self.catFact.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
                        self.catFact.setNeedsDisplay()
                    })
                    println("Returned Fact: \(firstFact)")
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.catFact.text = "Unable to load fact at this time."
                        self.catFact.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
                        self.catFact.setNeedsDisplay()
                    })
                    println("Error Loading Fact: \(error)")
                }
            })
        
        // Start the download
        dataTask.resume()
    }
}

