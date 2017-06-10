//
//  FreDisplayList.swift
//  SwiftOSXANE
//
//  Created by Eoin Landy on 04/06/2017.
//  Copyright © 2017 Tua Rua Ltd. All rights reserved.
//

import Cocoa

public struct FreDisplayList {

	public static var children: Dictionary<String, (String, Any)> = Dictionary<String, (String, Any)>()

	private static func addToParent(parentId: String, child: FreNativeImage) {
		if (parentId == "root") {
			if let view = FreStageSwift.view {
				view.addSubview(child)
			}
		} else {
			if let parent = children[parentId] {
				if let view = parent.1 as? FreNativeSprite {
					view.addSubview(child)
					view.fitToChildren()
				}
			}
		}
	}

	private static func addToParent(parentId: String, child: FreNativeButton) {
		if (parentId == "root") {
			if let view = FreStageSwift.view {
				view.addSubview(child)
			}
		} else {
			if let parent = children[parentId] {
				if let view = parent.1 as? FreNativeSprite {
					view.addSubview(child)
					view.fitToChildren()
				}
			}
		}
	}

	private static func addToParent(parentId: String, child: FreNativeSprite) {
		if (parentId == "root") {
			if let view = FreStageSwift.view {
				view.addSubview(child)
			}
		} else {
			if let parent = children[parentId] {
				if let view = parent.1 as? FreNativeSprite {
					view.addSubview(child)
					view.fitToChildren()
				}
			}
		}
	}

	public static func addChild(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {

		guard argc > 0,
			  let inFRE0 = argv[0],
			  let inFRE1 = argv[1],
			  let parentId: String = FreObjectSwift(freObject: inFRE0).value as? String
		  else {
			Swift.debugPrint("addChild called failed guard")
			return nil
		}

		do {
			let child = FreObjectSwift(freObject: inFRE1)

			guard let id = try child.getProperty(name: "id")?.value as? String,
				  let t = try child.getProperty(name: "type")?.value as? Int,
				  let type: FreStageSwift.FreNativeType = FreStageSwift.FreNativeType(rawValue: t)
			  else {
				return nil
			}

			switch type {
			case FreStageSwift.FreNativeType.image:
				let nativeImage = try FreNativeImage.init(freObjectSwift: child)
				addToParent(parentId: parentId, child: nativeImage)
				children[id] = (parentId, nativeImage)
				break
			case FreStageSwift.FreNativeType.button:
				let nativeButton = try FreNativeButton.init(freObjectSwift: child, id: id)
				addToParent(parentId: parentId, child: nativeButton)
				children[id] = (parentId, nativeButton)
				break
			case FreStageSwift.FreNativeType.sprite:
				let nativeSprite = try FreNativeSprite.init(freObjectSwift: child, id: id)
				addToParent(parentId: parentId, child: nativeSprite)
				children[id] = (parentId, nativeSprite)
				break
			}


		} catch let e as FREError {
			Swift.debugPrint(e)
		} catch {
		}



		return nil
	}

	public static func updateChild(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
		//id, type, value
		guard argc == 3,
			  let inFRE0 = argv[0],
			  let inFRE1 = argv[1],
			  let inFRE2 = argv[2]
		  else {
			return nil
		}
		guard let id = FreObjectSwift.init(freObject: inFRE0).value as? String
		  else {
			return nil
		}

		if let t = children[id] {
			if t.1 is FreNativeImage {
				let child: FreNativeImage = t.1 as! FreNativeImage
				child.update(prop: inFRE1, value: inFRE2)
			}
			if t.1 is FreNativeButton {
				let child: FreNativeButton = t.1 as! FreNativeButton
				child.update(prop: inFRE1, value: inFRE2)
			}
			if t.1 is FreNativeSprite {
				let child: FreNativeSprite = t.1 as! FreNativeSprite
				child.update(prop: inFRE1, value: inFRE2)
			}


		}

		return nil
	}


}
