#import "PanelController.h"
#import "BackgroundView.h"
#import "StatusItemView.h"
#import "MenubarController.h"
#import "AppDelegate.h"

#define OPEN_DURATION .23

#define CLOSE_DURATION .1

#define SEARCH_INSET 17

#define POPUP_HEIGHT 205
#define PANEL_WIDTH 330
#define MENU_ANIMATION_DURATION .1

#pragma mark -

@implementation PanelController


@synthesize isSyncing_ShowPanel;
@synthesize isNetUnReachable_ShowPanel;

@synthesize klinkMenuView;



@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;

#pragma mark -

- (id)initWithDelegate:(id<PanelControllerDelegate>)delegate
{
    self = [super initWithWindowNibName:@"Panel"];
    if (self != nil)
    {
        _delegate = delegate;
    }
    return self;
}


#pragma mark -

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self layoutPanel];
    
}


- (void) layoutPanel
{
    // Make a fully skinned panel
    NSPanel *panel = (id)[self window];
    [panel setAcceptsMouseMovedEvents:YES];
    [panel setLevel:NSPopUpMenuWindowLevel];
    [panel setOpaque:NO];
    [panel setBackgroundColor:[NSColor clearColor]];
    
    // Resize panel
    NSRect panelRect = [[self window] frame];
    
    
    int messagesBodyViewHeight = 0.0;
    
    
    int targetHeight = 159;
    //if (isSyncing_ShowPanel)
    //    targetHeight += 75;
    [self setPanelHeight:targetHeight];
 
}


- (void) setPanelHeight:(CGFloat) height
{
    // Make a fully skinned panel
    NSPanel *panel = (id)[self window];
    [panel setAcceptsMouseMovedEvents:YES];
    [panel setLevel:NSPopUpMenuWindowLevel];
    [panel setOpaque:NO];
    [panel setBackgroundColor:[NSColor clearColor]];
    
    // Resize panel
    NSRect panelRect = [[self window] frame];
    

    panelRect = [[self window] frame];

    _backgroundView.frame = CGRectMake(0, 0, 330, height);
    panelRect.size.height = _backgroundView.frame.size.height;
    [[self window] setFrame:panelRect display:YES];
}


- (IBAction)toggleSync:(id)sender
{
    NSLog(@"ToggleSync");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleSync" object:nil];
}
                      

#pragma mark - Public accessors


- (BOOL)hasActivePanel
{
    return _hasActivePanel;
}


- (void)setHasActivePanel:(BOOL)flag
{
    if (_hasActivePanel != flag)
    {
        _hasActivePanel = flag;
        
        if (_hasActivePanel)
        {
            [self openPanel];
        }
        else
        {
            [self closePanel];
        }
    }
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification
{
    self.hasActivePanel = NO;
}

- (void)windowDidResignKey:(NSNotification *)notification;
{
    if ([[self window] isVisible])
    {
        self.hasActivePanel = NO;
    }
}

- (void)windowDidResize:(NSNotification *)notification
{
    NSWindow *panel = [self window];
    NSRect statusRect = [self statusRectForWindow:panel];
    NSRect panelRect = [panel frame];
    
    CGFloat statusX = roundf(NSMidX(statusRect));
    CGFloat panelX = statusX - NSMinX(panelRect);
    
    self.backgroundView.arrowX = panelX;

}

#pragma mark - Keyboard

- (void)cancelOperation:(id)sender
{
    self.hasActivePanel = NO;
}


#pragma mark - Public methods

- (NSRect)statusRectForWindow:(NSWindow *)window
{
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect statusRect = NSZeroRect;
    
    StatusItemView *statusItemView = nil;
    if ([self.delegate respondsToSelector:@selector(statusItemViewForPanelController:)])
    {
        statusItemView = [self.delegate statusItemViewForPanelController:self];
    }
    
    if (statusItemView)
    {
        statusRect = statusItemView.globalRect;
        statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect);
    }
    else
    {
        statusRect.size = NSMakeSize(STATUS_ITEM_VIEW_WIDTH, [[NSStatusBar systemStatusBar] thickness]);
        statusRect.origin.x = roundf((NSWidth(screenRect) - NSWidth(statusRect)) / 2);
        statusRect.origin.y = NSHeight(screenRect) - NSHeight(statusRect) * 2;
    }
    return statusRect;
}

- (void)openPanel
{
    NSWindow *panel = [self window];
    
    [openKlink_Button resetButton];
    [klinkForWeb_Button resetButton];
    [macSettings_Button resetButton];
    [accountSettings_Button resetButton];
    
    
    
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect statusRect = [self statusRectForWindow:panel];

    NSRect panelRect = [panel frame];
    panelRect.size.width = PANEL_WIDTH;
    panelRect.origin.x = roundf(NSMidX(statusRect) - STATUS_ITEM_VIEW_WIDTH/2.0);// - NSWidth(panelRect) / 2);
    panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect);
    
    if (NSMaxX(panelRect) > (NSMaxX(screenRect) - ARROW_HEIGHT))
        panelRect.origin.x -= NSMaxX(panelRect) - (NSMaxX(screenRect) - ARROW_HEIGHT);
    
    [NSApp activateIgnoringOtherApps:NO];
    [panel setAlphaValue:0];
    [panel setFrame:statusRect display:YES];
    [panel makeKeyAndOrderFront:nil];
    
    NSTimeInterval openDuration = OPEN_DURATION;
    
    NSEvent *currentEvent = [NSApp currentEvent];
    if ([currentEvent type] == NSLeftMouseDown)
    {
        NSUInteger clearFlags = ([currentEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask);
        BOOL shiftPressed = (clearFlags == NSShiftKeyMask);
        BOOL shiftOptionPressed = (clearFlags == (NSShiftKeyMask | NSAlternateKeyMask));
        if (shiftPressed || shiftOptionPressed)
        {
            openDuration *= 10;
            
            if (shiftOptionPressed)
                NSLog(@"Icon is at %@\n\tMenu is on screen %@\n\tWill be animated to %@",
                      NSStringFromRect(statusRect), NSStringFromRect(screenRect), NSStringFromRect(panelRect));
        }
    }
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:openDuration];
    [[panel animator] setFrame:panelRect display:YES];
    [[panel animator] setAlphaValue:1];
    [NSAnimationContext endGrouping];
    
    
}



