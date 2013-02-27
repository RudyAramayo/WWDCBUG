//
//  KlinkMenulet.m
//  Klink
//
//  Created by Mezeo on 10/30/12.
//  Copyright (c) 2012 Mezeo. All rights reserved.
//

#import "KlinkMenulet.h"
#import <QuartzCore/QuartzCore.h>


@implementation KlinkMenulet

@synthesize panelController = _panelController;
@synthesize menubarController = _menubarController;


#pragma mark -
#pragma mark Initialization and Status Methods


- (void) awakeFromNib
{
    [self setupStatusItem];
}


- (void) setupStatusItem
{
    self.menubarController = [[MenubarController alloc] init];
}


- (void) setSync_Conflict_Status
{
    [self.menubarController setSync_Conflict_Status];
    [self.panelController setSync_Conflict_Status];
}


- (void) setSync_Disabled_Status
{
    [self.menubarController setSync_Disabled_Status];
    [self.panelController setSync_Disabled_Status];
}


- (void) setSync_Idle_Status
{
    [self.menubarController setSync_Idle_Status];
    [self.panelController setSync_Idle_Status];
}


- (void) setSync_Offline_Status
{
    [self.menubarController setSync_Offline_Status];
    [self.panelController setSync_Offline_Status];
}


- (void) setSync_Stopped_Status
{
    [self.menubarController setSync_Stopped_Status];
    [self.panelController setSync_Stopped_Status];
}


- (void) setSync_Syncing_Status
{
    [self.menubarController setSync_Syncing_Status];
    [self.panelController setSync_Syncing_Status];
}


#pragma mark - IBActions


- (IBAction)togglePanel:(id)sender
{
    NSLog(@"TogglePanel");
    
    self.menubarController.hasActiveIcon = !self.menubarController.hasActiveIcon;
    self.panelController.hasActivePanel = self.menubarController.hasActiveIcon;
}


#pragma mark - Public accessors


- (PanelController *)panelController
{
    if (_panelController == nil) {
        _panelController = [[PanelController alloc] initWithDelegate:self];
        [_panelController addObserver:self forKeyPath:@"hasActivePanel" options:0 context:kContextActivePanel];
    }
    return _panelController;
}


#pragma mark - PanelControllerDelegate


- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller
{
    return self.menubarController.statusItemView;
}


#pragma mark -
#pragma mark KVO Observation Methods


void *kContextActivePanel = &kContextActivePanel;


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kContextActivePanel)
    {
        //DidFinishAnimating
        self.menubarController.hasActiveIcon = self.panelController.hasActivePanel;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark -


- (void)dealloc
{
    [_panelController removeObserver:self forKeyPath:@"hasActivePanel"];
    
    [super dealloc];
}

@end
