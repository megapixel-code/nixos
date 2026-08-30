#include "library.h"

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main()
{
   char  *buffer      = NULL;
   size_t buffer_size = 0;

   time_t time_buf = 0;
   time_t time_current;
   int    i;
   char  *buffer_status        = NULL;
   char  *buffer_capacity      = NULL;
   size_t size_buffer_status   = 0;
   size_t size_buffer_capacity = 0;

   FILE *f = popen("upower -m", "r");
   if ( f == NULL ) {
      printf("error: cant run cmd\n");
      exit(1);
   }

   do {
      time(&time_current);
      if ( time_current - time_buf < 2 ) {
         continue;
      }
      time(&time_buf);

      FILE *f_capacity = fopen("/sys/class/power_supply/BAT0/capacity", "r");
      FILE *f_status   = fopen("/sys/class/power_supply/BAT0/status", "r");

      if ( f_capacity == NULL || f_status == NULL ) {
         printf("\n");
         fflush(stdout);
         fprintf(stderr, "error opening files\n");
         exit(0);
      }

      getline(&buffer_capacity, &size_buffer_capacity, f_capacity);
      getline(&buffer_status, &size_buffer_status, f_status);

      fclose(f_capacity);
      fclose(f_status);

      i               = 0;
      buffer_capacity = lib_get_next_str_char(buffer_capacity, &i, '\n');
      i               = 0;
      buffer_status   = lib_get_next_str_char(buffer_status, &i, '\n');

      printf("bat");
      if ( lib_same_str(buffer_status, "Charging") ) {
         printf(" (charging) : ");
      } else if ( lib_same_str(buffer_status, "Not charging") ) {
         printf(" (plugged) : ");
      } else {
         printf(": ");
      }
      printf("%s%%\n", buffer_capacity);
      fflush(stdout);
   } while ( getline(&buffer, &buffer_size, f) != -1 );
}
