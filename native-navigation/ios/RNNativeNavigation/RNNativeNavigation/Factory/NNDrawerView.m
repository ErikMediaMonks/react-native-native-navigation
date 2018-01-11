//
// Copyright (c) 2017 MediaMonks. All rights reserved.
//

#import "NNDrawerView.h"
#import "NNDrawerNode.h"

@interface NNDrawerView ()

@property (nonatomic, strong) NNDrawerNode *drawerNode;

@end

@implementation NNDrawerView

- (instancetype)initWithNode:(NNDrawerNode *)node
{
	NNDrawerNode *drawerNode = node;
	UIViewController <NNView> *leftController = [drawerNode.leftNode generate];
	UIViewController <NNView> *centerController = [drawerNode.centerNode generate];
	UIViewController <NNView> *rightController = [drawerNode.rightNode generate];

	if (self = [super initWithCenterViewController:centerController
					  leftDrawerViewController:leftController
					  rightDrawerViewController:rightController]) {
		self.drawerNode = drawerNode;
		self.title = node.title;
		self.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
		self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;

		if (self.openSide != drawerNode.side) {
			[self openDrawerSide:drawerNode.side animated:NO completion:nil];
		}

		__weak NNDrawerView *weakSelf = self;
		[self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible)
		{
			weakSelf.drawerNode.side = drawerSide;
		}];
	}
	return self;
}

- (__kindof id <NNNode>)node
{
	return self.drawerNode;
}

- (UIViewController <NNView> *)viewForPath:(NSString *)path
{
	UIViewController <NNView> *foundController;
	UIViewController <NNView> *leftController = (UIViewController <NNView> *)self.leftDrawerViewController;
	UIViewController <NNView> *centerController = (UIViewController <NNView> *)self.centerViewController;
	UIViewController <NNView> *rightController = (UIViewController <NNView> *)self.rightDrawerViewController;

    if([path rangeOfString:self.drawerNode.screenID].location == 0) {
        NSString *newPath = [path substringFromIndex:self.drawerNode.screenID.length + 1];
        NSArray *splittedArray = [newPath componentsSeparatedByString:@"/"];
        NSString *side = splittedArray.firstObject;

        NSMutableDictionary *sideMap = @{}.mutableCopy;
        if(leftController) sideMap[@"left"] = leftController;
        if(centerController) sideMap[@"center"] = centerController;
        if(rightController) sideMap[@"right"] = rightController;

        foundController = sideMap[side];
        if(splittedArray.count > 1){
            return [foundController viewForPath:path];
        }

        return foundController;
    }

    return nil;
}

@end
