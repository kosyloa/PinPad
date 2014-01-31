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
    
    [self presentViewController:pinViewController animated:YES completion:NULL];
    pinViewController.delegate = self;
}

- (BOOL)checkPin:(NSString *)pin {
    return [pin isEqualToString:@"123456"];
}

- (NSInteger)pinLenght {
    return 6;
}
@end
