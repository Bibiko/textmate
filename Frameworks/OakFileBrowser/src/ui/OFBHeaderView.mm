#import "OFBHeaderView.h"
#import <OakAppKit/OakAppKit.h>
#import <OakAppKit/OakUIConstructionFunctions.h>
#import <Preferences/Keys.h>

static NSButton* OakCreateImageButton (NSString* imageName)
{
	NSButton* res = [NSButton new];

	[[res cell] setBackgroundStyle:NSBackgroundStyleRaised];
	[res setButtonType:NSMomentaryChangeButton];
	[res setBezelStyle:NSRecessedBezelStyle];
	[res setBordered:NO];

	NSImage* image = [[NSImage imageNamed:imageName] copy];
	[res setImage:image];
	[res setImagePosition:NSImageOnly];

	return res;
}

static NSPopUpButton* OakCreateFolderPopUpButton ()
{
	NSPopUpButton* res = [[NSPopUpButton alloc] initWithFrame:NSZeroRect pullsDown:YES];
	[[res cell] setBackgroundStyle:NSBackgroundStyleLight];
	[res setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
	[res setContentHuggingPriority:NSLayoutPriorityFittingSizeCompression forOrientation:NSLayoutConstraintOrientationHorizontal];
	[res setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationVertical];
	[res setBordered:NO];
	return res;
}

@interface OFBHeaderView ()
@property (nonatomic) BOOL matchTabBarHeight;
@end

@implementation OFBHeaderView
- (id)initWithFrame:(NSRect)aRect
{
	if(self = [super initWithFrame:aRect])
	{
		[self setupHeaderBackground];

		self.folderPopUpButton       = OakCreateFolderPopUpButton();
		self.goBackButton            = OakCreateImageButton(NSImageNameGoLeftTemplate);
		self.goBackButton.toolTip    = @"Go Back";
		self.goForwardButton         = OakCreateImageButton(NSImageNameGoRightTemplate);
		self.goForwardButton.toolTip = @"Go Forward";

		[self.folderPopUpButton.cell accessibilitySetOverrideValue:@"Folder" forAttribute:NSAccessibilityDescriptionAttribute];
		[self.goBackButton.cell accessibilitySetOverrideValue:self.goBackButton.toolTip forAttribute:NSAccessibilityDescriptionAttribute];
		[self.goForwardButton.cell accessibilitySetOverrideValue:self.goForwardButton.toolTip forAttribute:NSAccessibilityDescriptionAttribute];

		NSDictionary* views = @{
			@"folder"   : self.folderPopUpButton,
			@"divider"  : OakCreateDividerImageView(),
			@"back"     : self.goBackButton,
			@"forward"  : self.goForwardButton,
		};

		for(NSView* view in [views allValues])
		{
			[view setTranslatesAutoresizingMaskIntoConstraints:NO];
			[self addSubview:view];
		}

		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-3)-[folder(>=75)]-(3)-[divider]-(2)-[back(==22)]-(2)-[forward(==back)]-(3)-|" options:0 metrics:nil views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[folder(==divider,==back,==forward)]|"                                          options:0 metrics:nil views:views]];
	}
	return self;
}

- (NSSize)intrinsicContentSize
{
	return NSMakeSize(NSViewNoInstrinsicMetric, 24);
}
@end
