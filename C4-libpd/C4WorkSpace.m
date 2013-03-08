//
//  C4WorkSpace.m
//  C4-libpd
//
//  Created by Adam Tindale on 2013-02-20.
//

#import "C4WorkSpace.h"
#import "C4PureData.h"

@implementation C4WorkSpace
{
    C4PureData * pd;
    PdFile * ff;
    PdFile * touchPatch;
    PdFile * drums;
    PdFile * seq1, * seq2, * bassline, * background;
    UITextView * text;
    UISwitch * dspswitch, * drumSwitch, * seq1Switch, * seq2Switch, *backgroundSwitch,  * basslineSwitch;
    C4Shape * s ;
}

-(void)setup
{
    ///// C4PureData Setup
    // C4PDprint receives print messages from PD
    [PdBase setDelegate:self];

    pd = [[C4PureData alloc] initWithPatch:@"demo.pd"];
    //ff = [pd openPatch:@"boop.pd"]; // open another patch!!!
    
    // patchNames returns an array of strings for your use
    [self postString:[pd patchNames]];

    seq2 = [pd openPatch:@"sequence2.pd"];
    
    ///// GUI Setup
    dspswitch = [[UISwitch alloc] initWithFrame:
                            CGRectMake(self.canvas.width - 90, 5, 0, 0)];
    [dspswitch addTarget:self action:@selector(switchIsChanged:)
        forControlEvents:UIControlEventValueChanged];
    [self.canvas addSubview:dspswitch];
    
    C4Label * dsptext = [C4Label labelWithText:@"DSP "];
    dsptext.center = CGPointMake(self.canvas.width - dspswitch.frame.size.width - dsptext.width, dspswitch.center.y);
    dsptext.userInteractionEnabled = NO;
    dsptext.textShadowColor = C4GREY;
    dsptext.textShadowOffset = CGSizeMake(1,1);
    [self.canvas addLabel:dsptext];
    
    drumSwitch = [[UISwitch alloc] initWithFrame:
                            CGRectMake(self.canvas.width - 90, 55, 0, 0)];
    [drumSwitch addTarget:self action:@selector(switchIsChanged:)
        forControlEvents:UIControlEventValueChanged];
    [self.canvas addSubview:drumSwitch];
    
    C4Label * drumtext = [C4Label labelWithText:@"Drums "];
    drumtext.center = CGPointMake(self.canvas.width - drumSwitch.frame.size.width - drumtext.width, drumSwitch.center.y);
    drumtext.userInteractionEnabled = NO;
    drumtext.textShadowColor = C4GREY;
    drumtext.textShadowOffset = CGSizeMake(1,1);
    [self.canvas addLabel:drumtext];
    
    backgroundSwitch = [[UISwitch alloc] initWithFrame:
                  CGRectMake(self.canvas.width - 90, 105, 0, 0)];
    [backgroundSwitch addTarget:self action:@selector(switchIsChanged:)
         forControlEvents:UIControlEventValueChanged];
    [self.canvas addSubview:backgroundSwitch];
    
    C4Label * bgtext = [C4Label labelWithText:@"Background "];
    bgtext.center = CGPointMake(self.canvas.width - backgroundSwitch.frame.size.width - bgtext.width, backgroundSwitch.center.y);
    bgtext.userInteractionEnabled = NO;
    bgtext.textShadowColor = C4GREY;
    bgtext.textShadowOffset = CGSizeMake(1,1);
    [self.canvas addLabel:bgtext];
    
    seq1Switch = [[UISwitch alloc] initWithFrame:
                        CGRectMake(self.canvas.width - 90, 155, 0, 0)];
    [seq1Switch addTarget:self action:@selector(switchIsChanged:)
               forControlEvents:UIControlEventValueChanged];
    [self.canvas addSubview:seq1Switch];
    
    C4Label * s1text = [C4Label labelWithText:@"Melody 1 "];
    s1text.center = CGPointMake(self.canvas.width - seq1Switch.frame.size.width - s1text.width, seq1Switch.center.y);
    s1text.userInteractionEnabled = NO;
    s1text.textShadowColor = C4GREY;
    s1text.textShadowOffset = CGSizeMake(1,1);
    [self.canvas addLabel:s1text];
    
    
    
    /// Set up scrolling text output
    /// text is received from the PD print object via PDReceiverDelegate method below
    text = [[UITextView alloc] initWithFrame:
            CGRectMake(0,0 , self.canvas.width, self.canvas.height)];
    [text resignFirstResponder];
    text.userInteractionEnabled = NO;
    text.editable = NO;
    text.backgroundColor = [UIColor clearColor];
    text.text = [NSString stringWithFormat:@"%@", [NSDate date]];
    [self.canvas addSubview:text];
    
}

