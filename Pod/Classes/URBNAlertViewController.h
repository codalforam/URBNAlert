//
//  URBNAlertViewController.h
//  URBNAlertTest
//
//  Created by Ryan Garchinsky on 3/3/15.
//  Copyright (c) 2015 URBN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URBNAlertView.h"
#import "URBNAlertStyle.h"
#import "URBNAlertConfig.h"

@class URBNAlertController;
@class URBNAlertViewController;
@class URBNAlertAction;

typedef void(^URBNAlertViewControllerFinishedDismissing)(BOOL wasTouchedOutside);

@interface URBNAlertViewController : UIViewController

/**
 *  Initialize with a title and/or message, as well as a customView if desired
 *
 *  @param title   Optional. The title text displayed in the alert
 *  @param message Optional. The message text displayed in the alert
 *  @param view    The custom UIView you wish to display in the alert
 *
 *  @return A URBNAlertViewController ready to be configurated further or displayed
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message view:(UIView *)view;

/**
 *  Initialize with a title and/or message
 *
 *  @param title   Optional. The title text displayed in the alert
 *  @param message Optional. The message text displayed in the alert
 *
 *  @return A URBNAlertViewController ready to be configurated further or displayed
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

/**
 *  The actual alertView created & displayed within this view controller
 */
@property (nonatomic, strong) URBNAlertView *alertView;

/**
 *  The style object associated with this alert
 */
@property (nonatomic, strong) URBNAlertStyle *alertStyler;

/**
 *  The configuration object associated with this alert
 */
@property (nonatomic, strong) URBNAlertConfig *alertConfig;

/**
 *  The textField displayed in the alert, if added
 */
@property (nonatomic, strong) UITextField *textField;

/**
 *  The customView displayed in the alert, if passed
 */
@property (nonatomic, strong) UIView *customView;

/**
 *  Use this method to show a created/configurated URBNAlertViewController.
 *  Alert will be presented in a new window on top of your app
 */
- (void)show;

/**
 *  Use this method if you wish to show the alert in a specific view and not in a new window
 *
 *  @param view The view in which the alert will appear
 */
- (void)showInView:(UIView *)view;

/**
 *  Call anytime you want to dismiss the currently presented alert
 */
- (void)dismiss;

/**
 *  Dismiss the alert with a sender. Used to detect when the dismiss is called from a gesture
 *
 *  @param sender Who is causing the dismiss
 */
- (void)dismissAlert:(id)sender;

/**
 *  Add a action to the alert. See URBNAlertAction.h for types & initializers
 *
 *  @param action The URBNAlertAction to be added to the alert
 */
- (void)addAction:(URBNAlertAction *)action;

/**
 *  Add a textField to the alert. Configure the textField's properties in the handler.
 *  Note: only 1 text field is supported at the moment
 *
 *  @param configurationHandler If you wish to customize the textFields properties, provide this block
 */
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;

/**
 *  Use this method to display an error message to the user.
 *  The error displays under above the buttons, and below a textField
 *
 *  @param errorText The error you want to display to the user
 */
- (void)showInputError:(NSString *)errorText;

/**
 *  When called, the buttons are disabled until stopLoading is called.
 *  If a textField is present, a loading indicator is added
 */
- (void)startLoading;

/**
 *  Enables all buttons and removes the textField loading spinner if present
 */
- (void)stopLoading;

/**
 *  Used to detect when the alert has completed its dismissing animation
 */
@property (nonatomic, copy) URBNAlertViewControllerFinishedDismissing finishedDismissingBlock;

/**
 *  Provide a block that will run when the alert has completed its dismissing animation
 *
 *  @param finishedDismissingBlock Block of code to run
 */
- (void)setFinishedDismissingBlock:(URBNAlertViewControllerFinishedDismissing)finishedDismissingBlock;

@end
