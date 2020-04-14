// Decoder source file that decodes a compressed NSString Object and returns the original NSString object.

#import "LZWDecoder.h"

@interface LZWDecoder()
- (void) decodeHelper: (unsigned short) value withTrie: (LZWTrie *) trie andFlag: (BOOL *) flag toString: (NSMutableString *) str; //Helper function/method for decode function/method.
- (unsigned char) determineSize: (LZWTrie *) trie; //Determines the size category of next byte.

@end

@implementation LZWDecoder

- (NSString *) decode: (NSString *) inputString{
    //Decodes NSString Object and returns original NSString object.
    LZWParser *parser = [[LZWParser alloc] init];
    LZWTrie *trie = [[LZWTrie alloc] init];
    BOOL flag = false;
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for(int i = 0; i < [inputString length] - 1; i++){
        Byte c = [inputString characterAtIndex: i];
        
        if(trie.size == [trie getMaxCapacity]){
            if(parser.container.containerSize > 0){
                unsigned char need = [self determineSize: trie] - parser.container.containerSize;
                unsigned short finalValue = parser.container.value << need;
                finalValue = finalValue | c;
                [self decodeHelper: finalValue withTrie: trie andFlag: &flag toString: result];
            }
            else{
                [result appendFormat: @"%C", [inputString characterAtIndex: i]];
            }
            continue;
        }
        
        if([parser isReady: [self determineSize: trie]]){
            unsigned short value = [parser getValue: [self determineSize: trie]];
            [trie appendDynamic];
            [self decodeHelper: value withTrie: trie andFlag: &flag toString: result];
        }
        [parser append: c];
    }
    
    if([parser isReady: [self determineSize: trie]]){
        unsigned short value = [parser getValue: [self determineSize: trie]];
        [trie appendDynamic];
        [self decodeHelper: value withTrie: trie andFlag: &flag toString: result];
    }

    unsigned char need = [self determineSize: trie] - parser.container.containerSize;
    unsigned short finalValue = parser.container.value << need;
    finalValue = finalValue | [inputString characterAtIndex: ([inputString length] - 1)];
    [trie appendDynamic];
    [self decodeHelper: finalValue withTrie: trie andFlag: &flag toString: result];
    return result;
}

- (void) decodeHelper:(unsigned short)value withTrie:(LZWTrie *)trie andFlag: (BOOL *) flag toString: (NSMutableString *) str{
    //Helper function/method for decode function/method.
    if(value > trie.size){
        fprintf(stderr, "Error in decoding, probably due to bad input");
        exit(2);
    }
    if(value < 256){
        if(*flag){
            [trie appendChar: trie.size - 1 withValue: (unsigned char)value];
        }
        *flag = true;
        [trie appendChar: trie.size withValue: (unsigned char)value];
        [str appendFormat: @"%C", value];
    }
    else{
        if(*flag){
            [trie appendChar: trie.size - 1 withValue: trie.slots[value].dArray[0]];
        }
        *flag = true;
        for(int j = 0; j < trie.slots[value].dArraySize; j++){
            [trie appendChar: trie.size withValue: trie.slots[value].dArray[j]];
        }
        for(int j = 0; j < trie.slots[value].dArraySize; j++){
             [str appendFormat: @"%C",  trie.slots[value].dArray[j]];
        }
    }
}

- (unsigned char) determineSize:(LZWTrie *)trie{
    //Determines the size category of next byte.
    unsigned char power = 9;
    while((trie.size - pow(2, power)) > 0){
        power = power + 1;
    }
    return power;
}

@end
