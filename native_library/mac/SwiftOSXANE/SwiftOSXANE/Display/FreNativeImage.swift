//
//  FreNativeImage.swift
//  SwiftOSXANE
//
//  Created by Eoin Landy on 04/06/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

import Cocoa

class FreNativeImage: NSImageView {
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

    override func animation(forKey key: String) -> Any? {
        return nil
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
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
            let aFre = FreObjectSwift.init(freObject: value)
            self.alphaValue = FreObjectTypeSwift.int == aFre.getType()
              ? CGFloat.init(aFre.value as! Int)
              : CGFloat.init(aFre.value as! Double)
        } else if propName == "visible" {
            self.isHidden = !(FreObjectSwift.init(freObject: value).value as! Bool)
        }

        if forceLayout {
            self.setFrameOrigin(NSPoint.init(x: x, y: y))
            FreDisplayList.sizeParentToFit(id: _id)
        }
        self.needsDisplay = true

    }


    init(freObjectSwift: FreObjectSwift, id: String) throws {
        guard let bmd = try freObjectSwift.getProperty(name: "bitmapData")?.rawValue,
              let xFre = try freObjectSwift.getProperty(name: "x")?.value as? Int,
              let yFre = try freObjectSwift.getProperty(name: "y")?.value as? Int,
              let vFre = try freObjectSwift.getProperty(name: "visible")?.value as? Bool
          else {
            self._id = id
            super.init(frame: NSRect.init(x: 0, y: 0, width: 0, height: 0))
            return
        }

        self._id = id
        let _x = CGFloat.init(xFre)
        let _y = CGFloat.init(yFre)
        var width = 0
        var height = 0

        var img: NSImage?

        var _alpha: CGFloat = 0.0
        if let aFre = try freObjectSwift.getProperty(name: "alpha") {
            _alpha = FreObjectTypeSwift.int == aFre.getType()
              ? CGFloat.init(aFre.value as! Int)
              : CGFloat.init(aFre.value as! Double)
        }

        let asBitmapData = FreBitmapDataSwift.init(freObject: bmd)
        defer {
            asBitmapData.releaseData()
        }
        do {
            if let cgimg = try asBitmapData.getAsImage() {
                width = cgimg.width
                height = cgimg.height
                img = NSImage.init(cgImage: cgimg, size: NSSize.init(width: width, height: height))
            }
        } catch {
        }

        super.init(frame: NSRect.init(x: _x, y: _y, width: CGFloat.init(width), height: CGFloat.init(height)))
        self.postsFrameChangedNotifications = true

        x = _x
        y = _y
        alphaValue = _alpha
        isHidden = !vFre

        if let img = img {
            self.image = img
        }

    }

    override var isFlipped: Bool {
        return true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
