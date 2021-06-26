import Text "mo:base/Text";
import Map "mo:base/HashMap";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";


import bucket "canister:bucket"

actor {
    public type UUID = Nat;

    //TODO: Review load factor
    stable var storedMap : [(UUID, Text)] = [];
    stable var objectId : UUID = 0;

    let map =  Map.fromIter<UUID,Text>(storedMap.vals(),
     10, Nat.equal, Hash.hash);


    public func set(bucketId: Nat, value: Text) : async UUID {
        objectId += 1;
        map.put(objectId, value);

        ignore bucket.addObject (bucketId,objectId); //don't need to wait

        return objectId;
    };


    public query func get(key: UUID): async ?Text {
        return map.get(key);
    };

    system func preupgrade() {
        storedMap := Iter.toArray(map.entries());
    };

    system func postupgrade() {
        storedMap := [];
    };
};