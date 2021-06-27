import Blob "mo:base/Blob";
import Map "mo:base/HashMap";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";


import bucket "canister:bucket"

actor {
    public type UUID = Nat;

    //TODO: Review load factor
    stable var storedMap : [(UUID, Blob)] = [];
    stable var objectId : UUID = 0;

    let map =  Map.fromIter<UUID,Blob>(storedMap.vals(),
     10, Nat.equal, Hash.hash);

    //To run it use:  dfx canister call object set '(1, vec {40;20})'
    public func set(bucketId: Nat, value: Blob) : async UUID {
        objectId += 1;
        map.put(objectId, value);

        ignore bucket.addObject (bucketId,objectId); //don't need to wait

        return objectId;
    };


    public query func get(key: UUID): async ?Blob {
        return map.get(key);
    };

    system func preupgrade() {
        storedMap := Iter.toArray(map.entries());
    };

    system func postupgrade() {
        storedMap := [];
    };
};