#include <stdbool.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define DARK_MODE  0
#define LIGHT_MODE 1

bool goto_next_space(char **buffer)
{
   for ( size_t i = 0; (**buffer != ' ') && (**buffer != '\0'); (*buffer)++ ) {
   }
   if ( **buffer == '\0' ) {
      return true;
   }
   return false;
}

void send_command(int mode)
{
   char *cmd_text;

   if ( mode == DARK_MODE ) {
      cmd_text = "dconf write /org/gnome/desktop/interface/color-scheme "
                 "'\"prefer-dark\"'";
   } else if ( mode == LIGHT_MODE ) {
      cmd_text = "dconf write /org/gnome/desktop/interface/color-scheme "
                 "'\"prefer-light\"'";
   }

   FILE *cmd = popen(cmd_text, "r");
   if ( cmd == NULL ) {
      fprintf(stderr, "ERROR: %s: cannot run the command\n", __FUNCTION__);
      printf("cannot run the command\n");
      exit(69);
   }
   pclose(cmd);

   printf("INFO: set %s\n",
          (mode == DARK_MODE)    ? "dark_mode"
          : (mode == LIGHT_MODE) ? "light_mode"
                                 : "?");
}

void parser()
{
   char *cmd_text = "sunsetr status --follow";

   FILE *cmd = popen(cmd_text, "r");
   if ( cmd == NULL ) {
      return;
   }

   char  *buffer = NULL;
   char  *buf_temp;
   size_t buff_size;
   char  *period;
   while ( getline(&buffer, &buff_size, cmd) ) {
      buf_temp = buffer;

      if ( goto_next_space(&buf_temp) ) {
         continue;
      }
      buf_temp++;
      if ( goto_next_space(&buf_temp) ) {
         continue;
      }
      buf_temp++;

      period = buf_temp;
      if ( goto_next_space(&buf_temp) ) {
         continue;
      }
      *buf_temp = '\0';

      printf("INFO: period = %s\n", period);
      if ( !strcmp(period, "day") ) {
         send_command(LIGHT_MODE);
      } else if ( !strcmp(period, "sunset") ) {
         send_command(DARK_MODE);
      } else if ( !strcmp(period, "night") ) {
         send_command(DARK_MODE);
      } else if ( !strcmp(period, "sunrise") ) {
         send_command(DARK_MODE);
      }
   }
   free(buffer);
}

int main()
{
   while ( true ) {
      parser();
      printf("INFO: exited parser\n");
      sleep(1);
   }
   return 0;
}
