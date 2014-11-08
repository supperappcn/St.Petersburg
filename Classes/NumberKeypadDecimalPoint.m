//
//  DecimalPointButton.m
//  iDeal
//
//  Created by David Casserly on 13/03/2010.
//  Copyright 2010 devedup.com. All rights reserved.
//

#import "NumberKeypadDecimalPoint.h"

static UIImage *backgroundImageDepressed;

/**
 *
 */
@implementation DecimalPointButton

+ (void) initialize {
	backgroundImageDepressed = [[UIImage imageNamed:@"decimalKeyDownBackground.png"] retain];
}

- (id) init {
	if(self = [super initWithFrame:CGRectMake(0, 480, 105, 53)]) { //Initially hidden
		//[super adjustsImageWhenDisabled:NO];
		self.titleLabel.font = [UIFont systemFontOfSize:35];
		[self setTitleColor:[UIColor colorWithRed:77.0f/255.0f green:84.0f/255.0f blue:98.0f/255.0f alpha:1.0] forState:UIControlStateNormal];	
		[self setBackgroundImage:backgroundImageDepressed forState:UIControlStateHighlighted];
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[self setTitle:@"." forState:UIControlStateNormal];
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	//Bring in the button at same speed as keyboard
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2]; //we lose 0.1 seconds when we display it with timer
	self.frame = CGRectMake(0, 427*DeviceHeight/480, 105, 53);
	[UIView commitAnimations];
}

+ (DecimalPointButton *) decimalPointButton {
	DecimalPointButton *button = [[DecimalPointButton alloc] init];
	return [button autorelease];
}

@end

/**
 *
 */
@implementation NumberKeypadDecimalPoint

static NumberKeypadDecimalPoint *keypad1;

//Retain
@synthesize decimalPointButton;
@synthesize showDecimalPointTimer;

//Assign
@synthesize currentTextField;

#pragma mark -
#pragma mark Release

- (void) dealloc {
	[decimalPointButton release];
	[showDecimalPointTimer release];
	[super dealloc];
}

//Private Method
- (void) addButtonToKeyboard:(DecimalPointButton *)button {	
	//Add a button to the top, above all windows
	NSArray *allWindows = [[UIApplication sharedApplication] windows];
	int topWindow = [allWindows count] - 1;
	UIWindow *keyboardWindow = [allWindows objectAtIndex:topWindow];
	[keyboardWindow addSubview:button];	
}

//Private Method //This is executed after a delay from showKeypadForTextField
- (void) addTheDecimalPointToKeyboard
{
    
	[keypad1 addButtonToKeyboard:keypad1.decimalPointButton];
}

//Private Method
- (void) decimalPointPressed {
	//Check to see if there is a . already
	NSString *currentText = currentTextField.text;
	if ([currentText rangeOfString:@"." options:NSBackwardsSearch].length == 0) {
		currentTextField.text = [currentTextField.text stringByAppendingString:@"."];
	}else {
		//alreay has a decimal point
	}
}

/*
 Show the keyboard
 */
+ (NumberKeypadDecimalPoint *) keypadForTextField:(UITextField *)textField {
	if (!keypad1) {
		keypad1 = [[NumberKeypadDecimalPoint alloc] init];
		keypad1.decimalPointButton = [DecimalPointButton decimalPointButton];
		[keypad1.decimalPointButton addTarget:keypad1 action:@selector(decimalPointPressed) forControlEvents:UIControlEventTouchUpInside];
	}
	keypad1.currentTextField = textField;
	keypad1.showDecimalPointTimer = [NSTimer timerWithTimeInterval:0.1 target:keypad1 selector:@selector(addTheDecimalPointToKeyboard) userInfo:nil repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:keypad1.showDecimalPointTimer forMode:NSDefaultRunLoopMode];
	return keypad1;
}

/*
 Hide the keyboard
 */
- (void) removeButtonFromKeyboard {
	[self.showDecimalPointTimer invalidate]; //stop any timers still wanting to show the button
	[self.decimalPointButton removeFromSuperview];
}


@end

