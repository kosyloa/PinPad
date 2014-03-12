//
//  VTPinPadViewController.m
//  PinPad
//
//  Created by Aleks Kosylo on 1/15/14.
//  Copyright (c) 2014 Aleks Kosylo. All rights reserved.
//

#import "PPPinPadViewController.h"
#import "PPPinCircleView.h"


#define PP_SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)


typedef NS_ENUM(NSInteger, settingNewPinState) {
    settingMewPinStateFisrt   = 0,
    settingMewPinStateConfirm = 1
};
@interface PPPinPadViewController () {
    NSInteger _shakes;
    NSInteger _direction;
}
@property (nonatomic)                   settingNewPinState  newPinState;
@property (nonatomic,strong)            NSString            *fisrtPassCode;
@property (weak, nonatomic) IBOutlet    UILabel             *laInstructionsLabel;
@end

static  CGFloat kVTPinPadViewControllerCircleRadius = 6.0f;
@implementation PPPinPadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCircles];
	
    pinLabel.text = self.pinTitle ? :@"Enter PIN";
    pinErrorLabel.text = self.errorTitle ? : @"PIN number is not correct";
    cancelButton.hidden = self.cancelButtonHidden;
    if (self.backgroundImage) {
        backgroundImageView.hidden = NO;
        backgroundImageView.image = self.backgroundImage;
    }
    
    if (self.backgroundColor && !self.backgroundImage) {
        backgroundImageView.hidden = YES;
        self.view.backgroundColor = self.backgroundColor;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setCancelButtonHidden:(BOOL)cancelButtonHidden{
    _cancelButtonHidden = cancelButtonHidden;
    cancelButton.hidden = cancelButtonHidden;
}

- (void) setErrorTitle:(NSString *)errorTitle{
    _errorTitle = errorTitle;
    pinErrorLabel.text = errorTitle;
}

- (void) setPinTitle:(NSString *)pinTitle{
    _pinTitle = pinTitle;
    pinLabel.text = pinTitle;
}

- (void) setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    backgroundImageView.image = backgroundImage;
    backgroundImageView.hidden = NO;
}

- (void) setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    self.view.backgroundColor = backgroundColor;
    backgroundImageView.hidden = YES;
}


- (void)dismissPinPad {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pinPadWillHide)]) {
        [self.delegate pinPadWillHide];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(pinPadDidHide)]) {
            [self.delegate pinPadDidHide];
        }
    }];
}


#pragma mark Status Bar
- (void)changeStatusBarHidden:(BOOL)hidden {
    _errorView.hidden = hidden;
    if (PP_SYSTEM_VERSION_GREATER_THAN(@"6.9")) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

-(BOOL)prefersStatusBarHidden
{
    return !_errorView.hidden;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)setIsSettingPinCode:(BOOL)isSettingPinCode{
    _isSettingPinCode = isSettingPinCode;
    if (isSettingPinCode) {
        self.newPinState = settingMewPinStateFisrt;
    }
}
#pragma mark Actions

- (IBAction)cancelClick:(id)sender {
    [self dismissPinPad];
}

- (IBAction)resetClick:(id)sender {
    [self addCircles];
    self.newPinState    = settingMewPinStateFisrt;
    self.laInstructionsLabel.text = NSLocalizedString(@"Enter PassCode", @"");
    _inputPin = [NSMutableString string];
}


- (IBAction)numberButtonClick:(id)sender {
    if(!_inputPin) {
        _inputPin = [NSMutableString new];
    }
    if(!_errorView.hidden) {
        [self changeStatusBarHidden:YES];
    }
    [_inputPin appendString:[((UIButton*)sender) titleForState:UIControlStateNormal]];
    [self fillingCircle:_inputPin.length - 1];
    
    if (self.isSettingPinCode){
        if ([self pinLenght] == _inputPin.length){
            if (self.newPinState == settingMewPinStateFisrt) {
                self.fisrtPassCode  = _inputPin;
                // reset and prepare for confirmation stage
                [self resetClick:Nil];
                self.newPinState    = settingMewPinStateConfirm;
                // update instruction label
                self.laInstructionsLabel.text = NSLocalizedString(@"Confirm PassCode", @"");
            }else{
                // we are at confirmation stage check this pin with original one
                if ([self.fisrtPassCode isEqualToString:_inputPin]) {
                    // every thing is ok
                    if ([self.delegate respondsToSelector:@selector(userPassCode:)]) {
                        [self.delegate userPassCode:self.fisrtPassCode];
                    }
                    [self dismissPinPad];
                }else{
                    // reset to first stage
                    self.laInstructionsLabel.text = NSLocalizedString(@"Enter PassCode", @"");
                    _direction = 1;
                    _shakes = 0;
                    [self shakeCircles:_pinCirclesView];
                    [self changeStatusBarHidden:NO];
                    [self resetClick:Nil];
                }
            }
        }
    }else{
        if ([self pinLenght] == _inputPin.length && [self checkPin:_inputPin]) {
            double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSLog(@"Correct pin");
                [self resetClick:nil];
                if (self.delegate && [self.delegate respondsToSelector:@selector(pinPadSuccessPin)]) {
                    [self.delegate pinPadSuccessPin];
                }
                [self dismissPinPad];
            });
            
        }
        else if ([self pinLenght] == _inputPin.length) {
            _direction = 1;
            _shakes = 0;
            [self shakeCircles:_pinCirclesView];
            [self changeStatusBarHidden:NO];
            NSLog(@"Not correct pin");
        }
    }
}

