//
//  ATableViewCell.m
//  casa-responder-chain
//
//  Created by yuanye on 27/07/2017.
//  Copyright © 2017 yuanye. All rights reserved.
//

#import "ATableViewCell.h"
#import <HandyFrame/UIView+LayoutMethods.h>
#import "UIResponder+Router.h"

NSString * const ATableViewCellAEvent = @"ATableViewCell_AEvent";
NSString * const ATableViewCellBEvent = @"ATableViewCell_BEvent";

@interface ATableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *aButton;
@property (nonatomic, strong) UIButton *bButton;
@property (nonatomic, copy) NSDictionary *eventStrategy;

@end

@implementation ATableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.aButton];
        [self.contentView addSubview:self.bButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = 10;
    CGFloat width = (self.width - padding * 4) / 3;
    
    self.titleLabel.frame = CGRectMake(padding, 0, width, self.height);
    self.aButton.frame = CGRectMake(self.titleLabel.right + padding, 0, width, self.height * 0.5);
    [self.aButton centerYEqualToView:self];
    self.bButton.frame = CGRectMake(self.aButton.right + padding, 0, width, self.aButton.height);
    [self.bButton centerYEqualToView:self];
}

#pragma mark - event

- (void)onClickAButton
{
    NSLog(@"%s", __func__);
    
    [self routerEventWithName:ATableViewCellAEvent userInfo:@{@"aTitle" : (self.titleLabel.text ? self.titleLabel.text : @"")}];
}

- (void)onClickBButton
{
    NSLog(@"%s", __func__);
    
    [self routerEventWithName:ATableViewCellBEvent userInfo:@{@"bTitle" : (self.titleLabel.text ? self.titleLabel.text : @"")}];
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    NSInvocation *invocation = self.eventStrategy[eventName];
    [invocation setArgument:&userInfo atIndex:2];
    [invocation invoke];
    
    // 如果需要让事件继续往上传递，则调用下面的语句
    // [super routerEventWithName:eventName userInfo:userInfo];
}

- (void)aEvent:(NSDictionary *)userInfo
{
    NSLog(@"不需要让事件继续往上传递 \n eventName:%@ \n userInfo:%@", ATableViewCellAEvent, userInfo);
}

- (void)bEvent:(NSDictionary *)userInfo
{
    NSMutableDictionary *mUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [mUserInfo setValue:NSStringFromClass(self.class) forKey:@"eventClass"];
    
    // 如果需要让事件继续往上传递，则调用下面的语句
    [super routerEventWithName:ATableViewCellBEvent userInfo:mUserInfo];
}

#pragma mark - public method

- (void)configWithIndexPathRow:(NSInteger)row
{
    self.titleLabel.text = [NSString stringWithFormat:@"row = %@", @(row)];
}

#pragma mark - getter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UIButton *)aButton
{
    if (!_aButton) {
        _aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _aButton.backgroundColor = [UIColor lightGrayColor];
        _aButton.clipsToBounds = YES;
        _aButton.layer.cornerRadius = 5;
        [_aButton setTitle:@"A" forState:UIControlStateNormal];
        [_aButton addTarget:self action:@selector(onClickAButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _aButton;
}

- (UIButton *)bButton
{
    if (!_bButton) {
        _bButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bButton.backgroundColor = [UIColor darkGrayColor];
        _bButton.clipsToBounds = YES;
        _bButton.layer.cornerRadius = 5;
        [_bButton setTitle:@"B" forState:UIControlStateNormal];
        [_bButton addTarget:self action:@selector(onClickBButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bButton;
}

- (NSDictionary<NSString *, NSInvocation *> *)eventStrategy
{
    if (!_eventStrategy) {
        _eventStrategy = @{
                           ATableViewCellAEvent: [self createInvocationWithSelector:@selector(aEvent:)],
                           ATableViewCellBEvent: [self createInvocationWithSelector:@selector(bEvent:)]
                           };
    }
    return _eventStrategy;
}

@end
