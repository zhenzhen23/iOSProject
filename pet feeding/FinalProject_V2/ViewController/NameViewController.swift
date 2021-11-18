//
//  NameViewController.swift
//  FinalProject_V2
//
//  Created by Wenzhuo Zhao
//  This controller is used to enter a name for the pet and create a new pet
//

import UIKit
import QuartzCore

class NameViewController: UIViewController {
    
    //create the varaibles
    @IBOutlet var tfName : UITextField!
    var imageLayer : CALayer?
    let image = UIImage(named: "logo2.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //display the logo core animation
        displayAnimation()
    }
    
    /*
     author: Wenzhuo Zhao
     get the data from text and create a pet into database
     */
    @IBAction func addPet(sender:UIButton){
        //if the textbox is null, give a alert box
        if((tfName.text?.isEmpty)!){
            let alert = UIAlertController(title: "Warning", message: "Please enter a name", preferredStyle: .alert)
            
            let backAction = UIAlertAction(title: "Back", style: .cancel, handler: nil)
            alert.addAction(backAction)
            present(alert,animated: true)
        }else{
            
            //save to the db
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            let returnCode = mainDelegate.insertIntoPetInfo(name:tfName.text!)
            
            var returnMSG : String = "Welcome"
            let alertController = UIAlertController(title: "Thank you", message: returnMSG, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Welcome", style: .default, handler:
            {(alert : UIAlertAction!) in
                self.performSegue(withIdentifier: "AfterGiveName", sender: nil)
            })
            alertController.addAction((cancelAction))
            present(alertController,animated: true)
        }
        
    }
    
    func textFieldShouldReturn(_ textField : UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    /*
     author: Wenzhuo Zhao
     display the logo core animation
     */
    func displayAnimation(){
        imageLayer = CALayer.init()
        imageLayer?.contents = image?.cgImage
        imageLayer?.bounds = CGRect(x:20,y:74,width:334,height:128)
        imageLayer?.position = CGPoint(x:190,y:100)
        self.view.layer.addSublayer(imageLayer!)
        
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        fadeAnimation.fromValue = NSNumber.init(value : 1.0)
        fadeAnimation.toValue = NSNumber.init(value : 0.0)
        fadeAnimation.isRemovedOnCompletion = false
        
        //set the duration
        fadeAnimation.duration = 3.0
        fadeAnimation.beginTime = 1.0
        fadeAnimation.isAdditive = false
        
        //add animation to the imageLayer
        fadeAnimation.fillMode = CAMediaTimingFillMode.both
        fadeAnimation.repeatCount = Float.infinity
        imageLayer?.add(fadeAnimation, forKey:"fade")
        
        
        
    }
    
}
