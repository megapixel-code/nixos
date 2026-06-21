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

int fill_tags(int encoded_val, int *tags)
{
   int changed = 0;

   for ( int i = 0; i < 9; i++ ) {
      if ( (encoded_val >> i) % 2 == 1 ) {
         if ( tags[i + 1] != 1 ) {
            changed = 1;
         }
         tags[i + 1] = 1;
      } else {
         if ( tags[i + 1] != 0 ) {
            changed = 1;
         }
         tags[i + 1] = 0;
      }
   }

   return changed;
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
   // example:
   // {
   //    "hdmi" : {
   //       "tags": [
   //          {
   //             "class": "active selected",
   //             "name" : "0"
   //          },
   //          ...
   //       ],
   //       "keymode": "default"
   //    },
   //    "dp1" : ...
   // }
   int need_space;
   printf("{ ");
   for ( int i = 0; i < monitor_info_list.size; i++ ) {
      printf("\"%s\": { \"tags\": [ ",
             monitor_info_list.monitor_info[i].monitor_name);
      for ( int j = 0; j < 10; j++ ) {
         printf("{ \"class\": \"");
         need_space = 0;
         if ( monitor_info_list.monitor_info[i].active_tags[j] == 1 ) {
            printf("active_tag");
            need_space = 1;
         }
         if ( monitor_info_list.monitor_info[i].selected_tags[j] == 1 ) {
            if ( need_space ) {
               printf(" ");
            }
            printf("selected_tag");
         }
         printf("\", \"name\": \"%d\" }", j);
         if ( j != 9 ) {
            printf(", ");
         } else {
            printf(" ");
         }
      }
      printf("], \"keymode\": \"%s\" }",
             monitor_info_list.monitor_info[i].keymode);
      if ( i < monitor_info_list.size - 1 ) {
         printf(", ");
      } else {
         printf(" ");
      }
   }
   printf("}\n");
}

void parser()
{
   char             *buffer      = NULL;
   size_t            buffer_size = 0;
   size_t            index;
   monitor_info_list monitor_info_list = { .size = 0, .monitor_info = NULL };
   monitor_info     *monitor_info;

   // active_tags selected_tags
   int tags[2];
   int changed;

   while ( 1 ) {
      getline(&buffer, &buffer_size, f);
      changed = 0;

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
         if ( !same_str(monitor_info->keymode, keymode) ) {
            strcpy(monitor_info->keymode, keymode);
            changed = 1;
         }
      } else if ( same_str(buffer + index, "tags") ) {
         index         = next_whitespace_index(buffer, index);
         buffer[index] = '\0';
         index++;

         char *tags_str;
         int   tmp_tags_value;
         for ( int j = 0; j < 2; j++ ) {
            tags_str      = buffer + index;
            index         = next_whitespace_index(buffer, index);
            buffer[index] = '\0';
            index++;

            tags[j] = atoi(tags_str);
         }

         monitor_info = get_monitor_info(&monitor_info_list, monitor);

         if ( tags[1] == 511 ) {
            // on tag 0
            monitor_info->active_tags[0]   = 1;
            monitor_info->selected_tags[0] = 1;
            for ( int i = 1; i < 10; i++ ) {
               if ( monitor_info->selected_tags[i] != 0 ) {
                  changed = 1;
               }
               monitor_info->selected_tags[i] = 0;
            }
         } else {
            monitor_info->active_tags[0]   = 0;
            monitor_info->selected_tags[0] = 0;
            changed =
               fill_tags(tags[1], monitor_info->selected_tags) || changed;
         }
         changed = fill_tags(tags[0], monitor_info->active_tags) || changed;

         // removes the next "tags" section
         getline(&buffer, &buffer_size, f);
      }

      if ( changed ) {
         display_monitor_info(monitor_info_list);
      }
   }
}

int main()
{
   open();
   parser();
}
