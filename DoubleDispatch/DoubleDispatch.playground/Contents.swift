/// Double dispatch underpins the visitor pattern, and it relies on Swift to select a method based on the parameter type.
/// Consider the following protocol and classes:
protocol MyProtocol {
    func dispatch(handler: Handler)
}

class FirstClass: MyProtocol {
    func dispatch(handler: Handler) {
        handler.handle(argument: self)
    }
}

class SecondClass: MyProtocol {
    func dispatch(handler: Handler) {
        handler.handle(argument: self)
    }
}

/// The FirstClass and SecondClass both conform to MyProtocol. The dispatch method defined by the protocol
/// and implemented by the classes is the key to the double dispatch technique, although the best way to understand
/// double dispatch is to see what happens without it. Here is the definition of the Handler class that is accepted by the dispatch method:
class Handler {
    func handle(argument: MyProtocol) {
        debugPrint("Protocol")
    }

    func handle(argument: FirstClass) {
        debugPrint("First Class")
    }

    func handle(argument: SecondClass) {
        debugPrint("Second Class")
    }
}

///Consider what happens when I create an array of FirstClass and SecondClass objects and pass them to a Handler object, like this:
let objects: [MyProtocol] = [FirstClass(), SecondClass()]
let handler = Handler()

objects.forEach { handler.handle(argument: $0) }

/// This is regular single dispatch, in which I simply call the method of the Handler object for each of the objects in the
/// array. To be able to store a FirstClass object and a SecondClass object in the same array, I have to specify its type
/// as MyProtocol, and this affects the version of the handle method selected by Swift in the for loop, producing the following results:

/*
"Protocol"
"Protocol"
*/

/// Both objects are dealt with using the type of the array. To enable double dispatch, I have to change the method call in the for loop, like this:
objects.forEach { $0.dispatch(handler: handler) }

/// The dispatch method implementations result in the Handler.handle method being called from within the classes,
/// but with the self argument. The effect is to call the version of the handle method with the most specific type, producing the following results:

/*
 "First Class"
 "Second Class"
 */

/// Calling the handle method from within an objects method has the effect of calling the method version with the most
/// specific argument type without needing to perform any casts, which is the central technique in the visitor pattern.
