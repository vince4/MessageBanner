/**
 * @file   MessageBanneviewr.m
 * @Author Thibault Carpentier
 * @date   2014
 * @brief  MBLMessageBannerView popup flat styled view.
 *
 * MBLMessageBannerView a customisable popupview
 */

#import "MBLMessageBannerView.h"
#import "MBLMessageBanner.h"
#import "HexColors.h"
#import "FXBlurView.h"

/**
 The default design file
 */
static NSString *defaultDesignFile = @"MessageBannerDesign.json";

/**
 The label of the error type message banner configuration
 */
#define ERROR_JSON_LABEL                    @"Error"
/**
 The label of the warning type message banner configuration
 */
#define WARNING_JSON_LABEL                  @"Warning"
/**
 The label of the message type message banner configuration
 */
#define MESSAGE_JSON_LABEL                  @"Message"
/**
 The label of the success type message banner configuration
 */
#define SUCCESS_JSON_LABEL                  @"Success"

/**
 The blur radius key in the design configuration file
 */
#define BLUR_RADIUS_KEY                     @"blurRadius"

/**
 The background color key in the design configuration file
 */
#define BACKGROUND_COLOR_KEY                @"backgroundColor"
/**
 The backgorund alpha key in the design configuration file
 */
#define BACKGROUND_ALPHA_KEY                @"backgroundAlpha"
/**
 The  background image key in the design configuration file
 */
#define BACKGROUND_IMAGE_KEY                @"backgroundImageName"

/**
 The  default left image for the type in the design configuration file
 */
#define DEFAULT_TYPE_IMAGE_KEY              @"defaultImageForType"

/**
 The title text size key in the design configuration file
 */
#define TITLE_TEXT_SIZE_KEY                 @"titleTextSize"
/**
 The title text color key in the design configuration file
 */
#define TITLE_TEXT_COLOR_KEY                @"titleTextColor"
/**
 The title text shadow color key in the design configuration file
 */
#define TITLE_TEXT_SHADOW_COLOR_KEY         @"titleTextShadowColor"
/**
 The title text shadow X offset key in the design configuration file
 */
#define TITLE_TEXT_SHADOW_OFFSET_X_KEY      @"titleTextShadowOffsetX"
/**
 The title text shadow Y offset key in the design configuration file
 */
#define TITLE_TEXT_SHADOW_OFFSET_Y_KEY      @"titleTextShadowOffsetY"
/**
 The the title text shadow alpha key in the design configuration file
 */
#define TITLE_TEXT_SHADOW_ALPHA_KEY         @"titleTextShadowAlpha"

/**
 The subtitle text size key in the design configuration file
 */
#define SUBTITLE_TEXT_SIZE_KEY              @"subtitleTextSize"
/**
 The subtitle text color key in the design configuration file
 */
#define SUBTITLE_TEXT_COLOR_KEY             @"subtitleTextColor"
/**
 The subtitle text shadow color key in the design configuration file
 */
#define SUBTITLE_TEXT_SHADOW_COLOR_KEY      @"subtitleTextShadowColor"
/**
 The subtitle text shadow X offset key in the design configuration file
 */
#define SUBTITLE_TEXT_SHADOW_OFFSET_X_KEY   @"subtitleTextShadowOffsetX"
/**
 The subtitle text shadow Y offset key in the design configuration file
 */
#define SUBTITLE_TEXT_SHADOW_OFFSET_Y_KEY   @"subtitleTextShadowOffsetY"
/**
 The subtitle text shadow alpha key in the design configuration file
 */
#define SUBTITLE_TEXT_SHADOW_ALPHA_KEY      @"subtitleTextShadowAlpha"

/**
 The button background color key in the design configuration file
 */
#define BUTTON_BACKGROUND_COLOR_KEY         @"buttonBackgroundColor"
/**
 The button background image key in the design configuration file
 */
#define BUTTON_BACKGROUND_IMAGE_KEY         @"buttonBackgroundImage"
/**
 The button image pattern background key in the design configuration file
 */
#define BUTTON_BACKGROUND_PATTERN_IMAGE_KEY @"buttonBackgroundPatternImage"
/**
 The button background alpha key in the design configuration file
 */
#define BUTTON_BACKGROUND_ALPHA_KEY         @"buttonBackgroundAlpha"

/**
 The button corener radius key in the design configuration file
 */
#define BUTTON_CORNER_RADIUS_KEY            @"buttonCornerRadius"
/**
 The button border color key in the design configuration file
 */
#define BUTTON_BORDER_COLOR_KEY             @"buttonBorderColor"
/**
 The button border alpha key in the design configuration file
 */
