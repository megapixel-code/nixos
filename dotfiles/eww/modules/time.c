#include <stdio.h>
#include <string.h>
#include <sys/time.h>
#include <time.h>
#include <unistd.h>

int main(int argc, char **argv)
{
   char          *month;
   time_t         rawtime;
   struct tm     *timeinfo;
   struct timeval tv;

   int full = -1;
   if ( strcmp(argv[1], "partial") ) {
      full = 1;
   } else if ( strcmp(argv[1], "full") ) {
      full = 0;
   }

   if ( full == -1 ) {
      return 1;
   }

   while ( 1 ) {
      gettimeofday(&tv, NULL);
      usleep(1000000 - tv.tv_usec);

      time(&rawtime);
      timeinfo = localtime(&rawtime);
      switch ( timeinfo->tm_mon ) {
         case 0:
            month = "January";
            break;
         case 1:
            month = "February";
            break;
         case 2:
            month = "March";
            break;
         case 3:
            month = "April";
            break;
         case 4:
            month = "May";
            break;
         case 5:
            month = "June";
            break;
         case 6:
            month = "July";
            break;
         case 7:
            month = "August";
            break;
         case 8:
            month = "September";
            break;
         case 9:
            month = "October";
            break;
         case 10:
            month = "November";
            break;
         case 11:
            month = "December";
            break;
      };

      if ( full ) {
         printf("%d %s %d | ",
                timeinfo->tm_mday,
                month,
                timeinfo->tm_year + 1900);
      }
      printf("%02d:%02d:%02d\n",
             timeinfo->tm_hour,
             timeinfo->tm_min,
             timeinfo->tm_sec);
      fflush(stdout);
   }
}
