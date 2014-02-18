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
- (BOOL)checkPin:(NSString *)pin;
@optional
- (void)pinPadWillHide;
- (void)pinPadDidHide;
@end


@interface PPPinPadViewController : UIViewController {
    __weak IBOutlet UIView *_pinCirclesView;
    __weak IBOutlet UIView *_errorView;
    __weak IBOutlet UILabel *pinLabel;
    __weak IBOutlet UILabel *pinErrorLabel;
    __weak IBOutlet UIImageView *backgroundImageView;
    __weak IBOutlet UIButton *resetButton;
    __weak IBOutlet UIButton *cancelButton;
    NSMutableString *_inputPin;
    NSMutableArray *_circleViewList;
}

@property (nonatomic,assign) id<PinPadPasswordProtocol> delegate;

@property (nonatomic, strong) NSString *errorTitle;
@property (nonatomic, strong) NSString *pinTitle;
@property (nonatomic, assign) BOOL cancelButtonHidden;


@end
