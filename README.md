# Swift OSX ANE  

Example Xcode project showing how to programme Air Native Extensions for OSX 10.10+ using Swift.


[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=5UR2T52J633RC)

It is comprised of 2 parts.

1. A dynamic Swift Framework which contains the translation of FlashRuntimeExtensions to Swift.
2. A dynamic Swift Framework which contains the main logic of the ANE.


SwiftOSXANE/SwiftOSXANE.m is the entry point of the ANE. It acts as a thin layered API to your Swift controller.  
Add the methods to expose to AIR here 

````objectivec
static FRENamedFunction extensionFunctions[] =
{
    MAP_FUNCTION(TRSOA, load)
   ,MAP_FUNCTION(TRSOA, goBack)
};
`````


SwiftIOSANE_FW/SwiftController.swift  
Add Swift method(s) to the functionsToSet Dictionary in getFunctions()

````swift
@objc public func getFunctions(prefix: String) -> Array<String> {
    functionsToSet["\(prefix)load"] = load
    functionsToSet["\(prefix)goBack"] = goBack    
}
`````

Add Swift method(s)

````swift
func load(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
    //your code here
    return nil
}

func goBack(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
    //your code here
    return nil
}
`````

----------

######  The methods exposed by FlashRuntimeExtensions.swift are identical in most parts to the [iOS version](https://github.com/tuarua/Swift-IOS-ANE). 

----------

### How to use
###### Converting from FREObject args into Swift types, returning FREObjects


The following table shows the primitive as3 types which can easily be converted to/from Swift types


| AS3 type | Swift type | AS3 param->Swift | return Swift->AS3 |
|:--------:|:--------:|:--------------|:-----------|
| String | String | let str = String(argv[0]) | return str.toFREObject()|
| int | Int | let i = Int(argv[0]) | return i.toFREObject()|
| Boolean | Bool | let b = Bool(argv[0]) | return b.toFREObject()|
| Number | Double | let dbl = Double(argv[0]) | return dbl.toFREObject()|
| Number | CGFloat | let cfl = CGFloat(argv[0]) | return cfl.toFREObject()|
| Date | Date | let date = Date(argv[0]) | return date.toFREObject()|
| Rectangle | CGRect | let rect = CGRect(argv[0]) | return rect.toFREObject()|
| Point | CGPoint | let pnt = CGPoint(argv[0]) | return pnt.toFREObject()|


Example
````swift
let airString = String(argv[0])
trace("String passed from AIR:", airString)
let swiftString: String = "I am a string from Swift"
return swiftString.toFREObject()
`````

FreSwift is fully extensible. New conversion types can be added in your own project. For example, Rectangle and Point are built as Extensions.

----------


Example - Call a method on an FREObject

````swift
let person = argv[0]
if let addition = try person.call(method: "add", args: 100, 31) {
    if let result = Int(addition) {
        trace("addition result:", result)
    }
}
`````

Example - Reading items in array
````swift
let airArray: FREArray = FREArray.init(argv[0])
do {
    if let itemZero = try Int(airArray.at(index: 0)) {
        trace("AIR Array elem at 0 type:", "value:", itemZero)
        try airArray.set(index: 0, value: 56)
        return airArray.rawValue
    }
} catch {}
`````

Example - Convert BitmapData to a CGImage
````swift
let asBitmapData = FreBitmapDataSwift.init(freObject: inFRE0)
defer {
    asBitmapData.releaseData()
}
do {
    if let cgimg = try asBitmapData.getAsImage() {
     //do something with cgimg like applying a filter
    }
} catch {}
`````

Example - Error handling
````swift
do {
    _ = try person.getProp(name: "doNotExist") //calling a property that doesn't exist
} catch let e as FREError {
    if let aneError = e.getError(#file, #line, #column) {
        return aneError //return the error as an actionscript error
    }
} catch {}
`````
----------

### Prerequisites

You will need

- Xcode 8.3 / AppCode
- IntelliJ IDEA
- AIR 25

