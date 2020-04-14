// Encoder Source file that is responsible for encoding NSString Objects.

#import "LZWEncoder.h"

@interface LZWEncoder()
- (char) determineSize: (LZWTrie *) trie; //Method that determines the size category of the trie.
@end

@implementation LZWEncoder

- (id) init{
    self = [super init];
    return self;
}

- (NSString *) encode: (NSString *) inputString{
    //Method that encodes NSString Objects.
    int startIndex = 0;
    NSMutableString *result = [[NSMutableString alloc] initWithString: @""];
    LZWTrie *trie = [[LZWTrie alloc] init];
    LZWWriter *writer = [[LZWWriter alloc] init];
    NSString *inputStringCopy = [inputString copy];
    signed short tracker = -1;
    while(startIndex < [inputStringCopy length]){
        if(trie.getMaxCapacity == trie.size){
            if(writer.buf.containerSize > 0){
                [result appendFormat:@"%C", [writer clearGutter]];
            }
            [result appendFormat:@"%C", [inputStringCopy characterAtIndex: startIndex]];
            continue;
        }
        if(tracker == -1){
            tracker = [inputStringCopy characterAtIndex: startIndex];
            startIndex = startIndex + 1;
            continue;
        }
        unsigned char c = [inputStringCopy characterAtIndex: startIndex];
        signed short nextSlot = (((trie.slots) + tracker) -> cArray[c]);
        if(nextSlot == -1){
            [trie append];
            [trie setSlotIndex: tracker withIndex: c];
            [result appendFormat:@"%C",[writer writeValue: tracker withSize: [self determineSize: trie]]];
            if(writer.buf.containerSize == 8){
                [result appendFormat:@"%C", [writer clearGutter]];
            }
            tracker = c;
        }
        else{
            tracker = nextSlot;
        }
        startIndex = startIndex + 1;
    }
    [result appendFormat:@"%C", [writer writeValue: tracker withSize: [self determineSize: trie]]];
    if(writer.buf.containerSize > 0){
        [result appendFormat:@"%C", [writer clearGutter]];
    }
    return result;
}

- (unsigned char) determineSize:(LZWTrie *)trie{
    //Method that determines the size category of the trie.
    char power = 9;
    while((trie.size - pow(2, power)) > 0){
        power = power + 1;
    }
    return power;
}

@end
