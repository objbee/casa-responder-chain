//
//  UIResponder+Router.m
//  casa-responder-chain
//
//  Created by yuanye on 27/07/2017.
//  Copyright © 2017 yuanye. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

- (NSInvocation *)createInvocationWithSelector:(SEL)selector
{
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    return invocation;
}

@end
