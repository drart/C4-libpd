//
//  C4PureData.m
//  C4-libpd
//
//  Created by Adam Tindale on 2013-02-20.
//

#import "C4PureData.h"

@implementation C4PureData

-(id) init
{
    audioController = [[PdAudioController alloc] init];
    if ([audioController configureAmbientWithSampleRate:44100 numberChannels:2 mixingEnabled:YES] != PdAudioOK)
    {
        NSLog(@"failed to initialize audio components");
        exit(1); /// bad idea.
    }
    
    // PDDispatcher receives print messages from PD
    dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:dispatcher];
    
    patches = [[NSMutableArray alloc] init];
    
    [self start];  // ;dsp on
    
    return self;
}

-(id) initWithPatch: (NSString *) patchName
{
    self = [self init];
    [self openPatch:patchName];
    
    return self;
}
-(void) start
{
    audioController.active = YES; // ;dsp on
}

-(void) stop
{
    audioController.active = NO;  // ;dsp off
}

//-------------------------------------------
// Patch Management
//-------------------------------------------

-(void) openPatch: (NSString *) patchName
{

    
    PdFile * pdpatch = [PdFile openFileNamed:patchName path:[[NSBundle mainBundle] resourcePath]];
    if (!pdpatch) {
        NSLog(@"Failed to open patch!"); // Gracefully handle failure...
    }
    [patches addObject:pdpatch];
}

-(void) closePatch: (int) index
{
    [patches[index] closeFile];
    [patches removeObjectAtIndex:index];
}

-(void) closeThisPatch:(PdFile *)file
{
    if ([patches containsObject:file])
        [self closePatch:[patches indexOfObject:file]];
}

-(void) closePatchFromFilename:(NSString *)fileName
{
    for(PdFile * file in patches)
    {
        if ([file respondsToSelector:NSSelectorFromString(fileName)])
        {
            [self closeThisPatch:file];
        }
    }
}

-(int) numberOfPatchesOpen
{
    return [patches count];
}

-(PdFile *) returnPatch: (int)index
{
    return [patches objectAtIndex:index];
}

-(void) printPatches
{
    for (PdFile * file in patches)
    {
        NSLog(@"C4PD. Patch Id: %d,  Patch Name:  %@", [patches indexOfObject:file], [file baseName]);
    }
}

//-------------------------------------------
// Message Sending
//-------------------------------------------

-(void) sendBang:(NSString *)receiver
{
    [PdBase sendBangToReceiver:receiver];
}

-(void) sendBangToAPatch:(NSString *)receiver toPatch:(int)index
{
    [PdBase sendBangToReceiver:[NSString stringWithFormat:@"%d%@",[[patches objectAtIndex:index] dollarZero],receiver]];
}

-(void) sendFloat:(float)f toReceiver: (NSString * ) r
{
    [PdBase sendFloat:f toReceiver:r];
}

-(void) sendFloatToAPatch: (float) f toReceiver: (NSString *) r toPatch: (int) index
{
    [PdBase sendFloat:f toReceiver: [NSString stringWithFormat:@"%d%@",[[patches objectAtIndex:index] dollarZero],r]];
}

@end
