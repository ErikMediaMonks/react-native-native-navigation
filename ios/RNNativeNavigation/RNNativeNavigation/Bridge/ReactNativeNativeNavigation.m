//
// Copyright (c) 2017 MediaMonks. All rights reserved.
//

#import <React/RCTUtils.h>
#import "NNBaseNode.h"
#import "RNNNState.h"
#import "NNNodeHelper.h"
#import "NNStackNode.h"
#import "NNView.h"
#import "ReactNativeNativeNavigation.h"

#if RCT_DEBUG
#import <React/RCTDevMenu.h>
#import <React/RCTKeyCommands.h>
#endif

static NSString *const kRNNN = @"RNNN";


@implementation ReactNativeNativeNavigation
RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

- (instancetype)init
{
    if (self = [super init]) {
        [RNNNState sharedInstance];
    }
    return self;
}

+ (void)addExternalNodes:(NSArray<Class<NNNode>> *)nodes
{
    NSMutableArray *nodesToLoad = [NSMutableArray new];

    for (Class<NNNode> cls in nodes) {
        if ([cls conformsToProtocol:@protocol(NNNode)]) {
            [nodesToLoad addObject:cls];
        }
    }
    [NNNodeHelper.sharedInstance addExternalNodes:nodesToLoad];
}

- (NSDictionary<NSString *, id> *)constantsToExport
{
    return [NNNodeHelper.sharedInstance constantsToExport];
}

// clang-format off
RCT_EXPORT_METHOD(
    onStart: (RCTResponseSenderBlock)callback
)
{
    // clang-format on
    NSDictionary *state = [RNNNState sharedInstance].state;
    if (state == nil) {
        printf("%s %s\n", kRNNN.UTF8String, "First load");
        callback(@[]);
    } else {
        printf("%s %s\n", kRNNN.UTF8String, "Reload");
        callback(@[ state ]);
    }
}

// clang-format off
RCT_EXPORT_METHOD(
    setSiteMap: (NSDictionary *)map
    resolver: (RCTPromiseResolveBlock)resolve
    rejecter: (RCTPromiseRejectBlock)reject
)
{
    // clang-format on
    dispatch_async(dispatch_get_main_queue(), ^{
        [RNNNState sharedInstance].state = map;

        NNStackNode *nodeObject = [NNNodeHelper.sharedInstance nodeFromMap:map bridge:self.bridge];
        UIViewController <NNView> *viewController = [nodeObject generate];
        RNNNState.sharedInstance.viewController = viewController;
        UIWindow *window = [RNNNState sharedInstance].window;
        window.rootViewController = viewController;
        [window makeKeyAndVisible];
    });

    resolve(@[]);
}

// clang-format off
RCT_EXPORT_METHOD(
    callMethodOnNode: (NSString *)navigator
    methodName: (NSString *)methodName
    arguments: (NSDictionary *)arguments
    responseCallback: (RCTResponseSenderBlock)callback
)
{
    // clang-format on
    UIViewController<NNView> *rootController = RNNNState.sharedInstance.viewController;
    __kindof UIViewController<NNView> *findController = [rootController viewForPath:navigator];
    if (!findController) return;

    if ([findController respondsToSelector:@selector(callMethodWithName:arguments:callback:)]) {
        [findController callMethodWithName:methodName arguments:arguments callback:callback];
    }
}

// clang-format off
RCT_EXPORT_METHOD(
    resetApplication
)
{
    // clang-format on
    [RNNNState sharedInstance].window.rootViewController = nil;
    [RNNNState sharedInstance].state = nil;
    [_bridge reload];
}

- (void)setBridge:(RCTBridge *)bridge
{
    _bridge = bridge;

    [self addDeveloperOptions];
}

- (void)addDeveloperOptions
{
#if RCT_DEBUG
    __weak ReactNativeNativeNavigation *weakSelf = self;
    [_bridge.devMenu addItem:[RCTDevMenuItem buttonItemWithTitle:@"Reset navigation" handler:^{
        [weakSelf resetApplication];
    }]];

    [[RCTKeyCommands sharedInstance]
        registerKeyCommandWithInput:@"n"
                      modifierFlags:UIKeyModifierCommand
                             action:^(UIKeyCommand *command) {
                                 [weakSelf resetApplication];
                             }];
#endif
}

- (void)dealloc
{
    UIViewController<NNView> *viewController = (UIViewController<NNView> *)[RNNNState sharedInstance].window.rootViewController;
    [RNNNState sharedInstance].state = [viewController node].data;
}

@end
