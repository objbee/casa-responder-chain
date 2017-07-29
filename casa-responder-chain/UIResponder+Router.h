//
//  UIResponder+Router.h
//  casa-responder-chain
//
//  Created by yuanye on 27/07/2017.
//  Copyright © 2017 yuanye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;
- (NSInvocation *)createInvocationWithSelector:(SEL)selector;

@end
