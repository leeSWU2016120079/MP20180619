//
//  PlaceViewController.swift
//  healthSchedule
//
//  Created by SWUCOMPUTER on 2018. 5. 30..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PlaceViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var fetchedArray: [PlaceData] = Array()
    
    var annotationArr = Array<MKPointAnnotation>()
    
    let locationManager: CLLocationManager = CLLocationManager()
    @IBOutlet var map: MKMapView!
    var lat = "", long = ""

    @IBAction func refreshLoc(_ sender: Any) {
        
    self.locationManager.startUpdatingLocation()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return pin
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annot = view.annotation
        let storyboard = UIStoryboard(name : "Main", bundle : nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "Detailview") as! PlaceDetailViewController
        for i in 0...fetchedArray.count-1{
            if (fetchedArray[i].name == (annot?.title)!){
                detailVC.selectedData = fetchedArray[i]
                self.navigationController?.show(detailVC, sender: Any?.self)
                return
            }
            }
        }
        
        
        //detailVC.detail

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 가장 최근의 위치 값
        let location: CLLocation = locations[locations.count-1]
        lat = String(format: "%.6f", location.coordinate.latitude)
        long = String(format: "%.6f", location.coordinate.longitude)
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        map.setRegion(MKCoordinateRegionMake(myLocation,MKCoordinateSpanMake(0.007, 0.007)), animated: true)
        
        self.map.showsUserLocation = true
        
    }
    
    func downloadDataFromServer() -> Void {
        let urlString: String = "http://condi.swu.ac.kr/student/T01iphone/place/PlaceAnno.php"
        guard let requestURL = URL(string: urlString) else { return }
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil
                else { print("Error: calling POST"); return; }
            guard let receivedData = responseData else {
                print("Error: not receiving Data"); return; }
            let response = response as! HTTPURLResponse
            if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData,
                                                                    options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        let newData: PlaceData = PlaceData()
                        var jsonElement = jsonData[i]
                        newData.name = jsonElement["name"] as! String
                        newData.lat = jsonElement["lat"] as! String
                        newData.lon = jsonElement["lon"] as! String
                        newData.detail = jsonElement["detail"] as! String
                        newData.image = jsonElement["image"] as! String
                        newData.user = jsonElement["user"] as! String
                        self.fetchedArray.append(newData)
                    }
                    for i in 0...jsonData.count-1 {
                        let annotation1 = MKPointAnnotation()
                        annotation1.title = self.fetchedArray[i].name
                        annotation1.subtitle = self.fetchedArray[i].user+" recommend"
                        let lat = Double(self.fetchedArray[i].lat)
                        let lon = Double(self.fetchedArray[i].lon)
                        let coord = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                        annotation1.coordinate = coord
                        self.annotationArr.append(annotation1)
                    }
                    DispatchQueue.main.async {
                        self.map.addAnnotations(self.annotationArr)
                    }
                }
            } catch { print("Error:") } }
        task.resume()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        map.delegate = self
        self.map.removeAnnotations(annotationArr)
        fetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        annotationArr = []
        self.downloadDataFromServer()
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
                let alert = UIAlertController(title: "오류 발생",
                                              message: "위치서비스 기능이 꺼져있음", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                }
            else {
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
            } }
        else {
            let alert = UIAlertController(title: "오류 발생", message: "위치서비스 제공 불가",
                                          preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil) }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddPlace" {
            if let destination = segue.destination as? AddPlaceViewController {
                destination.lat = lat
                destination.long = long
            } }
        
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
