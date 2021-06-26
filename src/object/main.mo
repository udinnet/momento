import Text "mo:base/Text";
import Map "mo:base/HashMap";
import Array "mo:base/Array";
import Iter "mo:base/Iter";

actor {
    //TODO: Review load factor
    stable var storedMap : [(Text, Text)] = [];
    let map =  Map.fromIter<Text,Text>(storedMap.vals(),
     10, Text.equal, Text.hash);

    //Todo, link object to a bucket

    public func set(key  : Text, value: Text) : async () {
        map.put(key, value);
    };


    public query func get(key: Text): async ?Text {
        return map.get(key);
    };

    system func preupgrade() {
        storedMap := Iter.toArray(map.entries());
    };

    system func postupgrade() {
        storedMap := [];
    };
};