#define BUTTON_BORDER_ALPHA_KEY             @"buttonBorderAlpha"
/**
 The button border size key in the design configuration file
 */
#define BUTTON_BORDER_SIZE_KEY              @"buttonBorderSize"

/**
 The button text color key in the design configuration file
 */
#define BUTTON_TEXT_COLOR_KEY               @"buttonTextColor"
/**
 The button text shadow color key in the design configuration file
 */
#define BUTTON_TEXT_SHADOW_COLOR_KEY        @"buttonTextShadowColor"
/**
 The button text shadow X offset key in the design configuration file
 */
#define BUTTON_TEXT_SHADOW_OFFSET_X_KEY     @"buttonTextShadowOffsetX"
/**
 The button text shadow Y offset key in the design configuration file
 */
#define BUTTON_TEXT_SHADOW_OFFSET_Y_KEY     @"buttonTextShadowOffsetY"
/**
 The button text shadow alpha key in the design configuration file
 */
#define BUTTON_TEXT_SHADOW_ALPHA_KEY        @"buttonTextShadowAlpha"

/**
 The default element padding used for positionning
 */
#define ELEMENTS_PADDING                    16.0f

/**
 The animation duration used for setting the blur
 */
#define ANIMATION_DURATION                  0.5

/**
 Undocumented private methods calls for internal use
 */
@interface MBLMessageBanner (MBLMessageBannerView)
    - (void) hideMessageBanner:(MBLMessageBannerView *)messageBanner
                   withGesture:(UIGestureRecognizer *)gesture
                 andCompletion:(void (^)())completion;

    - (BOOL)isViewControllerOrParentViewControllerNavigationController:(MBLMessageBannerView *)message;

    - (BOOL)isViewControllerNavigationController:(MBLMessageBannerView *)message;

    - (BOOL)isNavigationBarVisible:(UINavigationController *)currentNavigationController;

    - (BOOL)isToolBarHidden:(UINavigationController *)currentNavigationController;

@end

/**
 General banner design
 */
static NSMutableDictionary* _messageBannerDesign;

@interface MBLMessageBannerView ()

/**
 The title label view
 */
@property (nonatomic, strong) UILabel*      titleLabel;
/**
 The subtitle label view
 */
@property (nonatomic, strong) UILabel*      subtitleLabel;
/**
 The image view
 */
@property (nonatomic, strong) UIImageView*  imageView;
/**
 The button view
 */
@property (nonatomic, strong) UIButton*     button;
/**
 The blurr view attached to the viewcontroller if activated
 */
@property (nonatomic, strong) FXBlurView*   blurView;
/**
 The message view height used for calculs
 */
@property (nonatomic, readwrite, assign) CGFloat  messageViewHeight;

@end

@implementation MBLMessageBannerView


#pragma mark -
#pragma mark Message Banner Design File Methods

+ (BOOL)addMessageBannerDesignFromFileNamed:(NSString *)file {
    BOOL success = YES;
    NSError* error;
    
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:file];
    NSDictionary* newDesign = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath]
                                                              options:kNilOptions
                                                                error:&error];
    if (error) {
        success = NO;
        @throw ([NSException exceptionWithName:@"Error loading design"
                                        reason:
                 [NSString stringWithFormat:@"Can not load %@.\nError:%@", file, error] userInfo:nil]);
    } else {
        [[MBLMessageBannerView messageBannerDesign] addEntriesFromDictionary:newDesign];
    }
    return success;
}

+ (void)setDefaultDesignFile:(NSString *)fileName
{
    defaultDesignFile = fileName;
}

+ (NSMutableDictionary *)messageBannerDesign {
    if (!_messageBannerDesign) {
        NSError* error;
        NSString *filePath = [[[NSBundle mainBundle] resourcePath]
                              stringByAppendingPathComponent:defaultDesignFile];
        _messageBannerDesign = [[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath]
                                                                options:kNilOptions
                                                                  error:&error] mutableCopy];
        
        if (error) {
            @throw ([NSException exceptionWithName:@"Error loading default design"
                                            reason:
                     [NSString stringWithFormat:@"Can not load %@.\nError:%@", defaultDesignFile, error]
                                          userInfo:nil]);
        }
    }
    return _messageBannerDesign;
}

#pragma mark -
#pragma mark Init and dismiss methods

