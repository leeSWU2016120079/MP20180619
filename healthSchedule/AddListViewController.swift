//
//  AddListViewController.swift
//  healthSchedule
//
//  Created by SWUCOMPUTER on 2018. 6. 2..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class AddListViewController: UIViewController , UITextFieldDelegate {
    
    var day:String = ""

    @IBOutlet var time: UILabel!
    var seconds = 5
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    @IBOutlet var timeSlider: UISlider!
    @IBAction func slider(_ sender: UISlider)
    {
        seconds = Int(sender.value)
        time.text = String(seconds) + " Seconds"
    }
    
    @IBOutlet var todoName: UITextField!
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: day, in: context)
        let object = NSManagedObject(entity: entity!, insertInto: context)
        let todo = todoName.text
        object.setValue(todo, forKey: "todo")
        object.setValue(String(seconds), forKey: "time")
        do {
            try context.save()
            showToast(message: "저장되었습니다.")
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)") }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
