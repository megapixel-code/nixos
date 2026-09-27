#include "library.h"

int lib_same_str(char *str1, char *str2)
{
   if ( str1 == NULL || str2 == NULL ) {
      return 0;
   }

   int i = 0;
   while ( str1[i] != '\0' && str2[i] != '\0' && str1[i] == str2[i] ) {
      i++;
   }

   if ( str1[i] == str2[i] ) {
      return 1;
   }
   return 0;
}

int _assign_int(int *src, int *dest)
{
   int changed = 0;

   if ( *src != *dest ) {
      *dest   = *src;
      changed = 1;
   }

   return changed;
}

int _assign_str(char *src, char *dest)
{
   int changed = 0;

   if ( !lib_same_str(dest, src) ) {
      dest = (char *)realloc(dest, sizeof(char) * strlen(src));
      strcpy(dest, src);
      changed = 1;
   }

   return changed;
}

char *lib_concat_str(char *str1, char *str2)
{
   int   count;
   int   tot_count  = 0;
   char *strings[2] = { str1, str2 };

   for ( int i = 0; i < 2; i++ ) {
      count = 0;
      while ( strings[i][count] != '\0' ) {
         count++;
      }
      tot_count += count;
   }

   char *out = (char *)malloc(sizeof(char) * (tot_count + 1));

   tot_count = 0;
   for ( int i = 0; i < 2; i++ ) {
      count = 0;
      while ( strings[i][count] != '\0' ) {
         out[count + tot_count] = strings[i][count];
         count++;
      }
      tot_count += count;
   }
   out[tot_count] = '\0';

   return out;
}

void lib_next_occurrence_end_index(char *buffer, char *string, int *index)
{
   int offset = 0;

   while ( buffer[*index + offset] != '\0' && string[offset] != '\0' ) {
      while ( buffer[*index + offset] != '\0' &&
              string[offset] != '\0' &&
              buffer[*index + offset] == string[offset] ) {
         offset++;
      }

      if ( string[offset] == '\0' ) {
         *index += offset - 1;
         return;
      }

      (*index)++;
      offset = 0;
   }

   *(index) = -1;
}

char *lib_get_next_str_char(char *buffer, int *index, char c)
{
   while ( buffer[*index] == ' ' && buffer[*index] != '\0' ) {
      (*index)++;
   }
   if ( buffer[*index] == '\0' ) {
      return NULL;
   }
   char *output = buffer + *index;

   while ( buffer[*index] != c &&
           buffer[*index] != '\n' &&
           buffer[*index] != '\0' ) {
      (*index)++;
   }
   if ( buffer[*index] == '\0' ) {
      return NULL;
   }

   buffer[*index] = '\0';
   (*index)++;

   return output;
}