- (void)adjustPanelHeight
{
    NSWindow *panel = [self window];
    
    [openKlink_Button resetButton];
    [klinkForWeb_Button resetButton];
    [macSettings_Button resetButton];
    [accountSettings_Button resetButton];
    
    
    
    NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
    NSRect statusRect = [self statusRectForWindow:panel];
    
    NSRect panelRect = [panel frame];
    panelRect.size.width = PANEL_WIDTH;
    panelRect.origin.x = roundf(NSMidX(statusRect) - STATUS_ITEM_VIEW_WIDTH/2.0);// - NSWidth(panelRect) / 2);
    panelRect.origin.y = NSMaxY(statusRect) - NSHeight(panelRect);
    
    if (NSMaxX(panelRect) > (NSMaxX(screenRect) - ARROW_HEIGHT))
        panelRect.origin.x -= NSMaxX(panelRect) - (NSMaxX(screenRect) - ARROW_HEIGHT);
    
    [NSApp activateIgnoringOtherApps:NO];
    //[panel setAlphaValue:0];
    //[panel setFrame:statusRect display:YES];
    //[panel makeKeyAndOrderFront:nil];
    
    NSTimeInterval openDuration = OPEN_DURATION;
    
    NSEvent *currentEvent = [NSApp currentEvent];
    if ([currentEvent type] == NSLeftMouseDown)
    {
        NSUInteger clearFlags = ([currentEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask);
        BOOL shiftPressed = (clearFlags == NSShiftKeyMask);
        BOOL shiftOptionPressed = (clearFlags == (NSShiftKeyMask | NSAlternateKeyMask));
        if (shiftPressed || shiftOptionPressed)
        {
            openDuration *= 10;
            
            if (shiftOptionPressed)
                NSLog(@"Icon is at %@\n\tMenu is on screen %@\n\tWill be animated to %@",
                      NSStringFromRect(statusRect), NSStringFromRect(screenRect), NSStringFromRect(panelRect));
        }
    }
    
    [NSAnimationContext beginGrouping];
    //[[NSAnimationContext currentContext] setDuration:openDuration];
    [[panel animator] setFrame:panelRect display:YES];
    [[panel animator] setAlphaValue:1];
    [NSAnimationContext endGrouping];

    
}

- (void)closePanel
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:CLOSE_DURATION];
    [[[self window] animator] setAlphaValue:0];
    [NSAnimationContext endGrouping];
    
    dispatch_after(dispatch_walltime(NULL, NSEC_PER_SEC * CLOSE_DURATION * 2), dispatch_get_main_queue(), ^{
        
        [self.window orderOut:nil];
    });
}


- (IBAction) open_WWDC_Window:(id)sender
{
    [(AppDelegate *)[[NSApplication sharedApplication] delegate] wwdcWindow:self];
}


#pragma mark -
#pragma mark Sync Status


- (void) setSync_Conflict_Status
{
    pauseSyncButton.title = @"Sync";
    isSyncing_ShowPanel = NO;
    isNetUnReachable_ShowPanel = NO;
    [self layoutPanel];
    [self adjustPanelHeight];
}


- (void) setSync_Disabled_Status
{
    pauseSyncButton.title = @"Sync";
    isSyncing_ShowPanel = YES;
    isNetUnReachable_ShowPanel = NO;
    [self layoutPanel];
    [self adjustPanelHeight];    
}


- (void) setSync_Idle_Status
{
    pauseSyncButton.title = @"Sync";    
    isSyncing_ShowPanel = NO;
    isNetUnReachable_ShowPanel = NO;
    [self layoutPanel];
    [self adjustPanelHeight];
}


- (void) setSync_Offline_Status
{
    pauseSyncButton.title = @"Sync";
    isSyncing_ShowPanel = NO;
    isNetUnReachable_ShowPanel = NO;
    [self layoutPanel];
    [self adjustPanelHeight];
}


- (void) setSync_Stopped_Status
{
    pauseSyncButton.title = @"Sync";
    isSyncing_ShowPanel = YES;
    isNetUnReachable_ShowPanel = NO;
    [self layoutPanel];
    [self adjustPanelHeight];
}


- (void) setSync_Syncing_Status
{
    pauseSyncButton.title = @"Pause";
    isSyncing_ShowPanel = YES;
    isNetUnReachable_ShowPanel = NO;
    [self layoutPanel];
    [self adjustPanelHeight];    
}


@end
