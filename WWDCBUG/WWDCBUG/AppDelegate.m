//
//  AppDelegate.m
//  WWDCBUG
//
//  Created by Villela Medina on 2/27/13.
//  Copyright (c) 2013 OrbitusRobotics. All rights reserved.
//

#import "AppDelegate.h"
#import "KlinkMenulet.h"
#import "LaunchAtLoginController.h"

#import <MailCore/MailCore.h>
#import <CommonCrypto/CommonDigest.h>

NSString* getMD5FromFile(NSString *pathToFile)
{
    unsigned char outputData[CC_MD5_DIGEST_LENGTH];
    
    NSData *inputData = [[NSData alloc] initWithContentsOfFile:pathToFile];
    CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
    [inputData release];
    
    NSMutableString *hash = [[NSMutableString alloc] init];
    
    for (NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", outputData[i]];
    }
    
    NSLog(@"FILE: %@ HASH: %@", pathToFile, hash);
    return hash;
}



@implementation AppDelegate

@synthesize wwdcCheckTimer;

- (void) togglePanel:(id)notification
{
    NSLog(@"Toggle Panel");
    [klinkMenulet togglePanel:self];
}

- (void) wwdcWindow:(id)sender
{
    [wwdcWindowController showWindow:self];
}


- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_window setLevel:NSPopUpMenuWindowLevel];
    // Insert code here to initialize your application
    self.wwdcCheckTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(wwdcCheck) userInfo:nil repeats:YES];
    [webview setFrameLoadDelegate:self];
    
    NSURL *url = [NSURL URLWithString:@"https://developer.apple.com/wwdc/"];
    [webview setMainFrameURL:[url absoluteString]];
    
    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
    [launchController setLaunchAtLogin:YES];
    
    BOOL launch = [launchController launchAtLogin];
    if (launch)
        NSLog(@"App Will Auto-Start");
    else
        NSLog(@"App Will ***NOT*** Auto-Start");
    
    
    [launchController release];

    
    [klinkMenulet setSync_Idle_Status];

    
}



- (void) wwdcCheck
{
    [klinkMenulet setSync_Syncing_Status];
    
    NSLog(@"Checking for WWDC Tickets");
    NSString *saveFileLocation = [@"~/wwdc.html" stringByExpandingTildeInPath];
    
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"https://developer.apple.com/wwdc/"]];
    NSURLResponse* response;
    NSError* error = nil;
    
    //Capturing server response
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    if (!result)
    {
        NSAlert *testAlert = [NSAlert alertWithMessageText:@"STAY ONLINE!"
                                             defaultButton:@"OK!"
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@"WWDC! Don't go offline... we need to snipe these fools!"];
        
        // use the popup's selection's tag to determine which alert style we want
        [testAlert setAlertStyle:NSWarningAlertStyle];
        
        NSImage* image = [NSImage imageNamed:@"WWDC2012.jpg"];
        [testAlert setIcon: image];
        
        [testAlert setDelegate:(id<NSAlertDelegate>)self];	// this allows "alertShowHelp" to be called when the user clicks the help button
        
        NSInteger result = [testAlert runModal];
        [self handleResult:testAlert withResult:result];
        return;
    }
    [result writeToFile:saveFileLocation atomically:YES];
    
    
    if ([getMD5FromFile(saveFileLocation) isEqualToString:@"f89f6b4e18a98eca5e3cf984dea9ad93"])
    {
        NSLog(@"No changes...");
    }
    else
    {
        NSLog(@"SOUND THE ALARM!!! YOU MUST BUY YOUR TICKET NOW!");
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(){
            [self soundTheAlarm];
        });

        
        NSAlert *testAlert = [NSAlert alertWithMessageText:@"BUY YOUR TICKETS NOW!"
                                             defaultButton:@"HOLY SHIT!"
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@"WWDC!"];
        
        // use the popup's selection's tag to determine which alert style we want
        [testAlert setAlertStyle:NSWarningAlertStyle];
        
        NSImage* image = [NSImage imageNamed:@"WWDC2012.jpg"];
        [testAlert setIcon: image];
        
        [testAlert setDelegate:(id<NSAlertDelegate>)self];	// this allows "alertShowHelp" to be called when the user clicks the help button
        
        NSInteger result = [testAlert runModal];
        [self handleResult:testAlert withResult:result];
        

    }

    int64_t delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [klinkMenulet setSync_Idle_Status];
    });

}


- (void) soundTheAlarm
{
    CTCoreMessage *msg = [[CTCoreMessage alloc] init];
    CTCoreAddress *toAddress = [CTCoreAddress addressWithName:@"Rudy"
                                                        email:@"rudy@klinkcdc.com"];
    [msg setTo:[NSSet setWithObject:toAddress]];
    [msg setBody:@"BUY YOUR FUCKING WWDC TICKET T-T-TODAY JUNIOR!"];
    [msg setSubject:@"WWDC TICKETS AVAILABLE!!!"];
    
    NSError *error = nil;
    BOOL success = [CTSMTPConnection sendMessage:msg
                                          server:@"smtp.gmail.com"
                                        username:@"rudy@klinkcdc.com"
                                        password:@"Littlebro2"
                                            port:587
                                  connectionType:CTSMTPConnectionTypeStartTLS
                                         useAuth:YES
                                           error:&error];
    
    if (error)
    {
        NSLog(@"ERROR = %@", [error localizedDescription]);
    }
}

// -------------------------------------------------------------------------------
//	handleResult:withResult
//
//	Used to handle the result for both sheet and modal alert cases.
// -------------------------------------------------------------------------------
-(void)handleResult:(NSAlert *)alert withResult:(NSInteger)result
{
	// report which button was clicked
	switch(result)
	{
		case NSAlertDefaultReturn:
			NSLog(@"result: NSAlertDefaultReturn");
			break;
            
		case NSAlertAlternateReturn:
			NSLog(@"result: NSAlertAlternateReturn");
			break;
            
		case NSAlertOtherReturn:
			NSLog(@"result: NSAlertOtherReturn");
			break;
            
        default:
            break;
	}
	
	// suppression button only exists in 10.5 and later
    if ([alert showsSuppressionButton])
    {
        if ([[[alert suppressionButton] cell] state])
            NSLog(@"suppress alert: YES");
        else
            NSLog(@"suppress alert: NO");
    }
}

@end
