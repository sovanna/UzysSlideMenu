//
//  UzysSMMenuView.m
//  UzysSlideMenu
//
//  Created by Jaehoon Jung on 13. 2. 21..
//  Copyright (c) 2013년 Uzys. All rights reserved.
//

#import "UzysSMMenuItemView.h"

@implementation UzysSMMenuItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self callItemAction];
}

- (void)setItem:(UzysSMMenuItem *)item
{
    [_item release];
    _item = [item ah_retain];
    _imageView.image = item.image;
    _label.text = item.title;
    
}

- (void)dealloc {
    [_imageView release];
    [_label release];
    [_seperatorView release];
    [_backgroundView release];
    [_item release];
    [super ah_dealloc];
}

#pragma mark - Functions

- (void)callItemAction
{
    if (_item.block) {
        BOOL isRespondAction = [self.delegate
                                respondsToSelector:@selector(UzysSMMenuItemDidAction:)];
        
        if (isRespondAction && self.delegate) {
            [self.delegate UzysSMMenuItemDidAction:self];
        }
        _item.block(_item);
    }
}

#pragma mark - using gestureRecognizer

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(gestureTapped:)] autorelease];
    [tapGesture setDelegate:self];
    [tapGesture setNumberOfTapsRequired:1];
    
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:tapGesture];
}

- (void)gestureTapped:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self callItemAction];
    }
}
@end
