#include <stdio.h>
#include <stdlib.h>
#include <sys/inotify.h>
#include <unistd.h>

#define N_FILE 1

int next_char_index(char *buffer, char c)
{
   int i = 0;
   while ( buffer[i] != c ) {
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

void add_or_remove_watches(int add, int fd, char **files, int **wd)
{
   for ( int i = 0; i < N_FILE; i++ ) {
      if ( add ) {
         (*wd)[i] = inotify_add_watch(fd, files[i], IN_CLOSE_NOWRITE);
         if ( (*wd)[i] == -1 ) {
            printf("\n");
            fflush(stdout);
            exit(0);
         }
      } else {
         inotify_rm_watch(fd, (*wd)[i]);
      }
   }
}

int main()
{
   int  *wd            = malloc(sizeof(int) * N_FILE);
   char *files[N_FILE] = { "/sys/class/power_supply/BAT0/capacity" };
   struct inotify_event inotify_buffer;
   int                  i;
   char                 buffer_status[32];
   char                 buffer_capacity[4];

   int fd = inotify_init();
   if ( fd == -1 ) {
      perror("Could not init inotify");
      exit(EXIT_FAILURE);
   }
   add_or_remove_watches(1, fd, files, &wd);

   while ( 1 ) {
      read(fd, &inotify_buffer, sizeof(inotify_buffer));
      for ( i = 0; i < N_FILE; i++ ) {
         if ( wd[i] == inotify_buffer.wd ) {
            break;
         }
      }
      if ( i >= N_FILE ) {
         continue;
      }

      add_or_remove_watches(0, fd, files, &wd);
      FILE *f_capacity = fopen("/sys/class/power_supply/BAT0/capacity", "r");
      FILE *f_status   = fopen("/sys/class/power_supply/BAT0/status", "r");
      if ( f_capacity == NULL || f_status == NULL ) {
         printf("error opening files\n");
         exit(1);
      }

      fgets(buffer_capacity, sizeof(buffer_capacity), f_capacity);
      fgets(buffer_status, sizeof(buffer_status), f_status);

      fclose(f_capacity);
      fclose(f_status);
      add_or_remove_watches(1, fd, files, &wd);

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
