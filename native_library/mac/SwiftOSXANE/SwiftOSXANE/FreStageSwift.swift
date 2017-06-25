//
//  ButtonView.swift
//  SwiftOSXANE
//
//  Created by Eoin Landy on 01/06/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

import Cocoa

public struct FreStageSwift {
    private static var _view: NSView?
    public static var view: NSView? {
        set {
            _view = newValue
        }
        get {
            return _view
        }
    }

    public enum FreNativeType: Int {
        case image
        case button
        case sprite
    }

    private static var _viewPort: NSRect!
    private static var _visible: Bool = false
    private static var _transparent: Bool = false
    private static var _backgroundColor: CGColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
    public static func initView(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc == 4,
              let inFRE0 = argv[0],
              let inFRE1 = argv[1],
              let inFRE2 = argv[2],
              let inFRE3 = argv[3],
              let viewPort = FreRectangleSwift.init(freObject: inFRE0).value as? CGRect,
              let visible: Bool = FreObjectSwift(freObject: inFRE1).value as? Bool,
              let transparent: Bool = FreObjectSwift(freObject: inFRE2).value as? Bool
          else {
            return nil
        }

        do {
            _backgroundColor = try FreSwiftHelper.toCGColor(freObject: inFRE3, alpha: FreObjectSwift.init(int: 1).rawValue!)
        } catch {
        }
        _viewPort = viewPort
        _visible = visible
        _transparent = transparent
        return nil

    }

    public static func onFullScreen(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0, let inFRE0 = argv[0] else {
            traceError(message: "onFullScreen - incorrect arguments", line: #line, column: #column, file: #file, freError: nil)
            return nil
        }

        let fullScreen: Bool = FreObjectSwift.init(freObject: inFRE0).value as! Bool
        for win in NSApp.windows {
            if (fullScreen && win.canBecomeMain && win.className.contains("AIR_FullScreen")) {
                win.makeMain()
                break
            } else if (!fullScreen && win.canBecomeMain && win.className.contains("AIR_PlayerContent")) {
                win.makeMain()
                win.orderFront(nil)
                break
            }
        }
        _ = restore(ctx: ctx, argc: argc, argv: argv)

        return nil
    }

    public static func restore(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let windowView = NSApp.mainWindow?.contentView, let v = _view {
            v.removeFromSuperview()
            v.setFrameOrigin(NSPoint.init(x: 0.0, y: windowView.frame.height - v.frame.height))
            windowView.addSubview(v)
            refreshView()
        }
        return nil
    }

    public static func addRoot(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        _view = FreStageSwiftView.init(frame: _viewPort, visible: _visible, transparent: _transparent, backgroundColor: _backgroundColor)

        if let windowView = NSApp.mainWindow?.contentView, let v = _view {
            windowView.addSubview(v)
            v.setFrameOrigin(NSPoint.init(x: 0.0, y: windowView.frame.height - v.frame.height))
            refreshView()
        }
        return nil
    }

    public static func refreshView() {
        if let windowView = NSApp.mainWindow?.contentView {
            windowView.needsDisplay = true
            windowView.needsLayout = true
            windowView.layoutSubtreeIfNeeded() //this is the magic line
        }
    }

    public static func update(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc == 2,
              let inFRE0 = argv[0],
              let inFRE1 = argv[1],
              let propName = FreObjectSwift.init(freObject: inFRE0).value as? String
          else {
            return nil
        }
        if propName == "viewPort" {
            if let windowView = NSApp.mainWindow?.contentView, let v = _view, let val = FreRectangleSwift(freObject: inFRE1).value as? CGRect {
                v.frame = val
                v.setFrameOrigin(NSPoint.init(x: 0.0, y: windowView.frame.height - v.frame.height))
                refreshView()
            }
        } else if propName == "visible" {
            if let view = _view, let val = FreObjectSwift(freObject: inFRE1).value as? Bool {
                view.isHidden = !val
            }
        }

        return nil
    }

}


fileprivate class FreStageSwiftView: NSView, CALayerDelegate {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    convenience init(frame frameRect: NSRect, visible: Bool, transparent: Bool, backgroundColor: CGColor) {
        self.init(frame: frameRect)
        self.isHidden = !visible
        self.layer?.backgroundColor = backgroundColor
        if transparent {
            self.layer?.backgroundColor = CGColor.clear
        }
        //self.layerContentsRedrawPolicy = .onSetNeedsDisplay
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        let viewLayer = CALayer()
        self.wantsLayer = true
        self.layer = viewLayer
        self.layer?.removeAllAnimations()
        self.layer?.delegate = self
    }

    override func animation(forKey key: String) -> Any? {
        return nil //removes fade animation
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override var isFlipped: Bool {
        return true
    }


}
