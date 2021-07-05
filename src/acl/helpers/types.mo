module {
    public type Role = Text;
    public type Resource = Text;
    public type Operation = Text;

    //Upgrade to type Principal later
    public type UserId = Text;
    
    public type Rule = {
        role : Role;
        resource : Resource;
        operation : Operation;
    };
}