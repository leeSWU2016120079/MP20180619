//
//  InfoViewController.swift
//  healthSchedule
//
//  Created by SWUCOMPUTER on 2018. 5. 29..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class InfoViewController: UIViewController , UITextFieldDelegate  {
    
    @IBOutlet var textHeight: UITextField!
    @IBOutlet var textWeight: UITextField!
    @IBOutlet var userLabel: UILabel!
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        if textField == self.textHeight { textField.resignFirstResponder()
            self.textWeight.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    @IBAction func savePressed(_ sender: UIButton) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "BodyInfo", in: context)
        
        let object = NSManagedObject(entity: entity!, insertInto: context)
        let bmi = (Double(textWeight.text!))!/(((Double(textHeight.text!))!/10)*((Double(textHeight.text!))!/10))
        let textBmi = String(format: "%.2f", bmi)
        object.setValue(textHeight.text, forKey: "height")
        object.setValue(textWeight.text, forKey: "weight")
        object.setValue(textBmi, forKey: "bmi")
        object.setValue(Date(), forKey: "saveDate")
        do {
            try context.save()
            showToast(message: "저장되었습니다.")
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)") }
        }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let userName = appDelegate.userName else { return }
        userLabel.text = userName + " Info"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
