//
//  CusTomActionSheetView.h
//  card
//
//  Created by 武淅 段 on 16/5/19.
//  Copyright © 2016年 Papaya Mobile Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CusTomActionSheetView : UIView

typedef void(^tapItemHandler)(NSInteger buttonIndex);

@property (nonatomic) NSMutableArray<tapItemHandler> *actionArray;
@property (nonatomic, copy) tapItemHandler handler;

- (instancetype) initWithTitle : (NSString *)title andItemTitles : (NSArray *)titles cancleTitle : (NSString *)cancleTitle;

- (void) show;

@end
