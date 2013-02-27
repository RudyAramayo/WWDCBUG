#define STATUS_ITEM_VIEW_WIDTH 19.0

#pragma mark -

@class StatusItemView;

@interface MenubarController : NSObject {
@private
    StatusItemView *_statusItemView;
}

@property (nonatomic) BOOL hasActiveIcon;
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong, readonly) StatusItemView *statusItemView;


- (id)initStatusView;

- (void) setSync_Conflict_Status;
- (void) setSync_Disabled_Status;
- (void) setSync_Idle_Status;
- (void) setSync_Offline_Status;
- (void) setSync_Stopped_Status;
- (void) setSync_Syncing_Status;

@end
