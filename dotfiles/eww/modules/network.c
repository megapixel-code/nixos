#include "library.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <unistd.h>

FILE *f = NULL;

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
      if ( lib_same_str(device, list_device_info->device_infos[i].device) ) {
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
      if ( !lib_same_str(list_device_info.device_infos[i].state,
                         "connected") ) {
         continue;
      }

      if ( lib_same_str(list_device_info.device_infos[i].type, "ethernet") ) {
         printf("ntwk: eth\n");
         break;
      } else if ( lib_same_str(list_device_info.device_infos[i].type,
                               "wifi") ) {
         printf("ntwk: %s\n", list_device_info.device_infos[i].connection);
         break;
      }
   }

   if ( i == list_device_info.size ) {
      printf("ntwk: ----\n");
   }

   fflush(stdout);
}

void open()
{
   f = popen("nmcli device", "r");
   if ( f == NULL ) {
      fprintf(stderr, "Error: could not run the command\n");
      exit(69);
   }
}

void cleanup()
{
   if ( f != NULL ) {
      pclose(f);
   }
   f = NULL;
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
      device = lib_get_next_str_char(buffer, &index, ' ');
      if ( device == NULL ) {
         return;
      }

      if ( lib_same_str(device, "lo") || lib_same_str(device, "DEVICE") ) {
         continue;
      }

      type = lib_get_next_str_char(buffer, &index, ' ');
      if ( type == NULL ) {
         return;
      }
      state = lib_get_next_str_char(buffer, &index, ' ');
      if ( state == NULL ) {
         return;
      }
      connection = lib_get_next_str_char(buffer, &index, '\n');
      if ( connection == NULL ) {
         return;
      }

      // remove trailing whitespaces in connection
      index -= 2;
      while ( buffer[index] != '\0' && buffer[index] == ' ' ) {
         buffer[index] = '\0';
         index--;
      }

      device_info *device_info = get_device_info(list_device_info, device);

      changed = assign(type, device_info->type) || changed;
      changed = assign(state, device_info->state) || changed;
      changed = assign(connection, device_info->connection) || changed;
   }
   free(buffer);

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
      cleanup();
      sleep(2);
   }
}
