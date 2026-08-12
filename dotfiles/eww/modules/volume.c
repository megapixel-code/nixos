#include "library.h"

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void create_file()
{
   char *path = lib_concat_str(getenv("XDG_CACHE_HOME"), "/eww/volume.pid");
   pid_t pid  = getpid();

   FILE *f = fopen(path, "w");
   fprintf(f, "%d", pid);
   fclose(f);

   free(path);
}

void display(int sig)
{
   size_t buffer_size = 0;
   char  *buffer;

   FILE *f = popen("wpctl get-volume @DEFAULT_AUDIO_SINK@", "r");
   getline(&buffer, &buffer_size, f);
   pclose(f);

   int index = 0;
   while ( buffer[index] != ' ' ) {
      index++;
   }
   // removes the comma
   //  0.70 -> 0.70 or 1.00 -> 1100
   // ^          ^    ^         ^
   if ( buffer[index + 1] != '0' ) {
      buffer[index + 2] = buffer[index + 1];
      index            += 2;
   } else {
      index += 3;
   }
   char *vol = buffer + index;

   while ( buffer[index] != ' ' && buffer[index] != '\n' ) {
      index++;
   }

   if ( buffer[index] == '\n' ) {
      buffer[index] = '\0';
      printf("vol: %s%%\n", vol);
   } else {
      printf("vol: muted\n");
   }

   fflush(stdout);
}

int main()
{
   create_file();
   display(SIGUSR1);
   signal(SIGUSR1, display);

   while ( 1 ) {
      sleep(60);
   }
}
