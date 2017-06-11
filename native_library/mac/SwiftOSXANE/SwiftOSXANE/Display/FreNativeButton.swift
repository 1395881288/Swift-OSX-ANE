//
//  FreNativeButton.swift
//  SwiftOSXANE
//
//  Created by Eoin Landy on 04/06/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

import Cocoa

class FreNativeButton: NSButton {
    private var _id:String = ""
	private var upState: NSImage!
	private var overState: NSImage!
	private var downState: NSImage!
	private let AsCallbackEvent: String = "TRFRESHARP.as.CALLBACK";
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

	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
	}

	override func mouseEntered(with event: NSEvent) {
		self.addCursorRect(self.bounds, cursor: NSCursor.pointingHand())
		self.image = overState
		let sf = "{\"id\": \"\(_id)\", \"event\": \"mouseOver\"}"
		do {
			try context.dispatchStatusEventAsync(code: sf, level: AsCallbackEvent)
		} catch {
		}
	}

	override func mouseExited(with event: NSEvent) {
		self.image = upState
		let sf = "{\"id\": \"\(_id)\", \"event\": \"mouseOut\"}"
		do {
			try context.dispatchStatusEventAsync(code: sf, level: AsCallbackEvent)
		} catch {
		}
	}

	override func mouseDown(with event: NSEvent) {
		self.image = downState
		let sf = "{\"id\": \"\(_id)\", \"event\": \"mouseDown\"}"
		do {
			try context.dispatchStatusEventAsync(code: sf, level: AsCallbackEvent)
		} catch {
		}
	}

	override func mouseUp(with event: NSEvent) {
		self.image = overState
		let sf = "{\"id\": \"\(_id)\", \"event\": \"mouseUp\"}"
		let sf2 = "{\"id\": \"\(_id)\", \"event\": \"click\"}"
		do {
			try context.dispatchStatusEventAsync(code: sf, level: AsCallbackEvent)
			try context.dispatchStatusEventAsync(code: sf2, level: AsCallbackEvent)
		} catch {
		}
	}

	convenience init(freObjectSwift: FreObjectSwift, id: String) throws {
		guard let upStateBmd = try freObjectSwift.getProperty(name: "upStateData")?.rawValue,
			  let overStateBmd = try freObjectSwift.getProperty(name: "overStateData")?.rawValue,
			  let downStateBmd = try freObjectSwift.getProperty(name: "downStateData")?.rawValue,
			  let xFre = try freObjectSwift.getProperty(name: "x")?.value as? Int,
			  let yFre = try freObjectSwift.getProperty(name: "y")?.value as? Int,
			  let vFre = try freObjectSwift.getProperty(name: "visible")?.value as? Bool
		  else {
			self.init(frame: NSRect.init(x: 0, y: 0, width: 0, height: 0))
			return
		}
        
		let _x = CGFloat.init(xFre)
		let _y = CGFloat.init(yFre)
		var width = 0
		var height = 0
		var upStateImg: NSImage?
		var overStateImg: NSImage?
		var downStateImg: NSImage?

		var _alpha: CGFloat = 0.0
		if let aFre = try freObjectSwift.getProperty(name: "alpha") {
			_alpha = FREObjectTypeSwift.int == aFre.getType()
			  ? CGFloat.init(aFre.value as! Int)
			  : CGFloat.init(aFre.value as! Double)
		}

		let upStateBitmapData = FreBitmapDataSwift.init(freObject: upStateBmd)
		defer {
			upStateBitmapData.releaseData()
		}
		do {
			if let upStateCgimg = try upStateBitmapData.getAsImage() {
				width = upStateCgimg.width
				height = upStateCgimg.height
				upStateImg = NSImage.init(cgImage: upStateCgimg, size: NSSize.init(width: width, height: height))
			}
		} catch {
		}


		let overStateBitmapData = FreBitmapDataSwift.init(freObject: overStateBmd)
		defer {
			overStateBitmapData.releaseData()
		}
		do {
			if let overStateCgimg = try overStateBitmapData.getAsImage() {
				width = overStateCgimg.width
				height = overStateCgimg.height
				overStateImg = NSImage.init(cgImage: overStateCgimg, size: NSSize.init(width: width, height: height))
			}
		} catch {
		}

		let downStateBitmapData = FreBitmapDataSwift.init(freObject: downStateBmd)
		defer {
			downStateBitmapData.releaseData()
		}
		do {
			if let downStateCgimg = try downStateBitmapData.getAsImage() {
				width = downStateCgimg.width
				height = downStateCgimg.height
				downStateImg = NSImage.init(cgImage: downStateCgimg, size: NSSize.init(width: width, height: height))
			}
		} catch {
		}

		self.init(frame: NSRect.init(x: _x, y: _y, width: CGFloat.init(width), height: CGFloat.init(height)))

		upState = upStateImg
		overState = overStateImg
		downState = downStateImg
		isHidden = !vFre
		alphaValue = _alpha
		_id = id
		x = _x
		y = _y
		image = upState
		isBordered = false

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
			self.alphaValue = FREObjectTypeSwift.int == aFre.getType()
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

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		let trackingArea: NSTrackingArea = NSTrackingArea.init(rect: self.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
		self.addTrackingArea(trackingArea)
	}
    
    override var isFlipped: Bool {
        return true
    }

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

}
