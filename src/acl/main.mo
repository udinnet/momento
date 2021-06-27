import Map "mo:base/HashMap";
import Text "mo:base/Text";
import List "mo:base/List";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Option "mo:base/Option";

import Types "./helpers/types";
import Utils "./helpers/utils";

actor {
    private stable var allowed : List.List<Types.Rule> = List.nil();
    private stable var denied : List.List<Types.Rule> = List.nil();
    private stable var roles : [(Types.UserId, Types.Role)] = [];

    let roleMap = Map.fromIter<Types.UserId, Types.Role>(roles.vals(), 10, Text.equal, Text.hash);

    public func addRole(user: Types.UserId, role: Types.Role) : async () {
        switch (roleMap.get(user)) {
            case null {
                roleMap.put(user, role);
            };
            case (?id) { };
        };
    };

    public query func getRole(user: Types.UserId) : async ?Types.Role {
        return roleMap.get(user);
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
        var candidate : Types.Rule = {
            role = Option.get<Types.Role>(roleMap.get(user), "");
            resource = resource;
            operation = operation;
        };
        
        var isDenied = Utils.ruleIn(denied, candidate);
        if (isDenied != null) {
            return false;
        };

        var isAllowed = Utils.ruleIn(allowed, candidate);
        if (isAllowed != null) {
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