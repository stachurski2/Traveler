//
//  DateSelectController.swift
//  Traveler
//
//  Created by Stanisaw Sobczyk on 12/11/2017.
//  Copyright © 2017 Stanisaw Sobczyk. All rights reserved.
//

import UIKit

class DateSelectController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var task:Task?

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func accept(_ sender: Any) {
        guard let task = task else {return}
        task.changeDateTime(date: datePicker.date)
        _ = self.navigationController?.popViewController(animated: true)
        
    }

    
    @IBAction func reject(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)

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
