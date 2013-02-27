#import "MenubarController.h"
#import "StatusItemView.h"

@implementation MenubarController

@synthesize statusItemView = _statusItemView;
@synthesize statusItem;


#pragma mark -


- (id)init
{
    self = [super init];
    if (self != nil)
    {
        // Install status item into the menu bar
        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
        _statusItemView = [[StatusItemView alloc] initWithStatusItem:statusItem];
        _statusItemView.image = [NSImage imageNamed:@"Status_Green"];
        _statusItemView.alternateImage = [NSImage imageNamed:@"StatusHighlighted"];
        _statusItemView.action = @selector(togglePanel:);
     
    }
    return self;
}


#pragma mark -
#pragma mark SyncStatus Methods


- (void) setSync_Conflict_Status
{
    _statusItemView.image = [NSImage imageNamed:@"Status_Red"];
    _statusItemView.alternateImage = [NSImage imageNamed:@"StatusHighlighted"];
    _statusItemView.animating = NO;
}


- (void) setSync_Disabled_Status
{
    _statusItemView.image = [NSImage imageNamed:@"Status_Red"];
    _statusItemView.alternateImage = [NSImage imageNamed:@"StatusHighlighted"];
    _statusItemView.animating = NO;
}


- (void) setSync_Idle_Status
{
    _statusItemView.image = [NSImage imageNamed:@"Status_Green"];
    _statusItemView.alternateImage = [NSImage imageNamed:@"StatusHighlighted"];
    _statusItemView.animating = NO;
    _statusItemView.angle = 0;
}


- (void) setSync_Offline_Status
{
    _statusItemView.image = [NSImage imageNamed:@"Status_Grey"];
    _statusItemView.alternateImage = [NSImage imageNamed:@"StatusHighlighted"];
    _statusItemView.animating = NO;
}


- (void) setSync_Stopped_Status
{
    _statusItemView.image = [NSImage imageNamed:@"Status_Yellow"];
    _statusItemView.alternateImage = [NSImage imageNamed:@"StatusHighlighted"];
    _statusItemView.animating = NO;
}


- (void) setSync_Syncing_Status
{
    _statusItemView.image = [NSImage imageNamed:@"Status_Green"];
    _statusItemView.alternateImage = [NSImage imageNamed:@"StatusHighlighted"];
    _statusItemView.animating = YES;
    _statusItemView.angle = 0;    
}


#pragma mark -
#pragma mark Public accessors


- (NSStatusItem *)statusItem
{
    return self.statusItemView.statusItem;
}

#pragma mark -

- (BOOL)hasActiveIcon
{
    return self.statusItemView.isHighlighted;
}

- (void)setHasActiveIcon:(BOOL)flag
{
    self.statusItemView.isHighlighted = flag;
}


- (void)dealloc
{
    [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
}

@end
