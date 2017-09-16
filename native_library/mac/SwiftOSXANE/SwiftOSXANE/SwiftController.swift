/*@copyright The code is licensed under the[MIT
 License](http://opensource.org/licenses/MIT):
 
 Copyright © 2017 -  Tua Rua Ltd.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files(the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions :
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.*/

import Cocoa
import CoreImage
import FreSwift

public class SwiftController: NSObject, FreSwiftMainController {
    public var TAG: String? = "SwiftController"

    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]

    // Must have this function. It exposes the methods to our entry ObjC.
    @objc public func getFunctions(prefix: String) -> Array<String> {

        functionsToSet["\(prefix)runStringTests"] = runStringTests
        functionsToSet["\(prefix)runNumberTests"] = runNumberTests
        functionsToSet["\(prefix)runIntTests"] = runIntTests
        functionsToSet["\(prefix)runArrayTests"] = runArrayTests
        functionsToSet["\(prefix)runObjectTests"] = runObjectTests
        functionsToSet["\(prefix)runBitmapTests"] = runBitmapTests
        functionsToSet["\(prefix)runByteArrayTests"] = runByteArrayTests
        functionsToSet["\(prefix)runErrorTests"] = runErrorTests
        functionsToSet["\(prefix)runErrorTests2"] = runErrorTests2
        functionsToSet["\(prefix)runDataTests"] = runDataTests
        functionsToSet["\(prefix)runRectTests"] = runRectTests
        functionsToSet["\(prefix)runDateTests"] = runDateTests

        var arr: Array<String> = []
        for key in functionsToSet.keys {
            arr.append(key)
        }

        return arr
    }


    func runStringTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start String test***********")
        guard argc > 0,
              let inFRE0 = argv[0],
              let airString = String(inFRE0) else {
            return nil
        }

        trace("String passed from AIR:", airString)
        let swiftString: String = "I am a string from Swift"
        return swiftString.toFREObject()
    }

    func runNumberTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Number test***********")
        guard argc > 0,
              let inFRE0 = argv[0],
              let airDouble = Double(inFRE0),
              let airCGFloat = CGFloat(inFRE0),
              let airFloat = Float(inFRE0)
          else {
            return nil
        }

        trace("Number passed from AIR as Double:", airDouble.debugDescription)
        trace("Number passed from AIR as CGFloat:", airCGFloat.description)
        trace("Number passed from AIR as Float:", airFloat.description)

        let swiftDouble: Double = 34343.31
        return swiftDouble.toFREObject()
    }

    func runIntTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Int Uint test***********")
        guard argc > 1,
              let inFRE0 = argv[0],
              let inFRE1 = argv[1],
              let airInt = Int(inFRE0),
              let airUInt = UInt(inFRE1) else {
            return nil
        }

        let optionalInt: Int? = Int(inFRE0)

        trace("Int passed from AIR:", airInt)
        trace("Int passed from AIR (optional):", optionalInt.debugDescription)
        trace("UInt passed from AIR:", airUInt)

        let swiftInt: Int = -666
        return swiftInt.toFREObject()
    }

    func runArrayTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Array test NEW ***********")

        guard argc > 0, let inFRE0 = argv[0] else {
            return nil
        }

        let airArray: FREArray = FREArray.init(inFRE0)
        do {
            let airArrayLen = airArray.length

            trace("Array passed from AIR:", airArray.value)
            trace("AIR Array length:", airArrayLen)

            if let itemZero = try Int(airArray.at(index: 0)) {
                trace("AIR Array elem at 0 type:", "value:", itemZero)
                try airArray.set(index: 0, value: 56)
                return airArray.rawValue
            }

        } catch let e as FreError {
            _ = e.getError(#file, #line, #column)
        } catch {
        }

        return nil

    }

    func runObjectTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Object test***********")

        guard argc > 0, let person = argv[0] else {
            return nil
        }

        do {
            let newPerson = try FREObject(className: "com.tuarua.Person")
            trace("We created a new person. type =", newPerson?.type ?? "unknown")

            if let oldAge = try Int(person.getProp(name: "age")) {
                trace("current person age is", oldAge)
                try person.setProp(name: "age", value: oldAge + 10)
                if let addition = try person.call(method: "add", args: 100, 31) {
                    if let result = Int(addition) {
                        trace("addition result:", result)
                    }
                }

                if let dictionary = Dictionary.init(person) {
                    trace("AIR Object converted to Dictionary using getAsDictionary:", dictionary.description)
                }

            }

            return person

        } catch let e as FreError {
            _ = e.getError(#file, #line, #column)
        } catch {
        }


        return nil

    }

    func runBitmapTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Bitmap test***********")

        guard argc > 0, let inFRE0 = argv[0] else {
            return nil
        }

        let asBitmapData = FreBitmapDataSwift.init(freObject: inFRE0)
        defer {
            asBitmapData.releaseData()
        }
        do {
            if let cgimg = try asBitmapData.getAsImage() {
                let context = CIContext()

                let filter = CIFilter(name: "CISepiaTone")!
                filter.setValue(0.8, forKey: kCIInputIntensityKey)
                let image = CIImage.init(cgImage: cgimg)
                filter.setValue(image, forKey: kCIInputImageKey)
                let result = filter.outputImage!

                if let newImage = context.createCGImage(result, from: result.extent, format: kCIFormatBGRA8, colorSpace: cgimg.colorSpace) {
                    try asBitmapData.setPixels(cgImage: newImage)
                }

            }
        } catch {
        }

        return nil

    }

    func runByteArrayTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start ByteArray test***********")
        guard argc > 0, let inFRE0 = argv[0] else {
            return nil
        }

        let asByteArray = FreByteArraySwift.init(freByteArray: inFRE0)
        guard let byteData = asByteArray.value else {
            asByteArray.releaseBytes()
            return nil
        }

        let base64Encoded = byteData.base64EncodedString(options: .init(rawValue: 0))
        trace("Encoded to Base64 new BA:", base64Encoded)
        asByteArray.releaseBytes() //don't forget to release!!

        let myString = "Here is a Swift string encoded to byte array"
        if let stringData: NSData = myString.data(using: .utf8) as NSData? {
            let newBA = FreByteArraySwift.init(data: stringData)
            newBA.releaseBytes() //don't forget to release!!
            return newBA.rawValue
        }

        return nil

    }

    func runDataTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start ActionScriptData test***********")
        if let objectAs = argv[0] {
            do {
                try context.setActionScriptData(object: objectAs)
                return try context.getActionScriptData()
            } catch {
            }
        }
        return nil
    }

    func runErrorTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Error Handling test***********")

        guard argc > 0,
              let person = argv[0] else {
            return nil
        }

        do {
            _ = try person.call(method: "add", args: 2) //not passing enough args
        } catch let e as FreError {
            trace(e.message) //just catch in Swift, do not bubble to actionscript
        } catch {
        }

        do {
            _ = try person.getProp(name: "doNotExist") //calling a property that doesn't exist
        } catch let e as FreError {
            if let aneError = e.getError(#file, #line, #column) {
                return aneError //return the error as an actionscript error
            }
        } catch {
        }

        return nil
    }

    func runErrorTests2(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
              let expectInt = argv[0] else {
            return nil
        }

        guard FreObjectTypeSwift.int == expectInt.type else {
            trace("Oops, we expected the FREObject to be passed as an int but it's not")
            return nil
        }

        return nil

    }

    func runDateTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Date test ***********")

        guard argc > 0,
              let inFRE0 = argv[0] else {
            return nil
        }
        if let date = Date(inFRE0) {
            trace("timeIntervalSince1970 :", date.timeIntervalSince1970)
            return date.toFREObject()
        }
        return nil
    }

    func runRectTests(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("***********Start Rectangle Point test***********")
        guard argc > 1,
              let inFRE0 = argv[0], //point, rectangle
              let inFRE1 = argv[1] else {
            return nil
        }

        if let frePoint = CGPoint(inFRE0) {
            trace(frePoint.debugDescription)
        }

        if let freRect = CGRect(inFRE1) {
            trace(freRect.debugDescription)
        }
        return CGPoint.init(x: 10.2, y: 99.9).toFREObject()
    }

    // Must have this function. It exposes the methods to our entry ObjC.
    @objc public func callSwiftFunction(name: String, ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let fm = functionsToSet[name] {
            return fm(ctx, argc, argv)
        }
        return nil
    }

    @objc public func setFREContext(ctx: FREContext) {
        self.context = FreContextSwift.init(freContext: ctx)
    }
    @objc func onLoad() {
    }


}
