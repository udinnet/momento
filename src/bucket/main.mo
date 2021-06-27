import Array "mo:base/Array";
import Text "mo:base/Text";
import Nat "mo:base/Nat";

actor {

    public type Bucket = {
        id : Nat;
        name : Text;
        objectList : [Nat];
    };

    stable var bucketList: [Bucket] = [];

    public func create(bucketName: Text) : async Nat {
        
        let bucket : Bucket = {
            id = bucketList.size();
            name = bucketName;
            objectList=[];
        };
        

        bucketList := Array.append<Bucket>(bucketList, [bucket]);
        return bucket.id;
    };

    public func addObject(id: Nat, objectId: Nat) : async () {
        bucketList := Array.map<Bucket,Bucket>(bucketList, func (bucket : Bucket) : Bucket {
            if (bucket.id == id) {
                return {
                    id = bucket.id;
                    name = bucket.name;
                    objectList = Array.append<Nat>(bucket.objectList, [objectId]);
                };
            };
            bucket
        });
    };

    public query func get(id: Nat) : async Bucket {
        return bucketList[id];
    };
    
    public query func listBuckets() : async [Bucket]  {
        return bucketList;
    };

};