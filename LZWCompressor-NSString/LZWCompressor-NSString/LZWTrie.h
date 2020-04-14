// Header file for Trie data structure for the encoding and decoding process.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef struct Slot{
    // Slot Struct of the Trie data structure.
    signed short cArray[256];
    unsigned char* dArray;
    unsigned int dArraySize;
    unsigned int dArrayCapacity;
    BOOL isDynamic;
} Slot;

@interface LZWTrie : NSObject

@property (nonatomic, readwrite) unsigned short size;
@property (nonatomic, readwrite) unsigned short currentCapacity;
@property (nonatomic, readwrite) Slot* slots;

- (id) init; //Initializes Trie data structure with a default capacity of 300.
- (id) init: (int) capacity; //Initializes Trie data structure with provided capacity.
- (void) append; //Adds a slot to the trie data structure.
- (void) appendDynamic; //Adds a dynamic slot to the trie data structure.
- (void) setSlotIndex: (unsigned short) slot withIndex: (unsigned short) index; //Fills in value of a particular index, in the cArray of a particular slot with the value of size.
- (unsigned short) getMaxCapacity; //Returns the maximum number of slots that our trie can have.
- (void) appendChar: (unsigned short) slot withValue: (unsigned char) value; //Appends a char to the dArray of a dynamic slot.
@end

NS_ASSUME_NONNULL_END