#pragma mark Delegate & methods

- (void)setDelegate:(id<PinPadPasswordProtocol>)delegate {
    if(_delegate != delegate) {
        _delegate = delegate;
        [self addCircles];
    }
}

- (BOOL)checkPin:(NSString *)pinString {
    if(self.delegate && [self.delegate respondsToSelector:@selector(checkPin:)]) {
        return [self.delegate checkPin:pinString];
    }
    return NO;
}

- (NSInteger)pinLenght {
    if([self.delegate respondsToSelector:@selector(pinLenght)]) {
        return [self.delegate pinLenght];
    }
    return 4;
}

#pragma mark Circles


- (void)addCircles {
    if([self isViewLoaded] && self.delegate) {
        [[_pinCirclesView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_circleViewList removeAllObjects];
        _circleViewList = [NSMutableArray array];
        
        CGFloat neededWidth =  [self pinLenght] * kVTPinPadViewControllerCircleRadius;
        CGFloat shiftBetweenCircle = (_pinCirclesView.frame.size.width - neededWidth )/([self pinLenght] +2);
        CGFloat indent= 1.5* shiftBetweenCircle;
        if(shiftBetweenCircle > kVTPinPadViewControllerCircleRadius * 5.0f) {
            shiftBetweenCircle = kVTPinPadViewControllerCircleRadius * 5.0f;
            indent = (_pinCirclesView.frame.size.width - neededWidth  - shiftBetweenCircle *([self pinLenght] > 1 ? [self pinLenght]-1 : 0))/2;
        }
        for(int i=0; i < [self pinLenght]; i++) {
            PPPinCircleView * circleView = [PPPinCircleView circleView:kVTPinPadViewControllerCircleRadius];
            CGRect circleFrame = circleView.frame;
            circleFrame.origin.x = indent + i * kVTPinPadViewControllerCircleRadius + i*shiftBetweenCircle;
            circleFrame.origin.y = (CGRectGetHeight(_pinCirclesView.frame) - kVTPinPadViewControllerCircleRadius)/2.0f;
            circleView.frame = circleFrame;
            [_pinCirclesView addSubview:circleView];
            [_circleViewList addObject:circleView];
        }
    }
}

- (void)fillingCircle:(NSInteger)symbolIndex {
    if(symbolIndex>=_circleViewList.count)
        return;
    PPPinCircleView *circleView = [_circleViewList objectAtIndex:symbolIndex];
    circleView.backgroundColor = [UIColor whiteColor];
}

-(void)shakeCircles:(UIView *)theOneYouWannaShake
{
    [UIView animateWithDuration:0.03 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*_direction, 0);
     }
                     completion:^(BOOL finished)
     {
         if(_shakes >= 15)
         {
             theOneYouWannaShake.transform = CGAffineTransformIdentity;
             [self resetClick:nil];
             return;
         }
         _shakes++;
         _direction = _direction * -1;
         [self shakeCircles:theOneYouWannaShake];
     }];
}
@end
