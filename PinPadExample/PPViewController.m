//
//  PPViewController.m
//  PinPadExample
//
//  Created by Aleks Kosylo on 1/31/14.
//  Copyright (c) 2014 Aleks Kosylo. All rights reserved.
//

#import "PPViewController.h"
#import "PPPinPadViewController.h"
@interface PPViewController ()

@end

@implementation PPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    PPPinPadViewController * pinViewController = [[PPPinPadViewController alloc] init];
    pinViewController.delegate = self;
    pinViewController.pinTitle = @"Enter Passcode";
    pinViewController.errorTitle = @"Passcode is not correct";
    pinViewController.cancelButtonHidden = NO; //default is False
    pinViewController.backgroundImage = [UIImage imageNamed:@"pinViewImage"]; //if you need remove the background set a empty UIImage ([UIImage new]) or set a background color
//    pinViewController.backgroundColor = [UIColor blueColor]; //default is a darkGrayColor
    
    [self presentViewController:pinViewController animated:YES completion:NULL];
}

- (BOOL)checkPin:(NSString *)pin {
    return [pin isEqualToString:@"1234"];
}

- (NSInteger)pinLenght {
    return 4;
}
@end