- (id)initWithTitle:(NSString *)title
           subtitle:(NSString *)subtitle
              image:(UIImage *)image
               type:(MBLMessageBannerType)bannerType
           duration:(CGFloat)duration
   inViewController:(UIViewController *)viewController
           userDissmissedCallback:(void (^)(MBLMessageBannerView* banner))userDissmissedCallback
        buttonTitle:(NSString *)buttonTitle
     userPressedButtonCallback:(void (^)(MBLMessageBannerView* banner))userPressedButtonCallback
         atPosition:(MBLMessageBannerPosition)position
canBeDismissedByUser:(BOOL)dismissingEnabled {
   
    if ((self = [self init])) {
        
        _titleBanner = title;
        _subTitle = subtitle;
        _image = image;
        _bannerType = bannerType;
        _duration = duration;
        _viewController = viewController;
        _userDissmissedCallback = userDissmissedCallback;
        _buttonTitle = buttonTitle;
        _userPressedButtonCallback = userPressedButtonCallback;
        
        _position = position;
        _userDismissEnabled = dismissingEnabled;
        
        self.messageViewHeight = 0.0f;
        _isBannerDisplayed = NO;

        _currentDesign = [[MBLMessageBannerView messageBannerDesign]
                          objectForKey:[self getStyleTypeLabel:self.bannerType]];
        // Adding Default Image from config
        if (_image == nil) {
            _image = [UIImage imageNamed:[_currentDesign objectForKey:DEFAULT_TYPE_IMAGE_KEY]];
        }
        
        // To be declined according to position;
        
        [self addButtonOnBanner:buttonTitle];
        //        Setting up title
        self.titleLabel = [self createMessageTitle];
        [self addSubview:self.titleLabel];
        
        //        Setting up subtitle
        if (self.subTitle) {
            self.subtitleLabel = [self createSubtitleLabel];
            [self addSubview:self.subtitleLabel];
        }
        
        //        Setting up image
        if (self.image) {
            [self addImageOnBanner:self.image];
        }

        // Setting up style
        [self setupStyleWithType:self.bannerType];
        
        //        Adding dismiss gesture
        if (self.userDismissEnabled) {
            [self addDismissMethod];
        }
        
        [self setupViewsAutoLayout];
    }
    
    return self;
}

#pragma mark -
#pragma mark Autolayout methods

-(void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setupViewsAutoLayout {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.subtitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.button setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self setPreservesSuperviewLayoutMargins:YES];
    
    [self setupTitleAutoLayout];
    
    if (self.subTitle) {
        [self setupSubtitleAutoLayout];
    }
    
    if (self.image) {
        [self setupImageAutoLayout];
    }
    
    if (self.buttonTitle && [self.buttonTitle length]) {
        [self setupButtonAutoLayout];
    }
}

#pragma mark -
#pragma mark Dismiss methods

- (void)addDismissMethod {
    // Adding swipe to dismiss if setted
    UISwipeGestureRecognizer *dismissGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(dismissViewWithGesture:)];
    
    switch (self.position) {
        case MBLMessageBannerPositionTop:
            [dismissGesture setDirection:UISwipeGestureRecognizerDirectionUp];;
            break;
        case MBLMessageBannerPositionBottom:
            [dismissGesture setDirection:UISwipeGestureRecognizerDirectionDown];
            break;
        case MBLMessageBannerPositionCenter: {
            [dismissGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
            UISwipeGestureRecognizer *dismissGesture2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                                  action:@selector(dismissViewWithGesture:)];
            [dismissGesture2 setDirection:UISwipeGestureRecognizerDirectionRight];
            [self addGestureRecognizer:dismissGesture2];
            break;
        }
        default:
            
            break;
    }
    [self addGestureRecognizer:dismissGesture];
    
    UITapGestureRecognizer *dismissGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(dismissViewWithGesture:)];
    [dismissGesture3 setNumberOfTapsRequired:1];
    [self addGestureRecognizer:dismissGesture3];
}

#pragma mark -
#pragma mark View Management

- (void)setBlur {
    CGFloat blurRadius = [[_currentDesign objectForKey:BLUR_RADIUS_KEY] floatValue];
    
    if (blurRadius != 0.0) {
        self.blurView = [[FXBlurView alloc] initWithFrame:self.viewController.view.bounds];
        self.blurView.underlyingView = self.viewController.view;
        self.blurView.tintColor = [UIColor clearColor];
        self.blurView.blurRadius = blurRadius;
        self.blurView.alpha = 0.f;
        
        if ([[MBLMessageBanner sharedSingleton] isViewControllerOrParentViewControllerNavigationController:self]) {
            if ([[MBLMessageBanner sharedSingleton] isViewControllerNavigationController:self]) {
                UIView *correctView = [((UINavigationController *)self.viewController) navigationBar];
                
                if (self.position == MBLMessageBannerPositionBottom) {
                    correctView = [((UINavigationController *)self.viewController) toolbar];
                }
                
                [((UINavigationController *)self.viewController).view insertSubview:self.blurView
                                                                       belowSubview:correctView
                 ];
                
            } else {
                [((UINavigationController *)self.viewController.parentViewController).visibleViewController.view addSubview:self.blurView];
            }
        }
        else {
            [self.viewController.view addSubview:self.blurView];
        }
        
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.blurView.alpha = 1.f;
        } completion:nil];
    }
}

