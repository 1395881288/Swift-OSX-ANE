//
//  SwiftOSXANE.swift
//  SwiftOSXANE
//
//  Created by User on 04/12/2016.
//  Copyright © 2016 Tua Rua Ltd. All rights reserved.
//

import Cocoa
import Foundation

@objc class SwiftOSXANE: NSObject {

    private var dllContext: FREContext!
    private let aneHelper = ANEHelper()

    private func trace(value:String) {
        FREDispatchStatusEventAsync(self.dllContext, value, "TRACE")
    }

    func getIsSwiftCool() -> FREObject {
        return aneHelper.getFreObject(bool: true)
    }

    func getPrice() -> FREObject {
        return aneHelper.getFREObject(double: 59.99)
    }

    func getAgeWith(argv:NSArray) -> FREObject {
        var age = 31
        if(argv.count > 0){
            let person = argv.object(at: 0) as! Dictionary<String, AnyObject>
            let value:Int = person["age"] as! Int
            age = value + 1
        }else{
            Swift.debugPrint("getAge no person object passed")
        }
        
        return aneHelper.getFreObject(int:age)
    }
    
    func getHelloWorld(argv:NSArray) -> FREObject {
        let txt = argv.object(at: 0)
        //test creating an object and setting props
        let fre:FREObject = aneHelper.createFREObject(className:"com.tuarua.Person")
        aneHelper.setFREObjectProperty(freObject: fre, name: "name", prop: aneHelper.getFreObject(string: "Kitty"))
        aneHelper.setFREObjectProperty(freObject: fre, name: "age", prop: aneHelper.getFreObject(int: 21))
        
        let person = aneHelper.getIdObjectFromFREObject(freObject: fre) as! Dictionary<String, AnyObject>
        let personName:String = person["name"] as! String
        return aneHelper.getFreObject(string: "\(txt) talking to \(personName)")
    }
    

    func setFREContext(ctx: FREContext) {
        dllContext = ctx
        let aneHelperOC = ANEHelperOC()
        aneHelperOC.ctx = ctx;
    }


}







