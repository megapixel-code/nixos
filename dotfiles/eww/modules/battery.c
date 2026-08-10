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
   char  *buffer_status   = malloc(sizeof(char) * 32);
   char  *buffer_capacity = malloc(sizeof(char) * 4);

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
         // printf("error opening files\n");
         printf("\n");
         exit(1);
      }

      fgets(buffer_capacity, sizeof(buffer_capacity), f_capacity);
      fgets(buffer_status, sizeof(buffer_status), f_status);

      fclose(f_capacity);
      fclose(f_status);

      i               = 0;
      buffer_capacity = get_next_str_char(buffer_capacity, &i, '\n');
      i               = 0;
      buffer_status   = get_next_str_char(buffer_status, &i, '\n');

      printf("bat");
      if ( same_str(buffer_status, "Charging") ) {
         printf(" (charging) : ");
      } else if ( same_str(buffer_status, "Not charging") ) {
         printf(" (plugged) : ");
      } else {
         printf(": ");
      }
      printf("%s%%\n", buffer_capacity);
      fflush(stdout);
   } while ( getline(&buffer, &buffer_size, f) != -1 );
}