- (void)unsetBlur {
     CGFloat blurRadius = [[_currentDesign objectForKey:BLUR_RADIUS_KEY] floatValue];
    
    if (blurRadius != 0.0) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.blurView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [self.blurView removeFromSuperview];
        }];
    }
}

#pragma mark -
#pragma mark Title Label methods

- (UILabel *)createMessageTitle {
    UILabel *titleLabel = [[UILabel alloc] init];
    
    //    Adding title
    [titleLabel setText:self.titleBanner];
    
    //    Changing text appearance
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
    //    title formating
    [titleLabel setNumberOfLines:0];
    [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    return (titleLabel);
}

-(void)setupTitleAutoLayout {
    NSDictionary *titleAndViewDictionary = [[NSMutableDictionary alloc]
                                            initWithDictionary:NSDictionaryOfVariableBindings (_titleLabel, self)];
    
    NSMutableDictionary *titleAndImageDictionary = (self.image ? [[NSMutableDictionary alloc]
                                                           initWithDictionary:NSDictionaryOfVariableBindings (_titleLabel, _imageView)] : nil);
    NSMutableDictionary *titleAndButtonDictionary = (self.button ? [[NSMutableDictionary alloc] initWithDictionary: NSDictionaryOfVariableBindings (_titleLabel, _button)] : nil);
    NSMutableDictionary *titleAndSubtitleDictionary = (self.subtitleLabel ? [[NSMutableDictionary alloc] initWithDictionary:NSDictionaryOfVariableBindings (_titleLabel, _subtitleLabel)] : nil);
    
    
    // Top attach layout and bottom :
    NSString *topBotConstraintVisualFormat;
    NSString *topMarginConstraintVisualFormat = [NSString stringWithFormat:@"V:|->=%f-[_titleLabel]", ELEMENTS_PADDING];
    NSString *bottomMarginConstraintVisualFormat;
    NSMutableDictionary *topBotCorrectDictionnary;
    
    if (!titleAndSubtitleDictionary) {
        topBotConstraintVisualFormat = @"V:|-[_titleLabel]-|";
        bottomMarginConstraintVisualFormat = [NSString stringWithFormat:@"V:[_titleLabel]->=%f-|", ELEMENTS_PADDING];
        topBotCorrectDictionnary = [[NSMutableDictionary alloc] initWithDictionary:titleAndViewDictionary];
    } else {
        topBotConstraintVisualFormat = [NSString stringWithFormat:@"V:|-[_titleLabel]-==%f-[_subtitleLabel]-|", ELEMENTS_PADDING];
        bottomMarginConstraintVisualFormat = [NSString stringWithFormat:@"V:[_subtitleLabel]->=%f-|", ELEMENTS_PADDING];
        topBotCorrectDictionnary = titleAndSubtitleDictionary;
    }
    
    NSMutableArray *verticalConstraints = [NSMutableArray array];
    
    [verticalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:topBotConstraintVisualFormat
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:topBotCorrectDictionnary]];
    [verticalConstraints setValue:@990 forKey:@"priority"];
    [verticalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:topMarginConstraintVisualFormat
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:topBotCorrectDictionnary]];
    [verticalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:bottomMarginConstraintVisualFormat
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:topBotCorrectDictionnary]];
    [self addConstraints:verticalConstraints];
    
    // Left and right layouuts
    NSString *leftRightConstraintVisualFormat;
    NSString *leftMarginConstraintVisualFormat;
    NSString *rightMarginConstraintVisualFormat;
    NSMutableDictionary *leftRightCorrectDictionnary;
    
    // left positionning
    if (titleAndImageDictionary) {
        leftRightConstraintVisualFormat = [NSString stringWithFormat:@"H:|-[_imageView]-==%f-[_titleLabel]", ELEMENTS_PADDING];
        leftMarginConstraintVisualFormat = [NSString stringWithFormat:@"H:|->=%f-[_imageView]", ELEMENTS_PADDING];
        leftRightCorrectDictionnary = titleAndImageDictionary;
    } else {
        leftRightConstraintVisualFormat = @"H:|-[_titleLabel]";
        leftMarginConstraintVisualFormat = [NSString stringWithFormat:@"H:|->=%f-[_titleLabel]", ELEMENTS_PADDING];
        leftRightCorrectDictionnary = [[NSMutableDictionary alloc] initWithDictionary:titleAndViewDictionary];
    }
    
    // right positionning
    if (titleAndButtonDictionary) {
        leftRightConstraintVisualFormat = [NSString stringWithFormat:@"%@-==%f-[_button]"
                                           , leftRightConstraintVisualFormat
                                           , ELEMENTS_PADDING];
        [leftRightCorrectDictionnary addEntriesFromDictionary:titleAndButtonDictionary];
    } else {
        leftRightConstraintVisualFormat = [NSString stringWithFormat:@"%@-|"
                                           , leftRightConstraintVisualFormat];
        rightMarginConstraintVisualFormat = [NSString stringWithFormat:@"H:[_titleLabel]->=%f-|", ELEMENTS_PADDING];
    }
    
    NSMutableArray *horizontalConstraints = [NSMutableArray array];
    
    [horizontalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:leftRightConstraintVisualFormat
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:leftRightCorrectDictionnary]];
    [horizontalConstraints setValue:@990 forKey:@"priority"];
    [horizontalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:leftMarginConstraintVisualFormat
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:leftRightCorrectDictionnary]];
    if (rightMarginConstraintVisualFormat.length > 0) {
        [horizontalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:rightMarginConstraintVisualFormat
                                                                                           options:0
                                                                                           metrics:nil
                                                                                             views:leftRightCorrectDictionnary]];
    }
    
    [self addConstraints:horizontalConstraints];
}

