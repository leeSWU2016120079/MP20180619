

import UIKit

class BgViewController: UIViewController {
    
    
    @IBOutlet var bgImage: UIImageView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var welcomeLbl: UILabel!
    @IBOutlet var startBtn: UIButton!
    @IBOutlet var mainViewConstraint: NSLayoutConstraint!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         mainViewConstraint.constant = -195
        for i in [bgImage, mainView, welcomeLbl,startBtn]{
            i?.alpha = 0
        }
        UIView.animate(withDuration: 1, animations: {
            self.bgImage.alpha = 1
        }) { (true) in
            self.animateView()
        }
    }
    
    func animateView() {
        UIView.animate(withDuration: 2, animations: {
            self.mainView.alpha = 1
            self.mainViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { (true) in
            self.animateLbl()
        }
    }
    
    func animateLbl(){
        UIView.animate(withDuration: 1, animations: {
            self.welcomeLbl.alpha = 1
        }) { (true) in
            self.animateBtn()
        }
    }
    
    func animateBtn() {
        UIView.animate(withDuration: 1){
            self.startBtn.alpha = 1
        }
    }
}

