//
//  StartPageViewController.swift
//  FinalProject_V2
//
//  Created by Weijie Zheng
//  Description: for data in the start page
//

import UIKit

class StartPageViewController: UIViewController {
    @IBOutlet var startBtn : UIButton!
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if mainDelegate.errorMsg != nil {
            let alertController = UIAlertController(title: "Error", message: mainDelegate.errorMsg!, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
            startBtn.isUserInteractionEnabled=false
            startBtn.alpha=0.4
            
        }
        mainDelegate.readDataFromPetInfo()
    }
    
    @IBAction func unwindToStartPage(sender:UIStoryboardSegue)
    {
        
    }
    @IBAction func startButtonClicked(sender: UIButton)
    {
        if(mainDelegate.petInfo == []){

            self.performSegue(withIdentifier: "GoToNamePage", sender: nil)
        }else{
            
            self.performSegue(withIdentifier: "GoToMainPage", sender: nil)
        }
    }

}
