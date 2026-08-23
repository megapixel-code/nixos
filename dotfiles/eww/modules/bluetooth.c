#include "library.h"

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void parser(int *device_count, char *device_name)
{
   char  *buffer      = NULL;
   size_t buffer_size = 0;

   int   n_devices = 0;
   char *device;
   int   index   = 0;
   int   changed = 0;

   FILE *f = popen("bluetoothctl devices Connected", "r");
   while ( getline(&buffer, &buffer_size, f) != -1 ) {
      n_devices++;
      if ( n_devices > 1 ) {
         // we don't care about the names, we only want the count
         continue;
      }

      lib_get_next_str_char(buffer, &index, ' ');
      lib_get_next_str_char(buffer, &index, ' ');
      device = lib_get_next_str_char(buffer, &index, '\n');

      changed = assign(device, device_name) || changed;
   }
   fclose(f);
   free(buffer);

   changed = assign(&n_devices, device_count) || changed;
   if ( !changed ) {
      return;
   }

   printf("bt: ");
   if ( n_devices == 0 ) {
      printf("none\n");
   } else if ( n_devices == 1 ) {
      printf("%s\n", device);
   } else {
      printf("%d devices\n", n_devices);
   }
   fflush(stdout);

   system("xargs -a \"$XDG_CACHE_HOME/eww/volume.pid\" kill -s SIGUSR1");
}

int main(int argc, char *argv[])
{
   int  device_count = -1;
   char device_name[64];
   while ( 1 ) {
      parser(&device_count, device_name);
      sleep(2);
   }
}
