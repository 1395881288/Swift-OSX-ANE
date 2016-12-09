/**
 * Created by User on 04/12/2016.
 */
package com.tuarua {
import flash.events.EventDispatcher;
import flash.external.ExtensionContext;
import flash.events.StatusEvent;
public class SwiftOSXANE extends EventDispatcher {
    private var extensionContext:ExtensionContext;
    private var _inited:Boolean = false;
    public function SwiftOSXANE() {
        initiate();
    }

    private function initiate():void {
        trace("[SwiftOSXANE] Initalizing ANE...");
        try {
            extensionContext = ExtensionContext.createExtensionContext("com.tuarua.SwiftOSXANE", null);
            extensionContext.addEventListener(StatusEvent.STATUS, gotEvent);
        } catch (e:Error) {
            trace("[SwiftOSXANE] ANE Not loaded properly.  Future calls will fail.");
        }
    }

    private function gotEvent(event:StatusEvent):void {
        switch (event.level) {
            case "TRACE":
                trace(event.code);
                break;
        }
    }
    public function getHelloWorld(value:String):String {
        return extensionContext.call("getHelloWorld",value) as String;
    }
    public function getAge(person:Person):int {
        return int(extensionContext.call("getAge", person));
    }

    public function getPrice():Number {
        return Number(extensionContext.call("getPrice"));
    }

    public function getIsSwiftCool():Number {
        return Number(extensionContext.call("getIsSwiftCool"));
    }

    public function dispose():void {
        if (!extensionContext) {
            trace("[SwiftOSXANE] Error. ANE Already in a disposed or failed state...");
            return;
        }
        trace("[SwiftOSXANE] Unloading ANE...");
        extensionContext.removeEventListener(StatusEvent.STATUS, gotEvent);
        extensionContext.dispose();
        extensionContext = null;
    }
}
}
