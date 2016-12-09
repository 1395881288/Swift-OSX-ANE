//
// Created by User on 08/12/2016.
// Copyright (c) 2016 Tua Rua Ltd. All rights reserved.
//

import Foundation

class ANEHelper {
    private let aneHelperOC = ANEHelperOC()
    private func isFREResultOK(errorCode: FREResult, errorMessage: String) -> Bool {
        if FRE_OK == errorCode {
            return true
        }
        let messageToReport: String = "\(errorMessage) \(errorCode)"
        Swift.debugPrint(messageToReport)
        aneHelperOC.trace(messageToReport)
        return false
    }

    private func hasThrownException(thrownException: FREObject?) -> Bool {
        if thrownException == nil {
            return false
        }
        var objectType: FREObjectType? = nil
        if FRE_OK != FREGetObjectType(thrownException, &objectType!) {
            NSLog("Exception was thrown, but failed to obtain information about its type")
            aneHelperOC.trace("Exception was thrown, but failed to obtain information about it")
            return true
        }

        if FRE_TYPE_OBJECT == objectType {
            var exceptionTextAS: FREObject? = nil
            var newException: FREObject? = nil

            if FRE_OK != FRECallObjectMethod(thrownException, "toString", 0, nil, &exceptionTextAS, &newException) {
                NSLog("Exception was thrown, but failed to obtain information about it");
                aneHelperOC.trace("Exception was thrown, but failed to obtain information about it")
                return true;
            }
            return true

        }

        return false
    }

    func getFreObject(bool: Bool!) -> FREObject {
        var ret: FREObject? = nil
        let b: UInt32 = (bool == true) ? 1 : 0

        let status: FREResult = FRENewObjectFromBool(b, &ret)
        _ = isFREResultOK(errorCode: status, errorMessage: "Could not convert Bool to FREObject.")
        return ret!
    }

    func getFreObject(string: String!) -> FREObject {
        var ret: FREObject? = nil
        let status: FREResult = FRENewObjectFromUTF8(UInt32(string.characters.count), string, &ret)
        _ = isFREResultOK(errorCode: status, errorMessage: "Could not convert String to FREObject.")
        return ret!
    }

    func getFREObject(double: Double) -> FREObject {
        var ret: FREObject? = nil
        let status: FREResult = FRENewObjectFromDouble(Double(double), &ret)
        _ = isFREResultOK(errorCode: status, errorMessage: "Could not convert Double to FREObject.")
        return ret!
    }

    func getFreObject(int: Int) -> FREObject {
        var ret: FREObject? = nil
        let status: FREResult = FRENewObjectFromInt32(Int32(int), &ret);
        _ = isFREResultOK(errorCode: status, errorMessage: "Could not convert Int to FREObject.")
        return ret!
    }

    func createFREObject(className: String) -> FREObject {
        var ret: FREObject? = nil
        var thrownException: FREObject? = nil
        let status: FREResult = FRENewObject(className, 0, nil, &ret, &thrownException)
        _ = isFREResultOK(errorCode: status, errorMessage: "Could not create FREObject.")
        if (FRE_OK != status) {
            _ = hasThrownException(thrownException: thrownException!);
            return ret!;
        }
        return ret!
    }


    func setFREObjectProperty(freObject: FREObject, name: String, prop: FREObject) {
        var thrownException: FREObject? = nil
        let status: FREResult = FRESetObjectProperty(freObject, name, prop, &thrownException)
        _ = isFREResultOK(errorCode: status, errorMessage: "Could not set property on FREObject.")
        if (FRE_OK != status) {
            _ = hasThrownException(thrownException: thrownException!);
        }

    }

    func getIdObjectFromFREObject(freObject: FREObject) -> Any? {
        return aneHelperOC.getIdObject(fromFREObject: freObject)
    }

}
