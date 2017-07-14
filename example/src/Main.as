package {

import com.greensock.TweenLite;
import com.tuarua.CommonDependencies;
import com.tuarua.Person;
import com.tuarua.SwiftOSXANE;
import com.tuarua.fre.ANStage;
import com.tuarua.fre.display.ANSprite;
import com.tuarua.fre.display.ANButton;
import com.tuarua.fre.display.ANImage;

import com.tuarua.fre.ANEError;

import flash.desktop.NativeApplication;
import flash.display.Bitmap;
import flash.display.Loader;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.utils.ByteArray;

[SWF(width="640", height="640", frameRate="60", backgroundColor="#F1F1F1")]
public class Main extends Sprite {
    private var commonDependenciesANE:CommonDependencies = new CommonDependencies();
    private var ane:SwiftOSXANE;
    private var hasActivated:Boolean;

    [Embed(source="adobeair.png")]
    public static const TestImage:Class;

    [Embed(source="play.png")]
    public static const TestButton:Class;

    [Embed(source="play-hover.png")]
    public static const TestButtonHover:Class;

    private var nativeButton:ANButton;
    private var nativeImage:ANImage;
    private var nativeSprite:ANSprite;

    public function Main() {
        super();
        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        this.addEventListener(Event.ACTIVATE, onActivated);
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
    }

    private function onActivated(event:Event):void {
        if (!hasActivated) {
            // notes - the ane with shared context must come first
            // don't need the swift libs in secondary anes

            ane = new SwiftOSXANE();
            var textField:TextField = new TextField();
            var tf:TextFormat = new TextFormat();
            tf.size = 24;
            tf.color = 0x333333;
            tf.align = TextFormatAlign.LEFT;
            textField.defaultTextFormat = tf;
            textField.width = 800;
            textField.height = 800;
            textField.multiline = true;
            textField.wordWrap = true;
            textField.width = 500;
            textField.height = 300;

            var person:Person = new Person();
            person.age = 21;
            person.name = "Tom";

            var myArray:Array = [];
            myArray.push(3, 1, 4, 2, 6, 5);


            var resultString:String = ane.runStringTests("I am a string from AIR with new interface");
            textField.text += resultString + "\n";

            var resultNumber:Number = ane.runNumberTests(31.99);
            textField.text += "Number: " + resultNumber + "\n";

            var resultInt:int = ane.runIntTests(-54, 66);
            textField.text += "Int: " + resultInt + "\n";

            var resultArray:Array = ane.runArrayTests(myArray);
            textField.text += "Array: " + resultArray.toString() + "\n";


            var resultObject:Person = ane.runObjectTests(person) as Person;
            textField.text += "Person.age: " + resultObject.age.toString() + "\n";

            const IMAGE_URL:String = "https://scontent.cdninstagram.com/t/s320x320/17126819_1827746530776184_5999931637335326720_n.jpg";

            var ldr:Loader = new Loader();
            ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, ldr_complete);
            ldr.load(new URLRequest(IMAGE_URL));

            function ldr_complete(evt:Event):void {
                var bmp:Bitmap = ldr.content as Bitmap;
                bmp.y = 150;
                addChild(bmp);
                ane.runBitmapTests(bmp.bitmapData); //pass in bitmap data and apply filter
            }


            var myByteArray:ByteArray = new ByteArray();

            myByteArray.writeUTFBytes("Swift in an ANE. Say whaaaat!");
            var resultBA:ByteArray = ane.runByteArrayTests(myByteArray);
            trace("resultBA.toString()", resultBA.toString());

            try {
                ane.runErrorTests(person);
            } catch (e:ANEError) {
                trace("Error captured in AS");
                trace("e.message:", e.message);
                trace("e.errorID:", e.errorID);
                trace("e.type:", e.type);
                trace("e.source:", e.source);
                trace("e.getStackTrace():", e.getStackTrace());
            }

            ane.runErrorTests2("Test String");


            var inData:String = "Saved and returned";
            var outData:String = ane.runDataTests(inData) as String;
            textField.text += outData + "\n";


            addChild(textField);


            ANStage.init(stage, new Rectangle(0, 0, 400, 400), true, true, 0x505050);
            ANStage.add();

            nativeSprite = new ANSprite();
            nativeSprite.x = 10;

            nativeImage = new ANImage(new TestImage());
            nativeImage.x = 10;
            nativeImage.y = 99;
            nativeImage.visible = true;

            nativeButton = new ANButton(new TestButton(), new TestButtonHover());
            ANStage.addChild(nativeButton);


            ANStage.addChild(nativeSprite);
            nativeSprite.addChild(nativeImage);

            //NativeStage.viewPort = new Rectangle(0,0,400,600);

            nativeButton.addEventListener(MouseEvent.MOUSE_OVER, onNativeOver);
            nativeButton.addEventListener(MouseEvent.CLICK, onNativeClick);

        }
        hasActivated = true;


    }


    private function onNativeOver(event:MouseEvent):void {
        //nativeButton.alpha = 0.5;
    }

    private function onNativeClick(event:MouseEvent):void {
        //goFullscreen();

        //nativeImage.x = 100;
        TweenLite.to(nativeImage, 0.35, {x: 100});
        // NativeStage.viewPort = new Rectangle(0, 0, 500, 600);

    }

    private function goFullscreen() {
        stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
    }

    private function onExiting(event:Event):void {
        ane.dispose();
        commonDependenciesANE.dispose();
    }

}
}