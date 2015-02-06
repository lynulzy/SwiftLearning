//
//  ViewController.swift
//  SimpleSwiftApp
//
//  Created by ZSXJ on 15/2/3.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

import UIKit

class ViewController: UIKit.UIViewController,UITableViewDataSource{
    @IBOutlet var totalTextField:UITextField!
    @IBOutlet var taxPctSlider:UISlider!
    @IBOutlet var taxPctLabel:UILabel!
    @IBOutlet var resultsTextView:UITextView!
    @IBOutlet var tableView: UITableView!
    let tipCal = TipCalculatorModel(total: 33.25, taxPct: 0.06)
    
    var possibleTips = Dictionary<Int,(tipAmt:Double,total:Double)>()
    var sortedKeys:[Int] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshUI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calculateTapped(sender:AnyObject)
    {
        tipCal.total = Double((totalTextField.text as NSString).doubleValue)
//        let possibleTips = tipCal.returnPossibleTips()
//        var results = ""
//        for (tipPct,tipValue) in possibleTips
//        {
//            results = "\(tipPct)%:\(tipValue)\n"
//        }
//        resultsTextView.text = results
        possibleTips = tipCal.returnPossibleTips()
        sortedKeys = sorted(Array(possibleTips.keys))
        tableView.reloadData()
        
    }
    
    @IBAction func taxPctChanged(sender:AnyObject)
    {
        tipCal.taxPct = Double(taxPctSlider.value)/100.0
        refreshUI()
    }
    @IBAction func viewTapped(sender:AnyObject)
    {
        totalTextField.resignFirstResponder();
    }
    func refreshUI()
    {
        totalTextField.text = String(format: "0.2f",tipCal.total)
        taxPctSlider.value = Float(tipCal.taxPct * 100.0)
        taxPctLabel.text = "Tax Percentage (\(Int(taxPctSlider.value))%)"
//        resultsTextView.text = ""
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedKeys.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        let tipPct = sortedKeys[indexPath.row]
        let total = possibleTips[tipPct]!.total
        let tipAmt = possibleTips[tipPct]!.tipAmt
        cell.textLabel?.text = "\(tipPct)%"
        cell.detailTextLabel?.text = String(format:"Tip:$%.2f ,Total:$%.2f",tipPct,total)
        return cell
    }
}

//

