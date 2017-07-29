//
//  ATableViewCell.h
//  casa-responder-chain
//
//  Created by yuanye on 27/07/2017.
//  Copyright © 2017 yuanye. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const ATableViewCellAEvent;
extern NSString * const ATableViewCellBEvent;

@interface ATableViewCell : UITableViewCell

- (void)configWithIndexPathRow:(NSInteger)row;

@end
