//
//  ViewController.swift
//  PantryDemo
//
//  Created by Kevin Brice on 12/9/16.
//  Copyright © 2016 Kevin Brice. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //Initialize Variables
    var jsonGet:String = ""
    var count = 0
    var saladStatus:Character = "n"
    var beerStatus:Character = "n"
    var chocolateStatus:Character = "n"
    var eggsStatus:Character = "n"
    var oatmealStatus:Character = "n"
    var fruitStatus:Character = "n"
    var stop:Bool = false
    var timer = Timer()
    var shelfCost = 0
    var previousShelfCost = 0
    var first = ""
    var second = ""
    var third = ""
    var fourth = ""
    var fifth = ""
    var recipyFirstLine = ""
    var recipyFull = ""
    var previousRecipyFull = ""
    var landscapeBool = false
    
    
    //Initialize Outlets
    @IBOutlet weak var saladImage: UIImageView!
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var chocolateImage: UIImageView!
    @IBOutlet weak var eggsImage: UIImageView!
    @IBOutlet weak var oatmealImage: UIImageView!
    @IBOutlet weak var fruitImage: UIImageView!
    @IBOutlet weak var infospot: UILabel!
    @IBOutlet weak var toggleOutlet: UIButton!
    @IBOutlet weak var recipyOutlet: UILabel!
    @IBOutlet weak var clickForRecipies: UIButton!
    @IBOutlet weak var titleOutlet: UILabel!
    
    //After Load
    override func viewDidLoad() {
        
      
        //Run Timer Event
        scheduledTimerWithTimeInterval()
        
        //Setup Main View
        super.viewDidLoad()
        
        //Set Welcome Prompt
        toggleOutlet.setTitle("Welcome!", for: .normal)
       
        //Blank 2nd Readout
        infospot.text = ""
   
        //Initialize Orientation Check For Hide
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
  
        //Setup Initiale Direction Bool
        if UIScreen.main.bounds.height > UIScreen.main.bounds.width {
            landscapeBool = false
        } else {    // in landscape
            landscapeBool = true        }
        
        }

    //Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//Orientation Change Function
    func orientationChanged()
    {
        
        //Landscape
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
        {
            toggleOutlet.isHidden = true
            infospot.isHidden = true
            clickForRecipies.isHidden = true
            landscapeBool = true
            
            
            if UIScreen.main.nativeBounds.height < 1137.0 {
            
                    titleOutlet.isHidden = true
            }
            
        }
        
        //Portrait
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation))
        {
            toggleOutlet.isHidden = false
            landscapeBool = false
            titleOutlet.isHidden = false

            //Valid Connection
            if jsonGet.characters.count > 150{
                infospot.isHidden = false
                clickForRecipies.isHidden = false
            }
                
            //Bad Connection
            else{
                infospot.isHidden = true
                clickForRecipies.isHidden = true
                }
            }
        
        
    }
        
    
    //The Main Loop Timer
        func scheduledTimerWithTimeInterval(){
            // Scheduling timer to Call the function **Countdown** with the interval of 1 seconds
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkJson), userInfo: nil, repeats: true)
        }
    
    
    //Toggle Button
    @IBAction func humbleButton(_ sender: Any) {
        if stop == false {
            timer.invalidate()
            toggleOutlet.setTitle("Terminated, Click to Connect", for: .normal)
            stop = true
        }
        
        else if stop == true{
            timer.fire()
            scheduledTimerWithTimeInterval()
            toggleOutlet.setTitle("Attempting Connection", for: .normal)
            stop = false
        }
    }
    
    //Recipies Button
    @IBAction func pressRecipiesButton(_ sender: Any) {
    
        //  Alert
        let Alert = UIAlertController(title: "Available Recipes", message: recipyFull, preferredStyle: .alert)
        
        let DismissButton = UIAlertAction(title: "Close Recipe List", style: .cancel, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
        })
        
        Alert.addAction(DismissButton)
        
        self.present(Alert, animated: true, completion: nil)
        //  End Alert

    
    }
    
    
    //Main Loop
        func checkJson(){
            
            //Reset Recipies
            first = ""
            second = ""
            third = ""
            fourth = ""
            fifth = ""
            recipyFull = ""

            
            //Reset Shelf
            previousShelfCost = shelfCost
            shelfCost = 0
            
        let url = URL(string: "http://kevinjbrice.com/neighborhood/service.php")
        let task = URLSession.shared.dataTask(with: url! as URL) { data, response, error in
            guard let data = data, error == nil else { return }
            self.jsonGet = (NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String)
        }
          task.resume()
        
            //Log Status
            print(jsonGet)
        
            //Image Review
            
            if jsonGet.characters.count < 151{
                toggleOutlet.setTitle("Attempting Connection", for: .normal)
            }
                
                
            //Connects to Json Data
            else
            {
                toggleOutlet.setTitle("Connected, Click to Stop", for: .normal)

                
                
            let saladIndex = jsonGet.index(jsonGet.startIndex, offsetBy: 119)
            saladStatus = jsonGet[saladIndex]
            
            if saladStatus == "n" {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.saladImage.alpha = 0.0
                    }, completion: nil)
                }
            
            if saladStatus == "y" {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.saladImage.alpha = 1.0
                }, completion: nil)
                self.shelfCost = self.shelfCost + 5
            }
            
            let beerIndex = jsonGet.index(jsonGet.startIndex, offsetBy: 55)
            beerStatus = jsonGet[beerIndex]
            
            if beerStatus == "n" {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.beerImage.alpha = 0.0
                }, completion: nil)
            }
            
            if beerStatus == "y" {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.beerImage.alpha = 1.0
                }, completion: nil)
                self.shelfCost = self.shelfCost + 11

            }

            let chocolateIndex = jsonGet.index(jsonGet.startIndex, offsetBy: 89)
            chocolateStatus = jsonGet[chocolateIndex]
            
            if chocolateStatus == "n" {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.chocolateImage.alpha = 0.0
                }, completion: nil)
            }
            
            if chocolateStatus == "y" {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.chocolateImage.alpha = 1.0
                }, completion: nil)
                self.shelfCost = self.shelfCost + 2

                }
            

            let eggsIndex = jsonGet.index(jsonGet.startIndex, offsetBy: 26)
            eggsStatus = jsonGet[eggsIndex]
            
            if eggsStatus == "n" {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.eggsImage.alpha = 0.0
                }, completion: nil)
            }
            
            if eggsStatus == "y" {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.eggsImage.alpha = 1.0
                }, completion: nil)
                self.shelfCost = self.shelfCost + 6

            }
            

            let oatmealIndex = jsonGet.index(jsonGet.startIndex, offsetBy: 151)
            oatmealStatus = jsonGet[oatmealIndex]
            
            if oatmealStatus == "n" {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.oatmealImage.alpha = 0.0
                }, completion: nil)
            }
            
            if oatmealStatus == "y" {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.oatmealImage.alpha = 1.0
                }, completion: nil)
                self.shelfCost = self.shelfCost + 4

            }
            

            let fruitIndex = jsonGet.index(jsonGet.startIndex, offsetBy: 181)
            fruitStatus = jsonGet[fruitIndex]
            
            if fruitStatus == "n" {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.fruitImage.alpha = 0.0
                }, completion: nil)
            }
            
            if fruitStatus == "y" {
                UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.fruitImage.alpha = 1.0
                }, completion: nil)
                self.shelfCost = self.shelfCost + 3

            }
                
                //Check Shelf For Updates
                if (shelfCost != previousShelfCost)
                {
                UIView.animate(withDuration: 0.5, delay: 0.25, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.infospot.alpha = 0.0
                }, completion: nil)
                
                infospot.text = "$" + String(shelfCost) + ".00 on Shelf"
                
                UIView.animate(withDuration: 0.5, delay: 0.25, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.infospot.alpha = 1.0
                }, completion: nil)
                
                }
                
            
                //Recepies Section
                
                //Fruit Salad
                if fruitStatus == "y" && chocolateStatus == "y"{
                first = "- Cocoa Fruit (choclate, fruit) \n"
                }
                
                //Chocolate Brew
                if chocolateStatus == "y" && beerStatus == "y"{
                third = "- Chocolate Brew (choclate, beer) \n"
                }
                
                //Brekfast Scramble
                if eggsStatus == "y" && oatmealStatus == "y" && fruitStatus == "y"{
                    second = "- Egg Scramble (eggs, oatmeal, fruit) \n"
                }

                //Choclate Cookie
                if eggsStatus == "y" && oatmealStatus == "y" && chocolateStatus == "y"{
                    fifth = "- Chocolate Cookie (eggs, oatmeal, cholcoate) \n"
                }
                
                //Fruit Salad
                if fruitStatus == "y" && saladStatus == "y"{
                    fourth = "- Apple Crisp Salad (fruit, salad) \n"
                }


                if landscapeBool == false {
                    
                    
                    infospot.isHidden = false
                    clickForRecipies.isHidden = false
                    
                }
                
                if landscapeBool == true {
                    infospot.isHidden = true
                    clickForRecipies.isHidden = true
                    
                }

recipyFirstLine = "The following Recipies can be made with the ingredients on the shelf:\n\n"
                
                previousRecipyFull = recipyFull
                recipyFull = recipyFirstLine + first + second + third + fourth + fifth
                
                
                if recipyFull.characters.count < 80{
                    UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.clickForRecipies.alpha = 0.0
                    }, completion: nil)

                }
                else{
                    UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.clickForRecipies.alpha = 1.0
                    }, completion: nil)

                }
                
                                
            }
            

    }}

