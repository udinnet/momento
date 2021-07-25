import List "mo:base/List";

import Types "./types"

module {
    public func rulesIn(rules: List.List<Types.Rule>, userRules: List.List<Types.Rule>) : ?Types.Rule {
        return List.find<Types.Rule>(rules, func (x: Types.Rule) : Bool {
            for (y in List.toArray(userRules).vals()) {
                if (x.role == y.role and x.resource == y.resource and x.operation == y.operation) {
                    return true;
                }
            };
            return false;
        });
    }
}