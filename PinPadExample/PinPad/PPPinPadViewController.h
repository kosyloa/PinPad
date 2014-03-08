//
//  VTPinPadViewController.h
//  PinPad
//
//  Created by Aleks Kosylo on 1/15/14.
//  Copyright (c) 2014 Aleks Kosylo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PinPadPasswordProtocol <NSObject>

@required
- (NSInteger)pinLenght;
@optional
- (BOOL)checkPin:(NSString *)pin;
- (void)userPassCode:(NSString *)newPassCode;
@end


@interface PPPinPadViewController : UIViewController {
    __weak IBOutlet UIView *_pinCirclesView;
    __weak IBOutlet UIView *_errorView;
    NSMutableString *_inputPin;
    NSMutableArray *_circleViewList;
}

@property (nonatomic,assign) id<PinPadPasswordProtocol> delegate;
@property (nonatomic) BOOL isSettingPinCode;

@end
