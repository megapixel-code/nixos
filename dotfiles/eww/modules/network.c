#include "library.h"

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

FILE *f;

typedef struct {
   char device[20];
   char type[10];
   char state[15];
   char connection[25];
} device_info;

typedef struct {
   device_info *device_infos;
   size_t       size;
} list_device_info;

device_info *get_device_info(list_device_info *list_device_info, char *device)
{
   for ( int i = 0; i < list_device_info->size; i++ ) {
      if ( same_str(device, list_device_info->device_infos[i].device) ) {
         return list_device_info->device_infos + i;
      }
   }

   list_device_info->size++;
   list_device_info->device_infos =
      realloc(list_device_info->device_infos,
              list_device_info->size * sizeof(device_info));
   strcpy(list_device_info->device_infos[list_device_info->size - 1].device,
          device);
   return list_device_info->device_infos + list_device_info->size - 1;
}

void display_device_info(list_device_info list_device_info)
{
   int i;

   for ( i = 0; i < list_device_info.size; i++ ) {
      if ( !same_str(list_device_info.device_infos[i].state, "connected") ) {
         continue;
      }

      if ( same_str(list_device_info.device_infos[i].type, "ethernet") ) {
         printf("ntwk: eth\n");
         break;
      } else if ( same_str(list_device_info.device_infos[i].type, "wifi") ) {
         printf("ntwk: %s\n", list_device_info.device_infos[i].connection);
         break;
      }
   }

   if ( i == list_device_info.size ) {
      printf("ntwk: ----\n");
   }

   fflush(stdout);
}

void cleanup(int sig)
{
   pclose(f);
   f = NULL;
}

void open()
{
   f = popen("nmcli device", "r");

   if ( f == NULL ) {
      printf("error: could not run the command");
      exit(1);
   }
   signal(SIGINT, cleanup);
}

void parser(list_device_info *list_device_info)
{
   char  *buffer      = NULL;
   size_t buffer_size = 0;

   int   index;
   int   changed = 0;
   char *device;
   char *type;
   char *state;
   char *connection;

   while ( getline(&buffer, &buffer_size, f) != -1 ) {
      index  = 0;
      device = get_next_str_char(buffer, &index, ' ');

      if ( same_str(device, "lo") || same_str(device, "DEVICE") ) {
         continue;
      }

      type       = get_next_str_char(buffer, &index, ' ');
      state      = get_next_str_char(buffer, &index, ' ');
      connection = get_next_str_char(buffer, &index, '\n');

      device_info *device_info = get_device_info(list_device_info, device);

      changed = assign(type, device_info->type) || changed;
      changed = assign(state, device_info->state) || changed;
      changed = assign(connection, device_info->connection) || changed;
   }

   if ( changed ) {
      display_device_info(*list_device_info);
   }
}

int main()
{
   list_device_info list_device_info;
   list_device_info.device_infos = NULL;
   list_device_info.size         = 0;

   while ( 1 ) {
      open();
      parser(&list_device_info);
      cleanup(0);
      sleep(2);
   }
}
