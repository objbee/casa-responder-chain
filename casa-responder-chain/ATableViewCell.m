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

@interface ATableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation ATableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.confirmButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = 12;
    
    self.titleLabel.frame = CGRectMake(padding, 0, self.width * 0.5 - padding * 1.5, self.height);
    self.confirmButton.frame = CGRectMake(self.titleLabel.right + padding * 0.5, 0, self.titleLabel.width, self.height * 0.5);
    [self.confirmButton centerYEqualToView:self];
}

#pragma mark - event

- (void)onClickConfirmButton
{
    NSLog(@"confirmButton log: %@", self.titleLabel.text);
    
    [self routerEventWithName:@"ATableViewCellConfirmButtonOnClick" userInfo:@{@"log" : (self.titleLabel.text ? self.titleLabel.text : @"")}];
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    NSMutableDictionary *mUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [mUserInfo setValue:NSStringFromClass(self.class) forKey:@"cell"];
    
    // 如果需要让事件继续往上传递，则调用下面的语句
    [super routerEventWithName:eventName userInfo:mUserInfo];
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

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor = [UIColor orangeColor];
        _confirmButton.clipsToBounds = YES;
        _confirmButton.layer.cornerRadius = 5;
        [_confirmButton setTitle:@"log row" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(onClickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
