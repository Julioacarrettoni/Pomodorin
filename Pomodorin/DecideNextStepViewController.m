//
//  DecideNextStepViewController.m
//  Pomodorin
//
//  Created by Matias Mazzei on 3/24/15.
//  Copyright (c) 2015 mmazzei. All rights reserved.
//

#import "DecideNextStepViewController.h"
#import "GlobalDeclarations.h"
#import "AppDelegate.h"

#import "TodayStatus.h"
#import "TimeBox.h"
#import "Record.h"

@interface DecideNextStepViewController ()
@property (weak) IBOutlet NSButton *recommendedActionButton;
@property (weak) IBOutlet NSButton *startOption1Button;
@property (weak) IBOutlet NSButton *startOption2Button;

@property (copy) void (^recommendedActionBlock)(id);
@property (copy) void (^startOption1Block)(id);
@property (copy) void (^startOption2Block)(id);
@end

@implementation DecideNextStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // To avoid a strong reference cycle
    DecideNextStepViewController* __weak tmpSelf = self;

    // If recommended timebox is Pomodoro then
    //   - recommendedActionButton => Starts a Pomodoro
    //   - startOption1Button => Starts a Short Break
    //   - startOption2Button => Start a Long Break
    //
    if ([self.model recommendedTimebox].type == POMODORO) {
        self.recommendedActionButton.image = [NSImage imageNamed:@"tomato"];
        self.recommendedActionButton.toolTip = @"Start a Pomodoro";
        self.recommendedActionBlock = ^(id sender){[tmpSelf startPomodoro:sender];};

        self.startOption1Button.image = [NSImage imageNamed:@"hourglass"];
        self.startOption1Button.toolTip = @"Start a Short Break";
        self.startOption1Block = ^(id sender){[tmpSelf startShortBreak:sender];};

        self.startOption2Button.image = [NSImage imageNamed:@"dark_hourglass"];
        self.startOption2Button.toolTip = @"Start a Long Break";
        self.startOption2Block = ^(id sender){[tmpSelf startLongBreak:sender];};
    }
    
    // If recommended timebox is Short Break then
    //   - recommendedActionButton => Starts a Short Break
    //   - startOption1Button => Starts a Pomodoro
    //   - startOption2Button => Start a Long Break
    //
    else if ([self.model recommendedTimebox].type == SHORT_BREAK) {
        self.recommendedActionButton.image = [NSImage imageNamed:@"hourglass"];
        self.recommendedActionButton.toolTip = @"Start a Short Break";
        self.recommendedActionBlock = ^(id sender){[tmpSelf startShortBreak:sender];};
        
        self.startOption1Button.image = [NSImage imageNamed:@"tomato"];
        self.startOption1Button.toolTip = @"Start a Pomodoro";
        self.startOption1Block = ^(id sender){[tmpSelf startPomodoro:sender];};
        
        self.startOption2Button.image = [NSImage imageNamed:@"dark_hourglass"];
        self.startOption2Button.toolTip = @"Start a Long Break";
        self.startOption2Block = ^(id sender){[tmpSelf startLongBreak:sender];};
    }

    // If recommended timebox is Short Break then
    //   - recommendedActionButton => Starts a Long Break
    //   - startOption1Button => Starts a Short Break
    //   - startOption2Button => Start a Pomodoro
    else if ([self.model recommendedTimebox].type == LONG_BREAK) {
        self.recommendedActionButton.image = [NSImage imageNamed:@"dark_hourglass"];
        self.recommendedActionButton.toolTip = @"Start a Long Break";
        self.recommendedActionBlock = ^(id sender){[tmpSelf startLongBreak:sender];};
        
        self.startOption1Button.image = [NSImage imageNamed:@"hourglass"];
        self.startOption1Button.toolTip = @"Start a Short Break";
        self.startOption1Block = ^(id sender){[tmpSelf startShortBreak:sender];};
        
        self.startOption2Button.image = [NSImage imageNamed:@"tomato"];
        self.startOption2Button.toolTip = @"Start a Pomodoro";
        self.startOption2Block = ^(id sender){[tmpSelf startPomodoro:sender];};
    }
}
- (IBAction)startRecommended:(id)sender {
    NSLog(@"'Start Recommended' button pressed");
    self.recommendedActionBlock(sender);
}
- (IBAction)startOption1:(id)sender {
    NSLog(@"'Start Option1' button pressed");
    self.startOption1Block(sender);
}

- (IBAction)startOption2:(id)sender {
    NSLog(@"'Start Option2' button pressed");
    self.startOption2Block(sender);
}

- (IBAction)startPomodoro:(id)sender {
    [self.model startAPomodoro];
    id delegate = [NSApp delegate];
    [delegate switchToPomodoringView];
}

- (IBAction)startShortBreak:(id)sender {
    [self.model startAShortBreak];
    id delegate = [NSApp delegate];
    [delegate switchToPomodoringView];
}

- (IBAction)startLongBreak:(id)sender {
    [self.model startALongBreak];
    id delegate = [NSApp delegate];
    [delegate switchToPomodoringView];
}

- (IBAction)seeSummary:(id)sender {
    NSLog(@"'See Summary' button pressed");
    
    id delegate = [NSApp delegate];
    [delegate showRecordWindow];
}

@end
