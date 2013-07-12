//
//  C4PD.m
//  C4-libpd
//
//  Created by Adam Tindale on 2013-04-04.
//

#import "C4PD.h"
#import "TheAmazingAudioEngine.h"

// libpd includes
#include "z_libpd.h"
#include "z_queued.h"
#include "z_print_util.h"

@implementation C4PD
{
    AEAudioController * controller;
    AEBlockChannel * channel;
    
    NSMutableArray *  patches;
    NSMutableDictionary * patchionary;
}

static C4PD * mystaticinstance;

- (id)init
{
    // Singleton Pattern
    //--------------------
    if (nil != mystaticinstance)
        @throw [NSException exceptionWithName:@"MultipleDefinitionsOfC4PD" reason:@"Multiple instatiations of C4PD are not allowed" userInfo:nil ];
    
    mystaticinstance = self;
    
    // init audio for PD
    //--------------------    
    controller = [[AEAudioController alloc]
                  initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription]
                  inputEnabled:YES]; // don't forget to autorelease if you don't use ARC!
    
    libpd_init();
    libpd_init_audio((int)controller.numberOfInputChannels, 2, (int)controller.audioDescription.mSampleRate);
    libpd_start_message(1);
    libpd_add_float(1.0f);
    libpd_finish_message("pd", "dsp");
    
    NSString * patchName = @"boop.pd";
    NSString * pathName = [[NSBundle mainBundle] resourcePath];
    const char * base = [patchName cStringUsingEncoding:NSASCIIStringEncoding];
    const char * path = [pathName cStringUsingEncoding:NSASCIIStringEncoding];
    void * pdpatch = libpd_openfile(base, path);
    
    channel = [AEBlockChannel channelWithBlock:^(const AudioTimeStamp  *time,
                                                 UInt32           frames,
                                                 AudioBufferList *audio)
               {
                   libpd_process_short(frames/64, audio->mBuffers[0].mData, audio->mBuffers[0].mData);
               }];
    
    [channel setAudioDescription:[AEAudioController interleaved16BitStereoAudioDescription]];
    [controller addChannels:[NSArray arrayWithObject:channel]];
    
    // set up patch patch arrays -> put this in a property?
    patches = [[NSMutableArray alloc] init];
    patchionary = [[NSMutableDictionary alloc] init];
    
    //---------------------
    /// libpd setup
    //---------------------
    
    libpd_queued_printhook = (t_libpd_printhook) libpd_print_concatenator;
//    libpd_concatenated_printhook = (t_libpd_printhook) printHook;
    
    libpd_queued_banghook = (t_libpd_banghook) bangHook;
//    libpd_queued_floathook = (t_libpd_floathook) floatHook;
//   libpd_queued_symbolhook = (t_libpd_symbolhook) symbolHook;
//    libpd_queued_listhook = (t_libpd_listhook) listHook;
//    libpd_queued_messagehook = (t_libpd_messagehook) messageHook;
    
//    libpd_queued_noteonhook = (t_libpd_noteonhook) noteonHook;
//    libpd_queued_controlchangehook = (t_libpd_controlchangehook) controlChangeHook;
//    libpd_queued_programchangehook = (t_libpd_programchangehook) programChangeHook;
//    libpd_queued_pitchbendhook = (t_libpd_pitchbendhook) pitchBendHook;
//    libpd_queued_aftertouchhook = (t_libpd_aftertouchhook) aftertouchHook;
//    libpd_queued_polyaftertouchhook = (t_libpd_polyaftertouchhook) polyAftertouchHook;
//    libpd_queued_midibytehook = (t_libpd_midibytehook) midiByteHook;
    
    libpd_queued_init();
    
    
    return self;
}

- (void) start
{
    //NSNumber * val = [[NSNumber alloc] initWithBool:YES];
    //NSArray * args = [[NSArray alloc] initWithObjects:val, nil];
    //[self sendMessage:@"dsp" withArguments:args toReceive:@"pd"];
    
    [controller start:Nil];
}

- (void) stop
{
   // NSNumber * val = [[NSNumber alloc] initWithBool:NO];
   // NSArray * args = [[NSArray alloc] initWithObjects:val, nil];
   //[self sendMessage:@"dsp" withArguments:args toReceive:@"pd"];
   //audioController.active = NO;

    [controller stop];
}

- (void)sendFloat:(float)value toReceive:(NSString *)receive
{
    @synchronized(self)
    {
        //return libpd_float([receiverName cStringUsingEncoding:NSASCIIStringEncoding], value);
        libpd_float([receive cStringUsingEncoding:NSASCIIStringEncoding], value);
    }
}

