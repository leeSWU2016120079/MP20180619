//
//  PlaceDetailViewController.swift
//  healthSchedule
//
//  Created by SWUCOMPUTER on 2018. 6. 11..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    
    @IBOutlet var Placename: UILabel!
    @IBOutlet var Placedetail: UILabel!
    @IBOutlet var PlaceImg: UIImageView!
    
    var selectedData: PlaceData?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Placename.text = selectedData?.name
       
        Placedetail.numberOfLines = 0 // multiple lines
        Placedetail.text = selectedData?.detail
        var imageName = selectedData?.image// 숫자.jpg 로 저장된 파일 이름
        if (imageName != "") {
            let urlString = "http://condi.swu.ac.kr/student/T01iphone/place/"
            imageName = urlString + imageName!
            let url = URL(string: imageName!)!
            if let imageData = try? Data(contentsOf: url) {
                PlaceImg.image = UIImage(data: imageData)
                // 웹에서 파일 이미지를 접근함
            } }
        
    }
    

    @IBAction func buttonDelete() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let userID = appDelegate.ID else { return }
        if(userID==selectedData?.user){
            let alert=UIAlertController(title:"정말 삭제 하시겠습니까?", message: "",preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .cancel, handler: { action in
                let urlString: String = "http://condi.swu.ac.kr/student/T01iphone/place/deletePlace.php"
                guard let requestURL = URL(string: urlString) else { return }
                var request = URLRequest(url: requestURL)
                request.httpMethod = "POST"
                let restString: String = "name=" + self.Placename.text!
                request.httpBody = restString.data(using: .utf8)
                let session = URLSession.shared
                let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else { return }
                    guard let receivedData = responseData else { return }
                    if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
                }
                task.resume()
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else {showToast(message: "등록한 유저만 삭제할 수 있습니다.")}
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
