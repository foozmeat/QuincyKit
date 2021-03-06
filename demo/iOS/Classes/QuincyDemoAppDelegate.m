/*
 * Author: Andreas Linde <mail@andreaslinde.de>
 *         Kent Sutherland
 *
 * Copyright (c) 2009-2011 Andreas Linde & Kent Sutherland.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

#import "QuincyDemoAppDelegate.h"
#import "QuincyDemoViewController.h"

@implementation QuincyDemoAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	_application = application;
	
	// Override point for customization after app launch    
	[window addSubview:viewController.view];
	[window makeKeyAndVisible];
  
    // setSubmissionURL for self hosted Example: http://yourserver.com/crash_v200.php
    // setAppIdentifier for HockeyApp Example: 6463991af4a2da3f9cb320533c83b156
    //    [[BWQuincyManager sharedQuincyManager] setSubmissionURL:@"http://yourserver.com/crash_v200.php"];
    //    [[BWQuincyManager sharedQuincyManager] setAppIdentifier:@"6463991af4a2da3f9cb320533c83b156"];

	[[BWQuincyManager sharedQuincyManager] setFeedbackActivated:YES];
  [[BWQuincyManager sharedQuincyManager] setDelegate:self];
}


- (void)dealloc {
	[viewController release];
	[window release];
	[super dealloc];
}


#pragma mark BWQuincyManagerDelegate

-(void)connectionOpened {
	_application.networkActivityIndicatorVisible = YES;
}


-(void)connectionClosed {
	_application.networkActivityIndicatorVisible = NO;
}

- (void)askForCrashInfo:(NSString*)messageBody
{
		// Show the email compose sheet
	MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc] init];
	mailer.mailComposeDelegate = self;
	mailer.modalPresentationStyle = UIModalPresentationFormSheet;
	
	[mailer setSubject:@"Demo crash info"];
	[mailer setToRecipients:[NSArray arrayWithObject:@"demo@example.com"]];
	[mailer setMessageBody:messageBody isHTML:NO];
	
	[viewController presentModalViewController:mailer animated:YES];
	[mailer release];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	if ( result == MFMailComposeResultFailed )
	{
			// XXX - show alert?
	}
	
	[controller dismissModalViewControllerAnimated:YES];
}


@end