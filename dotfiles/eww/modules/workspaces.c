#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *f;

typedef struct {
   char monitor_name[10];
   int  active_tags[9];
   int  selected_tags[9];
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
   f = popen("mmsg watch all-tags", "r");

   if ( f == NULL ) {
      printf("error: could not run the command");
      exit(1);
   }
   signal(SIGINT, cleanup);
}

int next_occurrence_end_index(char *buff, char *string, int index)
{
   int offset = 0;

   while ( buff[index + offset] != '\0' && string[offset] != '\0' ) {
      while ( buff[index + offset] != '\0' &&
              string[offset] != '\0' &&
              buff[index + offset] == string[offset] ) {
         offset++;
      }

      if ( string[offset] == '\0' ) {
         return (index + offset - 1);
      }

      index++;
      offset = 0;
   }
   return -1;
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

   for ( int i = 0; i < 9; i++ ) {
      monitor_info_list->monitor_info[monitor_info_list->size - 1]
         .active_tags[i] = 0;
      monitor_info_list->monitor_info[monitor_info_list->size - 1]
         .selected_tags[i] = 0;
   }

   strcpy(
      monitor_info_list->monitor_info[monitor_info_list->size - 1].monitor_name,
      monitor_name);
   return monitor_info_list->monitor_info + (monitor_info_list->size - 1);
}

void display_monitor_info_json(monitor_info_list monitor_info_list)
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
   //       ]
   //    },
   //    "dp1" : ...
   // }
   int first_tag;
   int selected_tags[10];
   int tag_zero;

   printf("{ ");
   for ( int i = 0; i < monitor_info_list.size; i++ ) {
      first_tag = 1;
      printf("\"%s\": { \"tags\": [ ",
             monitor_info_list.monitor_info[i].monitor_name);

      tag_zero = 1;
      for ( int k = 0; k < 9; k++ ) {
         if ( monitor_info_list.monitor_info[i].selected_tags[k] == 0 ) {
            tag_zero = 0;
            break;
         }
      }
      if ( tag_zero ) {
         for ( int k = 0; k < 9; k++ ) {
            selected_tags[k] = 0;
         }
         printf("{ \"class\": \"selected_tag\", \"name\": \"0\" }");
         first_tag = 0;
      } else {
         for ( int k = 0; k < 9; k++ ) {
            selected_tags[k] =
               monitor_info_list.monitor_info[i].selected_tags[k];
         }
      }

      for ( int j = 0; j < 9; j++ ) {
         if ( selected_tags[j] == 0 &&
              monitor_info_list.monitor_info[i].active_tags[j] == 0 ) {
            continue;
         }

         if ( !first_tag ) {
            printf(", ");
         }
         first_tag = 0;
         printf("{ \"class\": \"");
         if ( selected_tags[j] == 1 ) {
            printf("selected_tag");
         } else if ( monitor_info_list.monitor_info[i].active_tags[j] == 1 ) {
            printf("active_tag");
         }
         printf("\", \"name\": \"%d\" }", j + 1);
      }
      printf("]}");

      if ( i < monitor_info_list.size - 1 ) {
         printf(", ");
      } else {
         printf(" ");
      }
   }
   printf("}\n");
   fflush(stdout);
}

void parser()
{
   char             *buffer      = NULL;
   size_t            buffer_size = 0;
   int               index;
   monitor_info_list monitor_info_list = { .size = 0, .monitor_info = NULL };
   monitor_info     *monitor_info;

   char *monitor;
   char *is_selected;
   int   b_is_selected;
   int   b_is_active;
   int   changed;

   while ( 1 ) {
      getline(&buffer, &buffer_size, f);
      changed = 0;
      index   = 0;

      while ( 1 ) {
         index = next_occurrence_end_index(buffer, "\"monitor\":\"", index);
         if ( index == -1 ) {
            break;
         }
         buffer[index] = '\0';
         index++;
         monitor       = buffer + index;
         index         = next_occurrence_end_index(buffer, "\"", index);
         buffer[index] = '\0';
         index++;

         monitor_info = get_monitor_info(&monitor_info_list, monitor);

         for ( int i = 0; i < 9; i++ ) {
            index = next_occurrence_end_index(buffer, "\"is_active\":", index);
            index++;
            is_selected   = buffer + index;
            index         = next_occurrence_end_index(buffer, ",", index);
            buffer[index] = '\0';
            index++;

            b_is_selected = same_str(is_selected, "true");
            if ( monitor_info->selected_tags[i] != b_is_selected ) {
               changed                        = 1;
               monitor_info->selected_tags[i] = b_is_selected;
            }

            index =
               next_occurrence_end_index(buffer, "\"client_count\":", index);
            index++;
            b_is_active = buffer[index] != '0';
            if ( monitor_info->active_tags[i] != b_is_active ) {
               changed                      = 1;
               monitor_info->active_tags[i] = b_is_active;
            }
         }
      }

      if ( changed ) {
         display_monitor_info_json(monitor_info_list);
      }
   }
}

int main()
{
   open();
   parser();
}
