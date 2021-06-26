import momento "canister:momento"

actor {
    public type Name = Text;
    public type Phone = Text;

    stable var num : Phone = "";

    public func find(name: Name) : async ?Phone {
        await momento.lookup(name);
    };
};