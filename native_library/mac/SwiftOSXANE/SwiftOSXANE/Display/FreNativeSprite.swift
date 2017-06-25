//
//  FreNativeSprite.swift
//  SwiftOSXANE
//
//  Created by Eoin Landy on 04/06/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

import Cocoa

class FreNativeSprite: NSView {
    private var _id: String = ""
    private var _x: CGFloat = 0
    public var x: CGFloat {
        set {
            _x = newValue
        }
        get {
            return _x
        }
    }

    private var _y: CGFloat = 0
    public var y: CGFloat {
        set {
            _y = newValue
        }
        get {
            return _y
        }
    }

    init(freObjectSwift: FreObjectSwift, id: String) throws {
        guard
          let xFre = try freObjectSwift.getProperty(name: "x")?.value as? Int,
          let yFre = try freObjectSwift.getProperty(name: "y")?.value as? Int,
          let vFre = try freObjectSwift.getProperty(name: "visible")?.value as? Bool
          else {
            super.init(frame: NSRect.init(x: 0, y: 0, width: 0, height: 0))
            return
        }
        _id = id
        let _x = CGFloat.init(xFre)
        let _y = CGFloat.init(yFre)

        var _alpha: CGFloat = 0.0
        if let aFre = try freObjectSwift.getProperty(name: "alpha") {
            _alpha = FreObjectTypeSwift.int == aFre.getType()
              ? CGFloat.init(aFre.value as! Int)
              : CGFloat.init(aFre.value as! Double)
        }

        super.init(frame: NSRect.init(x: _x, y: _y, width: 100, height: 100))
        x = _x
        y = _y

        alphaValue = _alpha
        isHidden = !vFre

    }


    func fitToChildren() {
        var maxX = CGFloat.init(0)
        var maxY = CGFloat.init(0)
        for sv in self.subviews {
            if sv.frame.maxX > maxX {
                maxX = sv.frame.maxX
            }
            if sv.frame.maxY > maxY {
                maxY = sv.frame.maxY
            }
        }
        self.setFrameSize(NSSize.init(width: maxX, height: maxY))
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override var isFlipped: Bool {
        return true
    }

    func update(prop: FREObject, value: FREObject) {
        guard let propName = FreObjectSwift.init(freObject: prop).value as? String
          else {
            return
        }
        var forceLayout = false
        if propName == "x" {
            x = CGFloat.init(FreObjectSwift.init(freObject: value).value as! Int)
            forceLayout = true
        } else if propName == "y" {
            y = CGFloat.init(FreObjectSwift.init(freObject: value).value as! Int)
            forceLayout = true
        } else if propName == "alpha" {
            self.alphaValue = CGFloat.init(FreObjectSwift.init(freObject: value).value as! Double)
        } else if propName == "visible" {
            self.isHidden = FreObjectSwift.init(freObject: value).value as! Bool
        }

        if forceLayout {
            self.setFrameOrigin(NSPoint.init(x: x, y: y))
            FreDisplayList.sizeParentToFit(id: _id)
        }
        self.needsDisplay = true

    }
}
