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
    UITextView * text;
    C4Shape * s ;
}

-(void)setup
{
    ///// C4PureData Setup
    // C4PDprint receives print messages from PD
    [PdBase setDelegate:self];

    pd = [[C4PureData alloc] initWithPatch:@"demo.pd"];
    ff = [pd openPatch:@"boop.pd"]; // open another patch!!!
    
    // patchNames returns an array of strings for your use
    [self postString:[pd patchNames]];
    
    [pd openPatch:@"sequence2.pd"];
    
    ///// GUI Setup
    UISwitch * dspswitch = [[UISwitch alloc] initWithFrame:
                            CGRectMake(self.canvas.width - 90, 5, 0, 0)];
    [dspswitch addTarget:self action:@selector(switchIsChanged:)
        forControlEvents:UIControlEventValueChanged];
    [self.canvas addSubview:dspswitch];

    UISwitch * drumSwitch = [[UISwitch alloc] initWithFrame:
                            CGRectMake(self.canvas.width - 90, 50, 0, 0)];
    [drumSwitch addTarget:self action:@selector(drumSwitchChanged:)
        forControlEvents:UIControlEventValueChanged];
    [self.canvas addSubview:drumSwitch];
    
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
    if ([paramSender isOn])
        [pd start];
    else
        [pd stop];
}
-(void) drumSwitchChanged: (UISwitch *)paramSender
{
    if ([paramSender isOn])
        drums = [pd openPatch:@"drums1.pd"];
    else
        [pd closeThisPatch:drums];
}
@end