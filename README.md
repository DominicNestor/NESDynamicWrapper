# NESDynamicWrapper
DynamicProxy in iOS based on block

###How to use
1.Regist handler for the wrapper. It can be done anywhere, but need to be done before you use it.

    NESDynamicWrapper *wrapper = [NESDynamicWrapper sharedInstance];
    [wrapper addHandler:[NESCustomHandler handlerWith:^(NSInvocation *anInvocation) {
        NSLog(@"%s-[%s]:handler 1",__func__,__TIME__);
        [anInvocation invoke];
    } prefix:@"t1"],
     [NESCustomHandler handlerWith:^(NSInvocation *anInvocation) {
        NSLog(@"%s-[%s]:handler 2",__func__,__TIME__);
        [anInvocation invoke];
    } prefix:@"t2"],
     [NESCustomHandler handlerWith:^(NSInvocation *anInvocation) {
        NSLog(@"%s-[%s]:handler 3",__func__,__TIME__);
        [anInvocation invoke];
    } prefix:@"t3"],
     nil];

2.Put this code in any implementation you want.
    
    +(void)load
    {
        [NESDynamicWrapper swizz:[self class]];
    }

3.Give the prefix before the implementation of some method like this:

    -(void)test;

    -(void)t1_test
    {
        NSLog(@"%s-[%s]:test",__func__,__TIME__);
    }

4.Just use it like nothing happend.
    
    [obj test];