#pragma mark -
#pragma mark Subtitle Label methods

- (UILabel *)createSubtitleLabel {
    UILabel *subtitleLabel = [[UILabel alloc] init];
    
    //    Adding subtitle
    [subtitleLabel setText:self.subTitle];
    
    //    Changing text appearance
    [subtitleLabel setBackgroundColor:[UIColor clearColor]];
    
    //    subtitle formating
    [subtitleLabel setNumberOfLines:0];
    [subtitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    return (subtitleLabel);
}

-(void)setupSubtitleAutoLayout {
    NSDictionary *subtitleAndViewDictionary = [[NSMutableDictionary alloc]
                                            initWithDictionary:NSDictionaryOfVariableBindings (_subtitleLabel, self)];
    
    
    
    NSMutableDictionary *subtitleAndImageDictionary = (self.image ? [[NSMutableDictionary alloc]
                                                                  initWithDictionary:NSDictionaryOfVariableBindings (_subtitleLabel, _imageView)] : nil);
    NSMutableDictionary *subtitleAndButtonDictionary = (self.button ? [[NSMutableDictionary alloc] initWithDictionary: NSDictionaryOfVariableBindings (_subtitleLabel, _button)] : nil);
    NSMutableDictionary *subtitleAndTitleDictionary = (self.subtitleLabel ? [[NSMutableDictionary alloc] initWithDictionary:NSDictionaryOfVariableBindings (_subtitleLabel, _titleLabel)] : nil);
    
    
    // Top attach layout and bottom :
    NSString *topBotConstraintVisualFormat;
    NSMutableDictionary *topBotCorrectDictionnary;
    
    topBotConstraintVisualFormat = [NSString stringWithFormat:@"V:|-[_titleLabel]-==%f-[_subtitleLabel]-|", ELEMENTS_PADDING];
    topBotCorrectDictionnary = subtitleAndTitleDictionary;
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:topBotConstraintVisualFormat
                                                                          options:0
                                                                          metrics:nil
                                                                            views:topBotCorrectDictionnary];
    [verticalConstraints setValue:@990 forKey:@"priority"];
    [self addConstraints:verticalConstraints];
    
    // Left and right layouuts
    NSString *leftRightConstraintVisualFormat;
    NSString *leftMarginConstraintVisualFormat;
    NSString *rightMarginConstraintVisualFormat;
    NSMutableDictionary *leftRightCorrectDictionnary;
    
    // left positionning
    if (subtitleAndImageDictionary) {
        leftRightConstraintVisualFormat = [NSString stringWithFormat:@"H:|-[_imageView]-==%f-[_subtitleLabel]", ELEMENTS_PADDING];
        leftRightCorrectDictionnary = subtitleAndImageDictionary;
    } else {
        leftRightConstraintVisualFormat = @"H:|-[_subtitleLabel]";
        leftMarginConstraintVisualFormat = [NSString stringWithFormat:@"H:|->=%f-[_subtitleLabel]", ELEMENTS_PADDING];
        leftRightCorrectDictionnary = [[NSMutableDictionary alloc] initWithDictionary:subtitleAndViewDictionary];
    }
    
    // right positionning
    if (subtitleAndButtonDictionary) {
        leftRightConstraintVisualFormat = [NSString stringWithFormat:@"%@-==%f-[_button]"
                                           , leftRightConstraintVisualFormat
                                           , ELEMENTS_PADDING];
        [leftRightCorrectDictionnary addEntriesFromDictionary:subtitleAndButtonDictionary];
    } else {
        leftRightConstraintVisualFormat = [NSString stringWithFormat:@"%@-|"
                                           , leftRightConstraintVisualFormat];
        rightMarginConstraintVisualFormat = [NSString stringWithFormat:@"H:[_subtitleLabel]->=%f-|", ELEMENTS_PADDING];
    }
    
    NSMutableArray *horizontalConstraints = [NSMutableArray array];
    
    [horizontalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:leftRightConstraintVisualFormat
                                                                                       options:0
                                                                                       metrics:nil
                                                                                         views:leftRightCorrectDictionnary]];
    [horizontalConstraints setValue:@990 forKey:@"priority"];
    if (leftMarginConstraintVisualFormat.length > 0) {
        [horizontalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:leftMarginConstraintVisualFormat
                                                                                           options:0
                                                                                           metrics:nil
                                                                                             views:leftRightCorrectDictionnary]];
    }
    if (rightMarginConstraintVisualFormat.length > 0) {
        [horizontalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:rightMarginConstraintVisualFormat
                                                                                           options:0
                                                                                           metrics:nil
                                                                                             views:leftRightCorrectDictionnary]];
    }
    [self addConstraints:horizontalConstraints];
}


