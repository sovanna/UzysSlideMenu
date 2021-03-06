//
//  UzysSlideMenu.m
//  UzysSlideMenu
//
//  Created by Jaehoon Jung on 13. 2. 21..
//  Copyright (c) 2013년 Uzys. All rights reserved.
//

#import "UzysSlideMenu.h"

@interface UzysSlideMenu()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, assign) UzysSMState state;

-(void)setupLayoutWithTitle:(NSString *)title;
@end

@implementation UzysSlideMenu

- (id)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.pItems = items;
        self.itemViews = [NSMutableArray array];
        self.state = STATE_ICON_MENU;
        
        [self setupLayoutWithTitle:nil];
        [self showIconMenu:NO];
    }
    return self;
}

- (id)initWithItems:(NSArray *)items
            state:(UzysSMState)defaultState
       andMainTitle:(NSString *)mainTitle
{
    self = [super init];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.pItems = items;
        self.itemViews = [NSMutableArray array];
        self.state = defaultState;
        
        [self setupLayoutWithTitle:mainTitle];
        
        switch (defaultState) {
            case STATE_MAIN_MENU:
                [self showMainMenu:NO];
                break;
            case STATE_FULL_MENU:
                [self showFullMenu:NO];
                break;
            case STATE_ICON_MENU:
                [self showIconMenu:NO];
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)dealloc
{
    [_backgroundView release];
    [_itemViews release];
    [_pItems release];
    [super ah_dealloc];
}

- (void)setupLayoutWithTitle:(NSString *)title
{
    UzysSMMenuItemView *itemView = [self setupItemViewModel];
    
    CGFloat menuHeight = itemView.bounds.size.height * [_pItems count];
    CGFloat menuWidth = itemView.bounds.size.width;
    
    [self setFrame:CGRectMake(0, 0, menuWidth, menuHeight)];

    [self.pItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UzysSMMenuItemView *itemView = [self setupItemViewModel];
        
        itemView.frame = CGRectMake(0,
                                    0,
                                    itemView.bounds.size.width,
                                    itemView.bounds.size.height);
        itemView.targetFrame = CGRectMake(0,
                                          itemView.bounds.size.height*idx,
                                          itemView.bounds.size.width,
                                          itemView.bounds.size.height);
        itemView.item = obj;
        itemView.backgroundView.alpha = 0;
        itemView.label.alpha = 0;
        itemView.alpha = 0;
        itemView.userInteractionEnabled = YES;
        itemView.tag = itemView.item.tag;
        itemView.delegate = self;
        
        [self addSubview:itemView];
        [self sendSubviewToBack:itemView];
        [self.itemViews addObject:itemView];
    }];
    
    if (title) [self setupMainTitle:title];
}

- (UzysSMMenuItemView *)setupItemViewModel
{
    UzysSMMenuItemView *itemView = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        itemView = [[[NSBundle mainBundle]
                     loadNibNamed:@"UzysSMMenuItemView"
                     owner:self options:nil] lastObject];
    } else {
        itemView = [[[NSBundle mainBundle]
                     loadNibNamed:@"UzysSMMenuItemViewIPAD"
                     owner:self options:nil] lastObject];
    }
    
    return itemView;
}

- (void)setupMainTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    [label setFrame:CGRectMake(5, 0, self.frame.size.width-5, 45.0)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:title];
    [label setTextColor:[UIColor whiteColor]];
    [self addSubview:label];
}

- (void)openIconMenu
{
    if (self.state != STATE_ICON_MENU) [self showIconMenu:YES];
}

- (void)toggleMenuWithCompletion:(void(^)(UzysSMState state))block
{
    switch (self.state) {
        case STATE_ICON_MENU:
            [self showFullMenu:YES];
            break;
        case STATE_MAIN_MENU:
            [self showFullMenu:YES];
            break;
        case STATE_FULL_MENU:
            [self showMainMenu:YES];
            break;
        default:
            break;
    }
    
    if (block) block(self.menuState);
}

#pragma mark - MenuState

- (void)showIconMenu:(BOOL)animation
{
    if (animation) {
        [UIView animateWithDuration:0.3 delay:0 options:
         UIViewAnimationOptionBeginFromCurrentState |
         UIViewAnimationOptionTransitionCrossDissolve |
         UIViewAnimationOptionCurveEaseOut |
         UIViewAnimationOptionAllowAnimatedContent
                         animations:^{
            [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UzysSMMenuItemView *itemView = obj;
                itemView.frame = CGRectMake(0,
                                            0,
                                            itemView.bounds.size.width,
                                            itemView.bounds.size.height);
                
                if (idx == 0) {
                    itemView.imageView.alpha = 1;
                    itemView.backgroundView.alpha = 0;
                    itemView.label.alpha = 0;
                    itemView.seperatorView.alpha = 0;
                    itemView.alpha = 1;
                } else {
                    itemView.backgroundView.alpha = 0.7;
                    itemView.label.alpha = 0;
                    itemView.seperatorView.alpha = 1;
                    itemView.alpha = 0;
                }
            }];
            
        } completion:^(BOOL finished) {
            self.state = STATE_ICON_MENU;
        }];
        

    }
    else
    {
        [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            UzysSMMenuItemView *itemView = obj;
            itemView.frame = CGRectMake(0, 0, itemView.bounds.size.width, itemView.bounds.size.height);
            
            if(idx ==0)
            {
                itemView.alpha = 1;
                itemView.label.alpha = 0;
                itemView.backgroundView.alpha = 0;
                itemView.seperatorView.alpha = 0;
                itemView.imageView.alpha = 1;
            }
            else
            {
                itemView.backgroundView.alpha = 0.7;
                itemView.label.alpha = 0;
                itemView.seperatorView.alpha = 0;
                itemView.alpha = 0;
            }
        }];
        self.state = STATE_ICON_MENU;

    }
}

