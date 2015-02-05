//
//  TipCalculatorModel.swift
//  SimpleSwiftApp
//
//  Created by ZSXJ on 15/2/3.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

import Foundation
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
    func calcTipWithTipPct(tipPct:Double)->Double{
        return subtotal*tipPct;
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
    
    func returnPossibleTips() -> [Int:Double]
    {
        let possibleTip1 = [0.15,0.18,0.20]
        let possibleTip2:[Double] = [0.15,0.18,0.20]
        var retVal = [Int:Double]()
        for possibleTip in possibleTip1
        {
            let intPct = Int(possibleTip * 100)
            retVal[intPct] = calcTipWithTipPct(possibleTip)
        }
        return retVal
    }
    
}