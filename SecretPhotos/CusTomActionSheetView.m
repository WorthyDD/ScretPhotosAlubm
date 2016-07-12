//
//  CusTomActionSheetView.m
//  card
//
//  Created by 武淅 段 on 16/5/19.
//  Copyright © 2016年 Papaya Mobile Inc. All rights reserved.
//

#import "CusTomActionSheetView.h"
#import "UIColor+TAToolkit.h"

@interface CusTomActionSheetView()

@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, weak) UIView *itemsView;
//@property (nonatomic) NSMutableArray<UIButton *> *buttons;
@end

@implementation CusTomActionSheetView


- (instancetype) initWithTitle : (NSString *)title andItemTitles : (NSArray *)titles cancleTitle : (NSString *)cancleTitle
{
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self = [super initWithFrame:CGRectMake(0, 0, screenWith, screenHeight)];
    if(self){
        
//        self.buttons = [NSMutableArray new];
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.0]];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.parentView = [UIApplication sharedApplication].keyWindow;
        CGFloat rowHeight = 54;
        CGFloat height = titles.count*rowHeight + titles.count-1;
        if(title){
            height+=rowHeight;
        }
        if(cancleTitle){
            height += rowHeight+6;
        }
        
        UIView *itemsView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight-height, screenWith, height)];
        [itemsView setBackgroundColor:[UIColor colorWithRGB:0xc7c7c7]];
        self.itemsView = itemsView;
        [self addSubview:itemsView];
        
        if(title){
            
            UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWith, rowHeight)];
            [titleView setBackgroundColor:[UIColor colorWithRGB:0xf4f4f4]];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:titleView.bounds];
            [titleLabel setText:title];
            [titleLabel setTextColor:[UIColor colorWithRGB:0x999999]];
            [titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [titleLabel setTextAlignment:NSTextAlignmentCenter];
            [titleView addSubview:titleLabel];
            [itemsView addSubview:titleView];
        }
        
        CGFloat y = rowHeight;
        NSInteger tag = 0;
        for(NSString *name in titles){
            
            UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(0, y, screenWith, rowHeight)];
            [b setTitle:name forState:UIControlStateNormal];
            [b setTitleColor:[UIColor colorWithRGB:0x333333] forState:UIControlStateNormal];
            [b.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
            [b setBackgroundColor:[UIColor whiteColor]];
            [itemsView addSubview:b];
            y += rowHeight+1;
            
            b.tag = tag++;
            [b addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if(cancleTitle){
            y+=5;
            UIButton *cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, y, screenWith, rowHeight)];
            [cancleButton setTitle:cancleTitle forState:UIControlStateNormal];
            [cancleButton setTitleColor:[UIColor colorWithRGB:0x333333] forState:UIControlStateNormal];
            [cancleButton.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
            [cancleButton setBackgroundColor:[UIColor whiteColor]];
            [itemsView addSubview:cancleButton];
            [cancleButton addTarget:self action:@selector(didTapCancleButton) forControlEvents:UIControlEventTouchUpInside];
        }
        
        CGRect frame = itemsView.frame;
        frame.origin.y = screenHeight;
        itemsView.frame = frame;
    }
    return self;
}


- (void) didTapCancleButton
{
    [self dismiss];
}

- (void) didTapButton : (UIButton *)sender
{
    [self dismiss];
    if(self.handler){
        self.handler(sender.tag);
    }
}

- (void)show
{
    if(!self.superview){
        [self.parentView addSubview:self];
    }
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGRect frame = _itemsView.frame;
    frame.origin.y = screenHeight-frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        _itemsView.frame = frame;
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    }];
}

- (void) dismiss
{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGRect frame = _itemsView.frame;
    frame.origin.y = screenHeight;
    [UIView animateWithDuration:0.3 animations:^{
        _itemsView.frame = frame;
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.0]];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