#pragma mark -
#pragma mark Image View methods

- (void)addImageOnBanner:(UIImage *)image {
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:self.imageView];
}

-(void)setupImageAutoLayout {
    NSMutableDictionary *imageAndsubTitleDictionary = (self.subTitle ? [[NSMutableDictionary alloc]
                                                                     initWithDictionary:NSDictionaryOfVariableBindings (_subtitleLabel, _imageView)] : nil);
    NSMutableDictionary *imageAndTitleDictionary = (self.titleBanner ? [[NSMutableDictionary alloc] initWithDictionary:NSDictionaryOfVariableBindings (_imageView, _titleLabel)] : nil);

    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:_imageView
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f]];
    
    
    NSString* leftRightConstraintsVisualFormat = [NSString stringWithFormat:@"H:|-[_imageView]-==%f-[_titleLabel]"
                                                  , ELEMENTS_PADDING];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:leftRightConstraintsVisualFormat
                                             options:0
                                             metrics:nil
                                               views:imageAndTitleDictionary]];
    if (imageAndsubTitleDictionary) {
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:
          [NSString stringWithFormat:@"H:|-[_imageView]-==%f-[_subtitleLabel]"
                                    , ELEMENTS_PADDING]
                                                 options:0
                                                 metrics:nil
                                                   views:imageAndsubTitleDictionary]];
    }
    
    
    NSString *widthImageFormat = [NSString stringWithFormat:@"[_imageView(==%f)]",
                                   _imageView.frame.size.width];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:widthImageFormat
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_imageView)]];
    
    NSString *heightImageFormat = [NSString stringWithFormat:@"V:[_imageView(==%f)]",
                                    _imageView.frame.size.height];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:heightImageFormat
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_imageView)]];
    
}

#pragma mark -
#pragma mark Button methods Button View methods

