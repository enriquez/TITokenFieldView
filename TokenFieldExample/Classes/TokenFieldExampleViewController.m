//
//  TokenFieldExampleViewController.m
//  TokenFieldExample
//
//  Created by Tom Irving on 29/01/2011.
//  Copyright 2011 Tom Irving. All rights reserved.
//

#import "TokenFieldExampleViewController.h"
#import "Names.h"

@interface TokenFieldExampleViewController (Private)

- (void)resizeViews;

@end

@implementation TokenFieldExampleViewController

- (void)viewDidLoad {
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                                   style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(btnDonePressed)];
	self.navigationItem.rightBarButtonItem = rightButton;
    [self enableButtons];
    
	[self.view setBackgroundColor:[UIColor whiteColor]];
	[self.navigationItem setTitle:@"TITokenFieldView"];
	
	tokenFieldView = [[TITokenFieldView alloc] initWithFrame:self.view.bounds];
	[tokenFieldView setDelegate:self];
	[tokenFieldView.tokenField setAddButtonAction:@selector(showContactsPicker) target:self];
	[tokenFieldView.tokenField setTokenizingCharacters:[NSCharacterSet characterSetWithCharactersInString:@", "]]; // Default is a comma
	
	messageView = [[UITextView alloc] initWithFrame:tokenFieldView.contentView.bounds];
	[messageView setScrollEnabled:NO];
	[messageView setAutoresizingMask:UIViewAutoresizingNone];
	[messageView setDelegate:self];
	[messageView setFont:[UIFont systemFontOfSize:15]];
	[messageView setText:@"Some message. The whole view resizes as you type, not just the text view."];
	[tokenFieldView.contentView addSubview:messageView];
	
	[self.view addSubview:tokenFieldView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	// You can call this on either the view on the field.
	// They both do the same thing.
	[tokenFieldView becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:duration animations:^{[self resizeViews];}]; // Make it pweeetty.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self resizeViews];
}

- (void)showContactsPicker {
	
	// Show some kind of contacts picker in here.
	// For now, it's a good chance to show how to add tokens.
    Contact * c = [[Contact alloc] initWithName:@"Contact" andEmail:@"contact@contact.com"];
    
	TIToken * token = [[TIToken alloc] initWithTitle:c.name
                                   representedObject:c];
    
    [tokenFieldView.tokenField addToken:token];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	
	CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	
	// Wouldn't it be fantastic if, when in landscape mode, width was actually width and not height?
	keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
	
	[self resizeViews];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	keyboardHeight = 0;
	[self resizeViews];
}

- (void)resizeViews {
	
	CGRect newFrame = tokenFieldView.frame;
	newFrame.size.width = self.view.bounds.size.width;
	newFrame.size.height = self.view.bounds.size.height - keyboardHeight;
	[tokenFieldView setFrame:newFrame];
	[messageView setFrame:tokenFieldView.contentView.bounds];
}

- (void)textViewDidChange:(UITextView *)textView {
	
	CGFloat oldHeight = tokenFieldView.frame.size.height - tokenFieldView.tokenField.frame.size.height;
	CGFloat newHeight = textView.contentSize.height + textView.font.lineHeight;
	
	CGRect newTextFrame = textView.frame;
	newTextFrame.size = textView.contentSize;
	newTextFrame.size.height = newHeight;
	
	CGRect newFrame = tokenFieldView.contentView.frame;
	newFrame.size.height = newHeight;
	
	if (newHeight < oldHeight){
		newTextFrame.size.height = oldHeight;
		newFrame.size.height = oldHeight;
	}
		
	[tokenFieldView.contentView setFrame:newFrame];
	[textView setFrame:newTextFrame];
	[tokenFieldView updateContentSize];
}

#pragma mark - Actions

//Send button pressed
- (void)btnDonePressed {
    NSMutableString *msg = [NSMutableString string];
    
    BOOL allOK = YES;
    
    for (TIToken *token in tokenFieldView.tokenField.tokens) {
        if (!token.representedObject) allOK = NO;
        
        [msg appendFormat:@"%@ ", ((Contact *)token.representedObject).email];
    }
    
    if (allOK) {
        [[[UIAlertView alloc] initWithTitle:@"Sending to..."
                                    message:msg
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Some recipients are invalid. Please remove all recipients shown in red and try again."
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        
    }
}

#pragma mark -

//enable or disable Send button
- (void)enableButtons {
    BOOL enabled = [tokenFieldView.tokenField.tokens count] > 0;
    
    if ([messageView.text length] < 1) enabled = NO;
    
    self.navigationItem.rightBarButtonItem.enabled = enabled;
}

//simple email validation
- (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
    return [emailTest evaluateWithObject:email];
}

#pragma mark - TITokenFieldViewDelegate methods

- (void)tokenField:(TITokenField *)tokenField didChangeToFrame:(CGRect)frame {
	[self textViewDidChange:messageView];
}

//convert Contact to string
- (NSString *)tokenField:(TITokenField *)tokenField displayStringForRepresentedObject:(id)object {
    return ((Contact *)object).name;
}

//search (on background)
- (NSArray *)tokenField:(TITokenField *)tokenField resultsForSearchPattern:(NSString *)pattern {
    NSMutableArray *result = [NSMutableArray array];
    
    //search on background - emulate 0.5s delay
    [NSThread sleepForTimeInterval:0.5];
    
    //do the search (in both name and email)
    for (Contact *c in [Names listOfContacts]) {
        if ([c.name rangeOfString:pattern options:NSCaseInsensitiveSearch].length > 0 ||
            [c.email rangeOfString:pattern options:NSCaseInsensitiveSearch].length > 0) {
            [result addObject:c];
        }
    }
    
    return result;
}

//token about to be created
//trim the title
- (NSString *)tokenField:(TITokenField *)tokenField willCreateTokenWithTitle:(NSString *)title {
    return [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];    
}

//token about to be added
//if there is no Contact object attached, this means it originates from user having typed a text
//if it is valid email, we create Contact and attach it
- (void)tokenField:(TITokenField *)tokenField willAddToken:(TIToken *)token withTitle:(NSString *)title {
    if (!token.representedObject) {
        if ([self validateEmail:token.title]) {
            token.representedObject = [[Contact alloc] initWithName:token.title andEmail:token.title];
        }
    }
    
}

//token added
//if there is no Contact object attached, it is invalid and red, blue otherwise
- (void)tokenField:(TITokenField *)tokenField didAddToken:(TIToken *)token {
    [self enableButtons];

    if (!token.representedObject) {
        token.tintColor = [UIColor redColor];
    }
}

//token removed
- (void)tokenField:(TITokenField *)tokenField didRemoveToken:(TIToken *)token {
    [self enableButtons];   
}

//cell for one search result
- (UITableViewCell *)tokenField:(TITokenField *)tokenField resultsTableView:(UITableView *)tableView cellForRepresentedObject:(id)object {
    Contact *c = (Contact *)object;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ContactCell"];
        cell.textLabel.text = c.name;
        cell.detailTextLabel.text = c.email;
    }
    
    return cell;
    
}

//cell height for search result cell
- (CGFloat)tokenField:(TITokenField *)tokenField resultsTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}


@end