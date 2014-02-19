PinPad
======

View like iOS7 Lock screen

Dinamic count of input numbers and custom configuration, works on iOS 5 and above 

How to use
======

- add the folder **PinPad** in your project folder

- add <code>#import "PPPinPadViewController.h"</code> in your viewController(in the .h file)

- implement the protocol <code>PinPadPasswordProtocol</code> in your class

- this protocol have a simple methods to control the pin pad

		- (BOOL)checkPin:(NSString *)pin; 	//required, validation with your configured code
		- (NSInteger)pinLenght; 			//optional, works like a data source of pin lenght
		- (void)pinPadSuccessPin;			//optional, when the user set a correct pin
		- (void)pinPadWillHide;				//optional, before the pin pad hide
		- (void)pinPadDidHide;				//optional, after pin pad hide

- in your code setup the controller as shown below:

		PPPinPadViewController * pinViewController = [[PPPinPadViewController alloc] init];
		pinViewController.delegate = self;
		pinViewController.pinTitle = @"Enter Passcode";	
		pinViewController.errorTitle = @"Passcode is not correct";
		pinViewController.cancelButtonHidden = NO; //default is False
		pinViewController.backgroundImage = [UIImage imageNamed:@"pinViewImage"]; //if you need remove the background set a empty UIImage ([UIImage new]) or set a background color
		pinViewController.backgroundColor = [UIColor darkGrayColor]; //default is a darkGrayColor
		
		[self presentViewController:pinViewController animated:YES completion:NULL];


Credits
======

- Image author [MsLarkina](https://twitter.com/MsLarkina)
- First version [kosyloa](https://github.com/kosyloa)
- Custom configutation [busta117](http://www.santiagobustamante.info)
