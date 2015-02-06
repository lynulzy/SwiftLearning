//
//  TipCalculatorModel.swift
//  SimpleSwiftApp
//
//  Created by ZSXJ on 15/2/3.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

import Foundation
import UIKit
class TestDataSource:NSObject,UITableViewDataSource {
    let tipCalc = TipCalculatorModel(total: 33.25, taxPct: 0.06)
    var possibleTips = Dictionary<Int, (tipAmt:Double, total:Double)>()
    var sortedKeys:[Int] = []
    
    override init(){
        possibleTips = tipCalc.returnPossibleTips()
        sortedKeys = sorted(Array(possibleTips.keys))
        super.init()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedKeys.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        let tipPct = sortedKeys[indexPath.row]
        let tipAmt = possibleTips[tipPct]!.tipAmt
        let total = possibleTips[tipPct]!.total
        
        cell.textLabel?.text = "\(tipPct)%"
        cell.detailTextLabel?.text = String(format: "Tip:$%0.2f, Total:$%0.2f", tipPct,total)
        return cell
    }
}



class TipCalculatorModel {
    var total : Double
    var taxPct : Double
    var subtotal:Double{
        //访存器
        get{
            return total/(taxPct + 1)
        }
        //        set(newSubtotal)
        //        {
        //            self.subtotal = newSubtotal
        //        }
    }
    
    init(total:Double,taxPct:Double)
    {
        self.total = total;
        self.taxPct = taxPct;
    }
    func calcTipWithTipPct(tipPct:Double)->(tipAmt:Double,total:Double){
        let tipAmt = subtotal * tipPct
        let finalTotal = total + tipAmt
        return (tipAmt,finalTotal)
    }
    func printPossibleTips()
    {
        let possibleTip1 = [0.15,0.18,0.20]
        let possibleTip2:[Double] = [0.15,0.18,0.20]
        for possibleTip in possibleTip1
        {
            println("\(possibleTip)%  :  \(calcTipWithTipPct(possibleTip))")
        }
    }
    
    func returnPossibleTips() -> [Int:(tipAmt:Double,total:Double)]
    {
        let possibleTip1 = [0.15,0.18,0.20]
        let possibleTip2:[Double] = [0.15,0.18,0.20]
        //        var retVal = [Int:Double]()
        var retVal = Dictionary<Int,(tipAmt:Double,total:Double)>()
        
        for possibleTip in possibleTip1
        {
            let intPct = Int(possibleTip * 100)
            retVal[intPct] = calcTipWithTipPct(possibleTip)
        }
        return retVal
    }
    
}