- (void)addButtonOnBanner:(NSString *)buttonTitle {
    
    if (buttonTitle && [buttonTitle length]) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setTitle:buttonTitle forState:UIControlStateNormal];
        [self.button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        self.button.contentEdgeInsets = UIEdgeInsetsMake(  0.0f
                                                         , 5.0f
                                                         , 0.0f
                                                         , 5.0f);
        [self.button sizeToFit];
        if (self.userPressedButtonCallback) {
            [self.button addTarget:self action:@selector(userDidPressedButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self addSubview:self.button];
    }
}

-(void)setupButtonAutoLayout {
    NSMutableDictionary *buttonAndsubTitleDictionary = (self.subTitle ? [[NSMutableDictionary alloc]
                                                                        initWithDictionary:NSDictionaryOfVariableBindings (_subtitleLabel, _button)] : nil);
    NSMutableDictionary *buttonAndTitleDictionary = (self.titleBanner ? [[NSMutableDictionary alloc] initWithDictionary:NSDictionaryOfVariableBindings (_button, _titleLabel)] : nil);
    
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:_button
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:0.0f]];
    
    
    NSString* leftRightConstraintsVisualFormat = [NSString stringWithFormat:@"H:[_titleLabel]-==%f-[_button]-|"
                                                  , ELEMENTS_PADDING];
    NSString *rightMarginConstraintsVisualFormat = [NSString stringWithFormat:@"H:[_button]->=%f-|"
                                                    , ELEMENTS_PADDING];
    
    NSMutableArray *horizontalConstraints = [NSMutableArray array];
    [horizontalConstraints addObject:[NSLayoutConstraint constraintsWithVisualFormat:leftRightConstraintsVisualFormat
                                                                             options:0
                                                                             metrics:nil
                                                                               views:buttonAndTitleDictionary]];
    [horizontalConstraints setValue:@990 forKey:@"priority"];
    [horizontalConstraints addObject:[NSLayoutConstraint constraintsWithVisualFormat:rightMarginConstraintsVisualFormat
                                                                             options:0
                                                                             metrics:nil
                                                                               views:buttonAndTitleDictionary]];
    
    [self addConstraints:horizontalConstraints];
    
    if (buttonAndsubTitleDictionary) {
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:
          [NSString stringWithFormat:@"H:[_subtitleLabel]-==%f-[_button]-|"
           , ELEMENTS_PADDING]
                                                 options:0
                                                 metrics:nil
                                                   views:buttonAndsubTitleDictionary]];
    }
    
    NSString *widthButtonFormat = [NSString stringWithFormat:@"[_button(==%f)]",
                                   _button.frame.size.width];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:widthButtonFormat
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_button)]];
    
    NSString *heightButtonFormat = [NSString stringWithFormat:@"V:[_button(==%f)]",
                                   _button.frame.size.height];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:heightButtonFormat
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_button)]];
    
}

#pragma mark -
#pragma mark View Cosmetic
-(NSString *)getStyleTypeLabel:(MBLMessageBannerType)bannerType {
    NSString* styleLabel;
    
    switch (bannerType) {
        case MBLMessageBannerTypeError:
            styleLabel = ERROR_JSON_LABEL;
            break;
        case MBLMessageBannerTypeWarning:
            styleLabel = WARNING_JSON_LABEL;
            break;
        case MBLMessageBannerTypeMessage:
            styleLabel = MESSAGE_JSON_LABEL;
            break;
        case MBLMessageBannerTypeSuccess:
            styleLabel = SUCCESS_JSON_LABEL;
            break;
        default:
            styleLabel = MESSAGE_JSON_LABEL;
            break;
    }
    return styleLabel;
}

- (void) setupStyleWithType:(MBLMessageBannerType)bannerType {
     [self applyMessageStyleFromDictionnary:_currentDesign];
}

