import List "mo:base/List";

import Types "./types"

module {
    public func ruleIn(rules: List.List<Types.Rule>, rule: Types.Rule) : ?Types.Rule {
        return List.find<Types.Rule>(rules, func (x: Types.Rule) : Bool {
            return x.role == rule.role and x.resource == rule.resource and x.operation == rule.operation;
        });
    }
}