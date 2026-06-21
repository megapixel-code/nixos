#include <signal.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

FILE *f;

typedef struct {
   char monitor_name[10];
   int  active_tags[10];
   int  selected_tags[10];
   char keymode[10];
} monitor_info;

typedef struct {
   monitor_info *monitor_info;
   size_t        size;
} monitor_info_list;

void cleanup(int sig)
{
   pclose(f);
   printf("exited gracefully\n");
   exit(0);
}

void open()
{
   f = popen("mmsg -w balls -gt", "r");

   if ( f == NULL ) {
      printf("error: could not run the command");
      exit(1);
   }
   signal(SIGINT, cleanup);
}

size_t next_whitespace_index(char *buff, size_t index)
{
   while ( buff[index] != ' ' ) {
      index++;
   }
   return index;
}

int same_str(char *buff, char *str)
{
   for ( int i = 0; str[i] != '\0' && buff[i] != '\0'; i++ ) {
      if ( str[i] != buff[i] ) {
         return 0;
      }
   }
   return 1;
}

monitor_info *get_monitor_info(monitor_info_list *monitor_info_list,
                               char              *monitor_name)
{
   for ( int i = 0; i < monitor_info_list->size; i++ ) {
      if ( same_str(monitor_info_list->monitor_info[i].monitor_name,
                    monitor_name) ) {
         return monitor_info_list->monitor_info + i;
      }
   }

   monitor_info_list->size++;
   monitor_info_list->monitor_info = realloc(
      monitor_info_list->monitor_info,
      sizeof(*monitor_info_list->monitor_info) * monitor_info_list->size);

   for ( int i = 0; i < 10; i++ ) {
      monitor_info_list->monitor_info[monitor_info_list->size - 1]
         .active_tags[i] = 0;
      monitor_info_list->monitor_info[monitor_info_list->size - 1]
         .selected_tags[i] = 0;
   }

   strcpy(
      monitor_info_list->monitor_info[monitor_info_list->size - 1].monitor_name,
      monitor_name);
   strcpy(monitor_info_list->monitor_info[monitor_info_list->size - 1].keymode,
          "normal");
   return monitor_info_list->monitor_info + (monitor_info_list->size - 1);
}

void display_monitor_info(monitor_info_list monitor_info_list)
{
   for ( int i = 0; i < monitor_info_list.size; i++ ) {
      printf("monitor_name :\t%s",
             monitor_info_list.monitor_info[i].monitor_name);

      printf("\nselected_tags :\t");
      for ( int j = 0; j < 10; j++ ) {
         printf("%d ", monitor_info_list.monitor_info[i].selected_tags[j]);
      }

      printf("\nactive_tags :\t");
      for ( int j = 0; j < 10; j++ ) {
         printf("%d ", monitor_info_list.monitor_info[i].active_tags[j]);
      }

      printf("\nkeymode:\t%s", monitor_info_list.monitor_info[i].keymode);
      printf("\n");
   }
}

void parser()
{
   char             *buffer      = NULL;
   size_t            buffer_size = 0;
   size_t            index;
   monitor_info_list monitor_info_list = { .size = 0, .monitor_info = NULL };
   monitor_info     *monitor_info;

   // get_monitor_info(&monitor_info_list, "test", &monitor_info);
   // display_monitor_info(monitor_info_list);
   // get_monitor_info(&monitor_info_list, "balls", &monitor_info);
   // display_monitor_info(monitor_info_list);

   while ( 1 ) {
      getline(&buffer, &buffer_size, f);

      char *monitor = buffer;
      // skip the monitor to go check directly the second part
      index         = next_whitespace_index(buffer, 3);
      buffer[index] = '\0';
      index++;

      if ( same_str(buffer + index, "keymode") ) {
         index         = next_whitespace_index(buffer, index);
         buffer[index] = '\0';
         index++;
         char *keymode = buffer + index;

         // we then remove the \n
         while ( buffer[index] != '\n' ) {
            index++;
         }
         buffer[index] = '\0';

         monitor_info = get_monitor_info(&monitor_info_list, monitor);
         strcpy(monitor_info->keymode, keymode);
      } else if ( same_str(buffer + index, "tags") ) {
         index         = next_whitespace_index(buffer, index);
         buffer[index] = '\0';
         index++;

         // active_tags selected_tags
         int   tags[2];
         char *tags_str;
         for ( int j = 0; j < 2; j++ ) {
            tags_str      = buffer + index;
            index         = next_whitespace_index(buffer, index);
            buffer[index] = '\0';
            index++;

            tags[j] = atoi(tags_str);
         }

         monitor_info = get_monitor_info(&monitor_info_list, monitor);

         // TODO: refactor this shit
         if ( tags[1] == 511 ) {
            // on tag 0
            monitor_info->active_tags[0]   = 1;
            monitor_info->selected_tags[0] = 1;
            for ( int i = 1; i < 10; i++ ) {
               monitor_info->selected_tags[i] = 0;
            }
         } else {
            monitor_info->active_tags[0]   = 0;
            monitor_info->selected_tags[0] = 0;
            for ( int i = 0; i < 9; i++ ) {
               if ( (tags[1] >> i) == 1 ) {
                  monitor_info->selected_tags[i + 1] = 1;
               } else {
                  monitor_info->selected_tags[i + 1] = 0;
               }
            }
         }

         for ( int i = 0; i < 9; i++ ) {
            if ( (tags[0] >> i) % 2 == 1 ) {
               monitor_info->active_tags[i + 1] = 1;
            } else {
               monitor_info->active_tags[i + 1] = 0;
            }
         }

         // removes the next "tags" section
         getline(&buffer, &buffer_size, f);
         display_monitor_info(monitor_info_list);
      }
   }
}

int main()
{
   open();
   parser();
}
