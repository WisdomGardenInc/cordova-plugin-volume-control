/********* VolumeControl.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <MediaPlayer/MediaPlayer.h>

#ifdef DEBUG
    #define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define DLog(...)
#endif

@interface VolumeControl : CDVPlugin {
  // Member variables go here.
}

@property (strong, nonatomic) MPVolumeView *volumeView;
@property (strong, nonatomic) UISlider *volumeViewSlider;

- (void)toggleMute:(CDVInvokedUrlCommand*)command;
- (void)isMuted:(CDVInvokedUrlCommand*)command;
- (void)setVolume:(CDVInvokedUrlCommand*)command;
- (void)getVolume:(CDVInvokedUrlCommand*)command;
/*
- (void)hideVolume:(CDVInvokedUrlCommand*)command;
*/
@end

@implementation VolumeControl

- (void)pluginInitialize {
    self.volumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
    [self.volumeView setShowsVolumeSlider:NO];
    [self.volumeView sizeToFit];
    self.volumeView.hidden = NO;
    self.volumeView.alpha = 0.0000001;
    [self.webView.superview addSubview: _volumeView];
    for (UIView *view in [self.volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeViewSlider = (UISlider*)view;
            break;
        }
    }
        
    NSLog(@"VolumeControl pluginInitialize ");
}

- (void)toggleMute:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    DLog(@"toggleMute");
    
    [self.volumeViewSlider setValue:0 animated:YES];
    [self.volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)isMuted:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    DLog(@"isMuted");
    
    BOOL result = false;
    float systemVolume = self.volumeViewSlider.value;
    if (systemVolume < 0.01) {
        result = true;
    }
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:result];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setVolume:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    float volume = [[command argumentAtIndex:0] floatValue];

    DLog(@"setVolume: [%f]", volume);
    
    [self.volumeViewSlider setValue:volume animated:YES];
    [self.volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:true];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getVolume:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    DLog(@"getVolume");
    
    float systemVolume = self.volumeViewSlider.value;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:systemVolume];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

/*
- (void)hideVolume:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    DLog(@"hideVolume");

    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame: CGRectZero];
    volumeView.alpha = 0.01;
    [self.webView.superview addSubview: volumeView];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}*/

@end