- (void)sendBang:(NSString *)receive
{
    @synchronized(self)
    {
        libpd_bang([receive cStringUsingEncoding:NSASCIIStringEncoding]);
    }
}

+ (void)sendMessage:(NSString *)message withArguments:(NSArray *)list toReceive:(NSString *)receive {
    @synchronized(self) {
        if (libpd_start_message([list count])) return;
        encodeList(list);
        libpd_finish_message([receive cStringUsingEncoding:NSASCIIStringEncoding],
                                    [message cStringUsingEncoding:NSASCIIStringEncoding]);
    }
}
static void encodeList(NSArray *list) {
    for (int i = 0; i < [list count]; i++) {
        NSObject *object = [list objectAtIndex:i];
        if ([object isKindOfClass:[NSNumber class]]) {
            libpd_add_float([(NSNumber *)object floatValue]);
        } else if ([object isKindOfClass:[NSString class]]) {
            libpd_add_symbol([(NSString *)object cStringUsingEncoding:NSASCIIStringEncoding]);
        } else {
            NSLog(@"PdBase: message not supported. %@", [object class]);
        }
    }
}

static void bangHook(const char *src)
{
    NSString *source = [[NSString alloc] initWithCString:src encoding:NSASCIIStringEncoding];
    //emit C4notification with source
    
}

//-------------------------------------------
// Patch Management
//-------------------------------------------

-(int) openPatch: (NSString *) patchName
{
    NSString * pathName = [[NSBundle mainBundle] resourcePath];
    return [self openPatch:patchName inDirectory:pathName];
}


-(int) openPatch:(NSString *)patchName inDirectory:(NSString *)pathName
{
    void * pdpatch;
    @synchronized(self)
    {
        //NSString * pathName = [[NSBundle mainBundle] resourcePath];
        const char * base = [patchName cStringUsingEncoding:NSASCIIStringEncoding];
        const char * path = [pathName cStringUsingEncoding:NSASCIIStringEncoding];
        pdpatch = libpd_openfile(base, path);
    }
    
    if (!pdpatch) {
        NSLog(@"Failed to open patch!"); // Gracefully handle failure...
    }
    
    [patches addObject:[NSValue valueWithPointer:pdpatch]];
    
    // TODO -> move to dictionary instead of array
    int dollarzero = libpd_getdollarzero(pdpatch);
    [patchionary setObject:[NSValue valueWithPointer:pdpatch] forKey: [NSString stringWithFormat:@"%d",  dollarzero]];
    
    return dollarzero;
}

-(void) closePatch: (int) index
{
    NSString * mykey = [NSString stringWithFormat:@"%d", index];
    NSValue * p =  [patchionary objectForKey:mykey];

    @synchronized(self)
    {
        libpd_closefile([p pointerValue]);
    }
    
    [patchionary removeObjectForKey:mykey];
}


-(int) numberOfPatchesOpen
{
    int fff = [patchionary count];
    return [patches count];
}

/*
-(void) printPatches
{
    for (NSObject * file in patches)
    {
        NSLog(@"C4PD. Patch Id: %d,  Patch Name:  %@", [patches indexOfObject:file], [file baseName]);
    }
}
*/

/*
 -(NSArray *) patchNames
{
    int patchCount = [patches count];
    NSMutableArray * patchNameArray = [[NSMutableArray alloc] initWithCapacity:patchCount];
    for (int i = 0 ; i < patchCount; i++)
    {
        [patchNameArray insertObject:[[patches objectAtIndex:i] baseName] atIndex:i];
    }
    return patchNameArray;
}
 */

/*
#pragma mark Notification Methods
*/


+ (int)getBlockSize {
    @synchronized(self) {
        return libpd_blocksize();
    }
}

+ (int)openAudioWithSampleRate:(int)samplerate inputChannels:(int)inputChannels outputChannels:(int)outputchannels {
    @synchronized(self) {
        return libpd_init_audio(inputChannels, outputchannels, samplerate);
    }
}

+ (void)computeAudio:(BOOL)enable {
    NSNumber *val = [[NSNumber alloc] initWithBool:enable];
    NSArray *args = [[NSArray alloc] initWithObjects:val, nil];
    [self sendMessage:@"dsp" withArguments:args toReceive:@"pd"];

}

+ (int)processFloatWithInputBuffer:(float *)inputBuffer outputBuffer:(float *)outputBuffer ticks:(int)ticks {
//    @synchronized(self) {
        return libpd_process_float(ticks, inputBuffer, outputBuffer);
 //   }
}


@end
