import Inception "canister:inception"

actor {
    public type Name = Text;
    public type Phone = Text;

    stable var num : Phone = "";

    public func find(name: Name) : async ?Phone {
        await Inception.lookup(name);
    };
};