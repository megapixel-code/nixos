#ifndef MY_LIB
#define MY_LIB
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * Compares two strings, returns 1 if they are the same, 0 otherwise
 *
 * @param char *str1
 * @param char *str2
 *
 * @return int, 1 if the two strings are the same, 0 otherwise
 */
int same_str(char *str1, char *str2)
{
   int i = 0;
   while ( str1[i] != '\0' && str2[i] != '\0' && str1[i] == str2[i] ) {
      i++;
   }

   if ( str1[i] == str2[i] ) {
      return 1;
   }
   return 0;
}

/**
 * Assign the src to dest, returns 1 if the content of the destination int
 * changed
 *
 * @param int *src, source int
 * @param int *dest, destination int
 *
 * @return int, 1 if the content of the destination int changed
 */
int assign_int(int *src, int *dest)
{
   int changed = 0;

   if ( *src != *dest ) {
      *dest   = *src;
      changed = 1;
   }

   return changed;
}

/**
 * Assign the src to dest, returns 1 if the content of the destination buffer
 * changed
 *
 * @param char *src, source buffer
 * @param char *dest, destination buffer
 *
 * @return int, 1 if the content of the destination buffer changed
 */
int assign_str(char *src, char *dest)
{
   int changed = 0;

   if ( !same_str(dest, src) ) {
      strcpy(dest, src);
      changed = 1;
   }

   return changed;
}

#define assign(src, dest)                                            \
   _Generic((src), char *: assign_str, int *: assign_int)(src, dest)

/**
 * Concatenate two string and returns the allocated string output.
 * NOTE: don't forget to free the output
 *
 * @param char *str1
 * @param char *str2
 *
 * @return char *, the result of the two concatenated strings
 */
char *concat_str(char *str1, char *str2)
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

/**
 * Move the index to the end of the next occurrence of some string.
 * If the string is not in the buffer the index will be set to -1
 *
 * @param char *buffer, the buffer
 * @param char *string, the string we compare to
 * @param int *index, index we want to move
 */
void next_occurrence_end_index(char *buffer, char *string, int *index)
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

/**
 * Get the next string that end with char c in the buffer. We remove the
 * trailing spaces in front of the buffer. We also increase the index to put it
 * at the end.
 *
 * @param char* buffer, the buffer we containing the contents
 * @param int* index, the index we are currently in said buffer
 * @param char c, the char we want the string to end with
 *
 * @return char*, a string that ends with char c without spaces in front
 */
char *get_next_str_char(char *buffer, int *index, char c)
{
   while ( buffer[*index] == ' ' ) {
      (*index)++;
   }
   char *output = buffer + *index;

   while ( buffer[*index] != c && buffer[*index] != '\n' ) {
      (*index)++;
   }
   buffer[*index] = '\0';
   (*index)++;

   return output;
}

#endif