- (void)showMainMenu:(BOOL)animation
{    
    if(animation)
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowAnimatedContent animations:^{

            [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                UzysSMMenuItemView *itemView = obj;
                itemView.frame = CGRectMake(0, 0, itemView.bounds.size.width, itemView.bounds.size.height);
                
                if(idx ==0)
                {
                    itemView.alpha = 1;
                    itemView.label.alpha =1;
                    itemView.seperatorView.alpha = 0;
                    itemView.imageView.alpha = 1;
                    itemView.backgroundView.alpha = 0.3;
                }
                else
                {
                    itemView.alpha = 0;
                    itemView.label.alpha =1;
                    itemView.seperatorView.alpha = 0;
                    itemView.imageView.alpha = 1;
                    itemView.backgroundView.alpha = 0.3;
                }
            }];
            
        } completion:^(BOOL finished) {
            self.state = STATE_MAIN_MENU;
        }];
    }
    else
    {
        [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            UzysSMMenuItemView *itemView = obj;
            itemView.frame = CGRectMake(0, 0, itemView.bounds.size.width, itemView.bounds.size.height);
            
            if(idx ==0)
            {
                itemView.alpha = 1;
                itemView.label.alpha =1;
                itemView.seperatorView.alpha = 0;
                itemView.imageView.alpha = 1;
                itemView.backgroundView.alpha = 0.3;
            }
            else
            {
                itemView.alpha = 0;
                itemView.label.alpha =1;
                itemView.seperatorView.alpha = 0;
                itemView.imageView.alpha = 1;
                itemView.backgroundView.alpha = 0.3;
            }
        }];
        
        self.state = STATE_MAIN_MENU;
    }
}

- (void)showFullMenu:(BOOL)animation
{
    if(animation)
    {
        
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseIn animations:^{
            [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                UzysSMMenuItemView *itemView = obj;
                itemView.targetFrame = CGRectMake(0, itemView.bounds.size.height*idx, itemView.bounds.size.width, itemView.bounds.size.height);
                itemView.alpha = 0.1;
            }];
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseOut animations:^{
                
                [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    UzysSMMenuItemView *itemView = obj;
                    itemView.alpha = 1;
                    itemView.frame = itemView.targetFrame;
                    itemView.backgroundView.alpha = 0.85;
                    itemView.label.alpha = 1;
                    itemView.seperatorView.alpha = 1;
                    
                    
                }];
                
                
            } completion:^(BOOL finished) {
                 self.state = STATE_FULL_MENU;
            }];
            
        }];
    }
    else
    {
        [self.itemViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UzysSMMenuItemView *itemView = obj;
            itemView.targetFrame = CGRectMake(0, itemView.bounds.size.height*idx, itemView.bounds.size.width, itemView.bounds.size.height);
            itemView.alpha = 1;
            itemView.frame = itemView.targetFrame;
            itemView.backgroundView.alpha = 0.85;
            itemView.label.alpha = 1;
            itemView.seperatorView.alpha = 1;
            
            
        }];
        self.state = STATE_FULL_MENU;
    }
}

#pragma mark - Delegate

- (void)UzysSMMenuItemDidAction:(UzysSMMenuItemView *)itemView
{
    [self.itemViews removeObject:itemView];
    [self.itemViews insertObject:itemView atIndex:0];
    [self toggleMenuWithCompletion:nil];
}

#pragma mark - help method

- (CGRect)getMainIconFrame:(UIView *)view
{
    UzysSMMenuItemView *itemView = [self.itemViews objectAtIndex:0];
    return [self convertRect:itemView.imageView.frame toView:view];
}

#pragma mark - Property

- (UzysSMState)menuState
{
    return _state;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if(self.state == STATE_FULL_MENU)
    {
        if(CGRectContainsPoint(self.frame, point))
        {

            return [super hitTest:point withEvent:event];
        }
        else
        {
            return nil;
        }        
    }
    else if(self.state == STATE_ICON_MENU)
    {
        UzysSMMenuItemView *view = [self.itemViews objectAtIndex:0];
        
        if(CGRectContainsPoint(view.imageView.frame, point))
        {
//            return view.imageView;
            return [super hitTest:point withEvent:event];
        }
        else
        {
            return nil;
        }
    }
    else if(self.state == STATE_MAIN_MENU)
    {
        UzysSMMenuItemView *view = [self.itemViews objectAtIndex:0];
        if(CGRectContainsPoint(view.frame, point))
        {
//            return view;
            return [super hitTest:point withEvent:event];
        }
        else
        {
            return nil;
        }
    }
       
    return nil;
}

@end
