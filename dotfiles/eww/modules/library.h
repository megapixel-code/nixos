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
int lib_same_str(char *str1, char *str2);

/**
 * Assign the src to dest, returns 1 if the content of the destination int
 * changed
 *
 * @param int *src, source int
 * @param int *dest, destination int
 *
 * @return int, 1 if the content of the destination int changed
 */
int _assign_int(int *src, int *dest);

/**
 * Assign the src to dest, returns 1 if the content of the destination buffer
 * changed
 *
 * @param char *src, source buffer
 * @param char *dest, destination buffer
 *
 * @return int, 1 if the content of the destination buffer changed
 */
int _assign_str(char *src, char *dest);

#define assign(src, dest)                                              \
   _Generic((src), char *: _assign_str, int *: _assign_int)(src, dest)

/**
 * Concatenate two string and returns the allocated string output.
 * NOTE: don't forget to free the output
 *
 * @param char *str1
 * @param char *str2
 *
 * @return char *, the result of the two concatenated strings
 */
char *lib_concat_str(char *str1, char *str2);

/**
 * Move the index to the end of the next occurrence of some string.
 * If the string is not in the buffer the index will be set to -1
 *
 * @param char *buffer, the buffer
 * @param char *string, the string we compare to
 * @param int *index, index we want to move
 */
void lib_next_occurrence_end_index(char *buffer, char *string, int *index);

/**
 * Get the next string that end with char c in the buffer. We remove the
 * trailing spaces in front of the buffer. We also increase the index to put it
 * at the end.
 *
 * @param char* buffer, the buffer we containing the contents
 * @param int* index, the index we are currently in said buffer
 * @param char c, the char we want the string to end with
 *
 * @return char*, a string that ends with char c without spaces in front or NULL
 * in case the char c was not found
 */
char *lib_get_next_str_char(char *buffer, int *index, char c);

#endif
