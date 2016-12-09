package {

import com.tuarua.ANEObject;
import com.tuarua.Person;
import com.tuarua.SwiftOSXANE;

import flash.display.Sprite;
import flash.text.TextField;

public class Main extends Sprite {
    private var ane:SwiftOSXANE;
    public function Main() {
        ane = new SwiftOSXANE();
        var textField:TextField = new TextField();

        var person:Person = new Person();
        person.age = 31;
        person.name = "Tom";
        textField.width = 800;
        textField.text = ane.getHelloWorld("Swift and ANE");
        textField.text = textField.text + "\n" + ane.getAge(person);
        textField.text = textField.text + "\n" + ane.getPrice();
        addChild(textField);
    }
}
}
