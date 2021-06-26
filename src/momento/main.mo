import L "mo:base/List";
import A "mo:base/AssocList";

actor {
    public type Name = Text;
    public type Phone = Text;

    flexible var book: A.AssocList<Name, Phone> = L.nil<(Name, Phone)>();

    func nameEq(l: Name, r: Name): Bool {
        return l == r;
    };

    public func insert(name: Name, phone: Phone): async () {
        let (newBook, _) = A.replace<Name, Phone>(book, name, nameEq, ?phone);
        book := newBook;
    };

    public query func lookup(name: Name): async ?Phone {
        return A.find<Name, Phone>(book, name, nameEq);
    };
};