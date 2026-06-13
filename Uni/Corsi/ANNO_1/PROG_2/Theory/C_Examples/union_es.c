#include <stdio.h>

enum Union_Tag {IS_INT, IS_CHAR};

typedef struct {
   enum Union_Tag tag;
   union {
      int   ival;
      char  cval;
   } data;
} TaggedUnion;
