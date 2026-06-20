#include <signal.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>

FILE *f;

typedef struct {
   char monitor_name[10];
   int  active_tags[10];
   int  selected_tags[10];
   char keymode;
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

void get_monitor_info(monitor_info_list monitor_info_list,
                      char             *monitor_name,
                      monitor_info     *monitor_info)
{
   for ( int i = 0; i < monitor_info_list.size; i++ ) {
      if ( same_str(monitor_info_list.monitor_info[i].monitor_name,
                    monitor_name) ) {
      }
   }
}

void parser()
{
   char  *buffer      = NULL;
   size_t buffer_size = 0;
   size_t index, j;

   size_t next;

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

         printf("monitor='%s', keymode='%s'", monitor, keymode);
         printf("\n");
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

         // if 511 on tag 0
         printf("monitor='%s', active_tags='%d', selected_tags='%d'",
                monitor,
                tags[0],
                tags[1]);

         // removes the next "tags" section
         getline(&buffer, &buffer_size, f);
         printf("\n");
      }
   }
}

int main()
{
   open();
   parser();
}