#pragma mark Touch Event Handlers
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    CGPoint pointOnScreen = [[touches anyObject] locationInView:self.view];
    
    if (nil == s)
    {
        s = [C4Shape rect:CGRectMake(0, 0,100, 100)];
        [s setFillColor:[UIColor blackColor]];
        [s setStrokeColor:[UIColor grayColor]];
    }
    [s setCenter:pointOnScreen];
    [self.canvas addShape:s];

    if (nil == touchPatch)
        touchPatch = [pd openPatch:@"simpleXYSynth.pd"];
    else
        touchPatch = [touchPatch openNewInstance];
    
    [self receivePrint:[NSString stringWithFormat:@" %@", touchPatch]];
    
    [pd sendFloat:1-((float)pointOnScreen.y/self.canvas.height) toReceiver:@"freq"];
    [pd sendFloat:(float)pointOnScreen.x/self.canvas.width toReceiver:@"filterFreq"];

    [self postString:[pd patchNames]];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pointOnScreen = [[touches anyObject] locationInView:self.view];
    [s setCenter:pointOnScreen];
    
    [pd sendFloat:1-((float)pointOnScreen.y/self.canvas.height) toReceiver:@"freq"];
    [pd sendFloat:(float)pointOnScreen.x/self.canvas.width toReceiver:@"filterFreq"];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.canvas removeObject:s];
    [touchPatch closeFile];
}

#pragma mark PDReceiverDelegate
/// receives anything that is passed to a [print] object in PD
-(void)receivePrint:(NSString *)message
{
    NSMutableString * str = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@ : %@", [NSDate date] , message]];
    [str appendFormat:@"\r%@", text.text];
    text.text = str;
}

#pragma mark PDListener
/// receives anything that is passed to a [send] or [s] object in PD
- (void)receiveBangFromSource:(NSString *)source
{
    [self receivePrint:source];
}

- (void)receiveFloat:(float)received fromSource:(NSString *)source
{
    [self receivePrint:source];
}
- (void)receiveSymbol:(NSString *)symbol fromSource:(NSString *)source
{
    [self receivePrint:source];
}
- (void)receiveList:(NSArray *)list fromSource:(NSString *)source
{
    [self receivePrint:source];
}
- (void)receiveMessage:(NSString *)message withArguments:(NSArray *)arguments fromSource:(NSString *)source
{
    [self receivePrint:source];
}

#pragma mark Utilities and Callbacks
- (void)postString:(NSArray *)message
{
    
    NSMutableString * str = [[NSMutableString alloc] init];
    for (int i = 0; i < [message count]; i++)
    {
        [str appendFormat:@"\r%@ : C4PD. Patch ID: %d Patch Name %@", [NSDate date], i,  [message objectAtIndex:i]];
    }
    [str appendFormat:@"\r%@", text.text];
    text.text = str;
}

///// Audio On/Off Switch  /////
- (void) switchIsChanged:(UISwitch *)paramSender
{
    if ([paramSender isEqual:dspswitch ])
    {
        if ([paramSender isOn])
            [pd start];
        else
            [pd stop];
    }
    
    if ([paramSender isEqual:drumSwitch ])
    {
        if ([paramSender isOn])
            drums = [pd openPatch:@"drums1.pd"];
        else
            [pd closeThisPatch:drums];
    }
    
    if ([paramSender isEqual:backgroundSwitch ])
    {
        if ([paramSender isOn])
            background = [pd openPatch:@"backgroundsequence1.pd"];
        else
            [pd closeThisPatch:background];
    }
    
    if ([paramSender isEqual:seq1Switch ])
    {
        if ([paramSender isOn])
            seq1 = [pd openPatch:@"sequence1.pd"];
        else
            [pd closeThisPatch:seq1];
    }
    
    if ([paramSender isEqual:seq2Switch ])
    {
        if ([paramSender isOn])
            seq2 = [pd openPatch:@"sequence2.pd"];
        else
            [pd closeThisPatch:seq2];
    }

}

@end