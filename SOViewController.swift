//
//  SOViewController.swift
//  Exersice App
//
//  Created by Martis on 04/05/21.
//

import UIKit
import HealthKit

//class SOViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//}

class SOViewController: UIViewController ,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var showButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showPopoverButtonAction(_ sender: Any) {
        //get the button frame
        /* 1 */
        let button = sender as? UIButton
        let buttonFrame = button?.frame ?? CGRect.zero

        /* 2 */
        //Configure the presentation controller
        let popoverContentController = self.storyboard?.instantiateViewController(withIdentifier: "GSViewController") as? GSViewController
        popoverContentController?.modalPresentationStyle = .popover

        /* 3 */
        if let popoverPresentationController = popoverContentController?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = buttonFrame
            popoverPresentationController.delegate = self
            if let popoverController = popoverContentController {
                present(popoverController, animated: true, completion: nil)
            }
        }
    }

    //UIPopoverPresentationControllerDelegate inherits from UIAdaptivePresentationControllerDelegate, we will use this method to define the presentation style for popover presentation controller
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {

    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}