- (void)applyMessageStyleFromDictionnary:(NSDictionary *)messageStyle {
    
    [self setBackgroundColor:[UIColor colorWithHexString:[messageStyle objectForKey:BACKGROUND_COLOR_KEY] alpha:[[messageStyle objectForKey:BACKGROUND_ALPHA_KEY] floatValue]]];
    if ([messageStyle objectForKey:BACKGROUND_IMAGE_KEY] && [UIImage imageNamed:[messageStyle objectForKey:BACKGROUND_IMAGE_KEY]]) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[messageStyle objectForKey:BACKGROUND_IMAGE_KEY]]]];
        [self setAlpha:[[messageStyle objectForKey:BACKGROUND_ALPHA_KEY] floatValue]];
    }
    
    
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:[[messageStyle valueForKey:TITLE_TEXT_SIZE_KEY] floatValue]]];
    [self.titleLabel setTextColor:[UIColor colorWithHexString:[messageStyle objectForKey:TITLE_TEXT_COLOR_KEY]]];
    [self.titleLabel setShadowColor:[UIColor colorWithHexString:[messageStyle objectForKey:TITLE_TEXT_SHADOW_COLOR_KEY] alpha:[[messageStyle objectForKey:TITLE_TEXT_SHADOW_ALPHA_KEY] floatValue]]];
    [self.titleLabel setShadowOffset:CGSizeMake([[messageStyle objectForKey:TITLE_TEXT_SHADOW_OFFSET_X_KEY] floatValue],
                                                 [[messageStyle objectForKey: TITLE_TEXT_SHADOW_OFFSET_Y_KEY] floatValue])];

    
    [self.subtitleLabel setFont:[UIFont systemFontOfSize:[[messageStyle valueForKey:SUBTITLE_TEXT_SIZE_KEY] floatValue]]];
    [self.subtitleLabel setTextColor:[UIColor colorWithHexString:[messageStyle objectForKey:SUBTITLE_TEXT_COLOR_KEY]]];
    [self.subtitleLabel setShadowColor:[UIColor colorWithHexString:[messageStyle objectForKey:SUBTITLE_TEXT_SHADOW_COLOR_KEY] alpha:[[messageStyle objectForKey:SUBTITLE_TEXT_SHADOW_ALPHA_KEY] floatValue]]];
    [self.subtitleLabel setShadowOffset:CGSizeMake([[messageStyle objectForKey:SUBTITLE_TEXT_SHADOW_OFFSET_X_KEY] floatValue],
                                                [[messageStyle objectForKey:SUBTITLE_TEXT_SHADOW_OFFSET_Y_KEY] floatValue])];
    
    

    [self.button setTitleColor:[UIColor colorWithHexString:[messageStyle objectForKey:BUTTON_TEXT_COLOR_KEY]] forState:UIControlStateNormal];
    [self.button setTitleShadowColor:[UIColor colorWithHexString:[messageStyle objectForKey:BUTTON_TEXT_SHADOW_COLOR_KEY] alpha:[[messageStyle objectForKey:BUTTON_TEXT_SHADOW_ALPHA_KEY] floatValue]] forState:UIControlStateNormal];
    [self.button.titleLabel setShadowOffset:CGSizeMake([[messageStyle objectForKey:BUTTON_TEXT_SHADOW_OFFSET_X_KEY] floatValue],
                                                      [[messageStyle objectForKey:BUTTON_TEXT_SHADOW_OFFSET_Y_KEY] floatValue])];
    
    
    [self.button setBackgroundColor:[UIColor colorWithHexString:[messageStyle objectForKey:BUTTON_BACKGROUND_COLOR_KEY] alpha:[[messageStyle objectForKey:BUTTON_BACKGROUND_ALPHA_KEY] floatValue]]];
    
    if ([messageStyle objectForKey:BUTTON_BACKGROUND_IMAGE_KEY] != nil &&
        [UIImage imageNamed:[messageStyle objectForKey:BUTTON_BACKGROUND_IMAGE_KEY]] != nil) {
        [self.button setBackgroundImage:[UIImage imageNamed:[messageStyle objectForKey:BUTTON_BACKGROUND_IMAGE_KEY]] forState:UIControlStateNormal];
        [self.button setAlpha:[[messageStyle objectForKey:BUTTON_BACKGROUND_ALPHA_KEY] floatValue]];
    }
    if ([messageStyle objectForKey:BUTTON_BACKGROUND_PATTERN_IMAGE_KEY] != nil &&
        [UIImage imageNamed:[messageStyle objectForKey:BUTTON_BACKGROUND_PATTERN_IMAGE_KEY]] != nil) {
        [self.button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[messageStyle objectForKey:BUTTON_BACKGROUND_PATTERN_IMAGE_KEY]]]];
        [self.button setAlpha:[[messageStyle objectForKey:BUTTON_BACKGROUND_ALPHA_KEY] floatValue]];
    }
    [self.button.layer setCornerRadius:[[messageStyle objectForKey:BUTTON_CORNER_RADIUS_KEY] floatValue]];
    [self.button.layer setMasksToBounds:YES];
    
    [self.button.layer setBorderColor:[[UIColor colorWithHexString:[messageStyle objectForKey:BUTTON_BORDER_COLOR_KEY] alpha:[[messageStyle objectForKey:BUTTON_BORDER_ALPHA_KEY] floatValue]] CGColor]];
    [self.button.layer setBorderWidth:[[messageStyle objectForKey:BUTTON_BORDER_SIZE_KEY] floatValue]];
    
}

#pragma mark -
#pragma mark Swipe Gesture Reconizer handler methods

-(void)dismissViewWithGesture:(UIGestureRecognizer*)gesture {
    
    if (self.isBannerDisplayed == YES) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.userDissmissedCallback) {
                self.userDissmissedCallback(self);
            }
            [[MBLMessageBanner sharedSingleton] hideMessageBanner:self withGesture:gesture andCompletion:nil];
        });
        
    }
}

#pragma mark - Button Pressed Gesture Recognizer methods

- (void)userDidPressedButton:(UIButton *)sender {
    (void)sender;
    if (self.userPressedButtonCallback) {
        self.userPressedButtonCallback(self);
    }
}

@end
