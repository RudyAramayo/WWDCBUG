//
//  AppDelegate.h
//  WWDCBUG
//
//  Created by Villela Medina on 2/27/13.
//  Copyright (c) 2013 OrbitusRobotics. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class KlinkMenulet;


@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet WebView *webview;
    IBOutlet KlinkMenulet *klinkMenulet;
    IBOutlet NSWindowController *wwdcWindowController;
}
@property (readwrite, retain) NSTimer *wwdcCheckTimer;
@property (assign) IBOutlet NSWindow *window;

@end
