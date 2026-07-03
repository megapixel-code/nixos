#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int next_char_index(char *buffer, char c)
{
   int i = 0;
   while ( buffer[i] != c && buffer[i] != '\0' ) {
      i++;
   }
   return i;
}

int same_str(char *buf1, char *buf2)
{
   int i = 0;
   while ( buf1[i] != '\0' && buf2[i] != '\0' && buf1[i] == buf2[i] ) {
      i++;
   }

   if ( buf1[i] == buf2[i] ) {
      return 1;
   }
   return 0;
}

int main()
{
   char  *buffer      = NULL;
   size_t buffer_size = 0;

   time_t time_buf = 0;
   time_t time_current;
   int    i;
   char   buffer_status[32];
   char   buffer_capacity[4];

   FILE *f = popen("upower -e | upower -m", "r");
   if ( f == NULL ) {
      printf("error: cant run cmd\n");
      exit(1);
   }

   while ( getline(&buffer, &buffer_size, f) != -1 ) {
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

      i                  = next_char_index(buffer_capacity, '\n');
      buffer_capacity[i] = '\0';
      i                  = next_char_index(buffer_status, '\n');
      buffer_status[i]   = '\0';

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
   }
}
