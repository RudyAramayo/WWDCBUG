#import "BackgroundView.h"
#import "StatusItemView.h"

@class PanelController;

@protocol PanelControllerDelegate <NSObject>

@optional

- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller;

@end

#pragma mark -

@class ATComplexTableViewController;
@class MouseOverButton;


@interface PanelController : NSWindowController <NSWindowDelegate>
{
    BOOL _hasActivePanel;
    __unsafe_unretained BackgroundView *_backgroundView;
    __unsafe_unretained id<PanelControllerDelegate> _delegate;
    
    IBOutlet NSView *klinkMenuView;
    
    
    BOOL isSyncing_ShowPanel;
    BOOL isNetUnReachable_ShowPanel;
    
    IBOutlet MouseOverButton *openKlink_Button;
    IBOutlet MouseOverButton *klinkForWeb_Button;
    IBOutlet MouseOverButton *macSettings_Button;
    IBOutlet MouseOverButton *accountSettings_Button;
    
    IBOutlet NSProgressIndicator *totalUsageProgressIndicator;
    IBOutlet NSTextField *totalUsageTextField;
    
    IBOutlet NSButton *pauseSyncButton;
}
@property (readwrite, assign) BOOL isSyncing_ShowPanel;
@property (readwrite, assign) BOOL isNetUnReachable_ShowPanel;


@property (readwrite, assign) NSView *klinkMenuView;


@property (nonatomic, unsafe_unretained) IBOutlet BackgroundView *backgroundView;

@property (nonatomic) BOOL hasActivePanel;
@property (nonatomic, unsafe_unretained, readonly) id<PanelControllerDelegate> delegate;

- (id)initWithDelegate:(id<PanelControllerDelegate>)delegate;

- (void)openPanel;
- (void)closePanel;

- (IBAction)toggleSync:(id)sender;

- (void) setPanelHeight:(CGFloat) height;

- (IBAction) open_WWDC_Window:(id)sender;


@end
