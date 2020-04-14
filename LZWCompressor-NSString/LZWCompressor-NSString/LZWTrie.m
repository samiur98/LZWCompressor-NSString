// Source file for Trie data structure for the encoding and decoding process.

#import "LZWTrie.h"

@interface LZWTrie()
- (Slot) getSlot; //Returns a Slot Struct.
- (void) resizeSlots; //Resizes the slots array.
- (void) memError: (void*) ptr; //Handles memory error.
- (Slot) getDynamicSlot; //Returns a Dynamic Slot.
@end

@implementation LZWTrie
const unsigned short maxCapacity = 32767; //Maximum number of slots the trie can hold.

- (id) init{
    //Initializes Trie data structure with a default capacity of 300.
    self = [super init];
    return [self init: 300];
}

- (id) init: (int) capacity{
    //Initializes Trie data structure with provided capacity.
    self = [super init];
    self.size = 256;
    self.currentCapacity = capacity;
    self.slots = (Slot *)calloc(self.currentCapacity, sizeof(Slot));
    [self memError:(void *)(self.slots)];
    for(int i = 0; i <= self.size; i++){
        self.slots[i] = [self getSlot];
    }
    return self;
}

- (void) append{
    //Adds a slot to the trie data structure.
    if(self.size == (self.currentCapacity - 1)){
        [self resizeSlots];
    }
    self.size = self.size + 1;
    self.slots[self.size] = [self getSlot];
}

- (void) appendDynamic{
    //Adds a dynamic slot to the trie data structure.
    if(self.size == (self.currentCapacity - 1)){
        [self resizeSlots];
    }
    self.size = self.size + 1;
    self.slots[self.size] = [self getDynamicSlot];
}

- (void) appendChar: (unsigned short) slot withValue: (unsigned char) value{
    //Appends a char to the dArray of a dynamic slot.
    if(slot > self.size){
        fprintf(stderr, "Provided slot is gretaer than the current size of the trie.");
        return;
    }
    [self memError: self.slots[slot].dArray];
    if(self.slots[slot].dArrayCapacity == self.slots[slot].dArraySize + 1){
        [self resizeDArray: slot];
    }
    self.slots[slot].dArray[self.slots[slot].dArraySize] = value;
    self.slots[slot].dArraySize = self.slots[slot].dArraySize + 1;
    
}

- (void) setSlotIndex: (unsigned short) slot withIndex: (unsigned short) index{
    //Fills in value of a particular index, in the array of a particular slot with the value of size.
    ((self.slots + slot) -> cArray)[index] = self.size;
}

- (unsigned short) getMaxCapacity{
    //Returns the maximum number of slots that our trie can have.
    return maxCapacity;
}

- (void) resizeSlots{
    //Resizes the slots array.
    if(self.currentCapacity == maxCapacity){
        fprintf(stderr, "Maximum capacity for slots reached.");
    }
    if((self.currentCapacity * 2) > maxCapacity){
        self.slots = (Slot *)realloc(self.slots, sizeof(Slot) * maxCapacity + 1);
        self.currentCapacity = maxCapacity;
        [self memError:(void *) self.slots];
    }
    else{
        self.currentCapacity = self.currentCapacity * 2;
        self.slots = (Slot *)realloc(self.slots, sizeof(Slot) * self.currentCapacity);
        [self memError:(void *) self.slots];
    }
}

- (Slot) getSlot{
    //Returns a Slot Struct.
    Slot slot;
    for(int i = 0; i <= 255; i++){
        slot.cArray[i] = -1;
    }
    slot.isDynamic = false;
    return slot;
}

- (Slot) getDynamicSlot{
    //Returns Slots Struct with dynamiclly allocated array of charachters.
    Slot slot;
    for(int i = 0; i <= 255; i++){
        slot.cArray[i] = -1;
    }
    slot.dArray = (unsigned char *)calloc(4, sizeof(char));
    slot.dArrayCapacity = 4;
    slot.dArraySize = 0;
    [self memError: (void *) slot.dArray];
    slot.isDynamic = true;
    return slot;
}

- (void) resizeDArray: (unsigned short) slot{
    //Resizes the dArray in a dynamic slot
    self.slots[slot].dArrayCapacity = self.slots[slot].dArrayCapacity * 2;
    self.slots[slot].dArray = (unsigned char *) realloc(self.slots[slot].dArray, self.slots[slot].dArrayCapacity);
    [self memError: self.slots[slot].dArray];
}

- (void) memError: (void*) ptr{
    //Exits code if there is an error dynamically allocating memory.
    if(ptr == NULL){
        fprintf(stderr, "Memory Error");
        exit(2);
    }
}

- (void) dealloc{
    //Dynamically allocated memory blocks are set free here.
    if((self.size >= 257) && (self.slots[257].isDynamic)){
        for(int i = 257; i <= self.size; i++){
            free(self.slots[i].dArray);
        }
    }
    free(self.slots);
}
@end
