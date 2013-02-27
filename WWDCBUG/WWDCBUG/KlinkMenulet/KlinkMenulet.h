//
//  KlinkMenulet.h
//  Klink
//
//  Created by Mezeo on 10/30/12.
//  Copyright (c) 2012 Mezeo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenubarController.h"
#import "PanelController.h"
#import <Python/Python.h>


@interface KlinkMenulet : NSObject <PanelControllerDelegate>
{

}

@property (nonatomic, strong) MenubarController *menubarController;
@property (nonatomic, strong, readonly) PanelController *panelController;

+ (KlinkMenulet *)sharedMenulet;
- (NSString *) doesItWork;

- (void) setupStatusItem;

- (void) setSync_Conflict_Status;
- (void) setSync_Disabled_Status;
- (void) setSync_Idle_Status;
- (void) setSync_Offline_Status;
- (void) setSync_Stopped_Status;
- (void) setSync_Syncing_Status;

- (IBAction)togglePanel:(id)sender;


@end
