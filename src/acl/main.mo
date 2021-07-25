import Debug "mo:base/Debug";
import Hash "mo:base/Blob";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Map "mo:base/HashMap";
import Option "mo:base/Option";
import Text "mo:base/Text";
import TrieSet "mo:base/TrieSet";
import Types "./helpers/types";
import Utils "./helpers/utils";

actor {
    private stable var allowed : List.List<Types.Rule> = List.nil();
    private stable var denied : List.List<Types.Rule> = List.nil();
    private stable var roles : [(Types.UserId, TrieSet.Set<Types.Role>)] = [];

    let roleMap = Map.fromIter<Types.UserId, TrieSet.Set<Types.Role>>(roles.vals(), 10, Text.equal, Text.hash);

    public func addRole(user: Types.UserId, role: Types.Role) : async () {
        let userExistingRoles = switch (roleMap.get(user)) {
            case null {
                let userRoles : TrieSet.Set<Types.Role> = TrieSet.put<Types.Role>(TrieSet.empty<Types.Role>(), role, Text.hash role, Text.equal);
                roleMap.put(user, userRoles);
            };
            case (?userExistingRoles) {
                let userRoles : TrieSet.Set<Types.Role> = TrieSet.put<Types.Role>(userExistingRoles, role, Text.hash role, Text.equal);
                roleMap.put(user, userRoles);
            };
        };
    };

    public query func getRoles(user: Types.UserId) : async ?[Types.Role] {
        return ?TrieSet.toArray<Types.Role>(Option.get<TrieSet.Set<Types.Role>>(roleMap.get(user), TrieSet.empty<Types.Role>()));
    };

    public func addAllowed(role: Types.Role, resource: Types.Resource, operation: Types.Operation) : async () {
        allowed := List.push(
            {
                role = role;
                resource = resource;
                operation = operation;
            },
            allowed
        )
    };

    public func addDenied(role: Types.Role, resource: Types.Resource, operation: Types.Operation) : async () {
        denied := List.push(
            {
                role = role;
                resource = resource;
                operation = operation;
            },
            denied
        )
    };

    public query func isAllowed(user: Types.UserId, resource: Types.Resource, operation: Types.Operation) : async Bool {
        let userRoles = Option.get<TrieSet.Set<Types.Role>>(roleMap.get(user), TrieSet.empty<Types.Role>());
        var candidateList : List.List<Types.Rule> = List.nil(); //mutable list, so using var here 
        for (r in TrieSet.toArray<Types.Role>(userRoles).vals()) {
            candidateList := List.push(
                {
                    role = r;
                    resource = resource;
                    operation = operation;
                },
                candidateList
            )
        };
        
        if (Utils.rulesIn(denied, candidateList) != null) {
            return false;
        };

        if (Utils.rulesIn(allowed, candidateList) != null) {
            return true;
        };

        return false;
    };

    system func preupgrade() {
        roles := Iter.toArray(roleMap.entries());
    };

    system func postupgrade() {
        roles := [];
    };
};