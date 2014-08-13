PinPad
======

View like iOS7 Lock screen

Dynamic count of input numbers and custom configuration. Works on iOS 5+.

How to use
======

- Add the folder **PinPad** in your project folder

- Add <code>#import "PPPinPadViewController.h"</code> in your viewController(in the .h file)

- Implement the protocol <code>PinPadPasswordProtocol</code> in your class

- This protocol has simple methods to control the pin pad

		- (BOOL)checkPin:(NSString *)pin; 	//required, validation with your configured code
		- (NSInteger)pinLength; 			//required, works like a data source of pin length
		- (void)pinPadSuccessPin;			//optional, when the user set a correct pin
		- (void)pinPadWillHide;				//optional, before the pin pad hide
		- (void)pinPadDidHide;				//optional, after pin pad hide
		- (void)userPassCode:(NSString *)newPassCode; //optional, set new user passcode


- In your code, setup the controller as shown below:

		PPPinPadViewController * pinViewController = [[PPPinPadViewController alloc] init];
		pinViewController.delegate = self;
		pinViewController.pinTitle = @"Enter Passcode";	    pinViewController.isSettingPinCode = YES; // YES-input new passcode and confirmation 
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
- User can set his or her passcode [ihomam](https://github.com/ihomam)


License
======
**PinPad** is provided under the MIT license.
