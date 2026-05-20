{
  pkgs,
  lib,
  config,
  user,
  ...
}:
{
  options = {
    my.aerc = {
      accounts = {
        total_vfemails = lib.mkOption {
          description = "Indicate the number of vfemails accounts you have in your sops secrets";
          type = lib.types.int;
          default = 0;
        };
        path = lib.mkOption {
          description = "path of accounts.conf";
          type = lib.types.str;
          default = "${config.xdg.configHome}/aerc/accounts.conf";
        };
      };
      isync = {
        home.path = lib.mkOption {
          description = "isync home folder";
          type = lib.types.str;
          default = "${config.xdg.configHome}/isync";
        };
        maildir.path = lib.mkOption {
          description = "path of maildir WITH NO / AT THE END";
          type = lib.types.str;
          default = "${config.xdg.dataHome}/mail";
        };
      };
    };
  };

  # TODO: https://man.sr.ht/~rjarry/aerc/configurations/mailto.md

  config = lib.mkIf config.my.pkgs.apps.enable {
    my.aerc.accounts = {
      total_vfemails = 1;
    };

    home.packages = with pkgs; [
      chafa # images in the terminal
      isync # sync mails
      w3m # html to text
    ];

    programs.aerc = {
      enable = true;

      extraBinds = {
        # NOTE: https://man.archlinux.org/man/aerc.1.en
        global = {
          "<C-p>" = ":prev-tab<Enter>";
          "<C-n>" = ":next-tab<Enter>";
          "<C-t>" = ":term<Enter>";
          "?" = ":help keys<Enter>";
        };
        messages = {
          "q" = ":prompt 'Quit?' quit<Enter>";

          "j" = ":next<Enter>";
          "k" = ":prev<Enter>";
          "<C-d>" = ":next 50%<Enter>";
          "<C-u>" = ":prev 50%<Enter>";
          "<C-f>" = ":next 100%<Enter>";
          "<C-b>" = ":prev 100%<Enter>";
          "g" = ":select 0<Enter>";
          "G" = ":select -1<Enter>";
          "zz" = ":align center<Enter>";
          "zt" = ":align top<Enter>";
          "zb" = ":align bottom<Enter>";

          "J" = ":next-folder<Enter>";
          "K" = ":prev-folder<Enter>";
          "H" = ":collapse-folder<Enter>";
          "L" = ":expand-folder<Enter>";

          "<Space>" = ":mark -t<Enter>:next<Enter>";
          "v" = ":mark -t<Enter>";
          "V" = ":mark -v<Enter>";
          "gv" = ":remark<Enter>";
          "zo" = ":unfold<Enter>";
          "zc" = ":fold<Enter>";

          "<Esc>" = ":clear<Enter>:unmark -a<Enter>";

          "?" = ":search<Space>-a<Space>";
          "/" = ":filter<Space>-a<Space>";
          "n" = ":next-result<Enter>";
          "N" = ":prev-result<Enter>";

          "T" = ":toggle-threads<Enter>";
          "<tab>" = ":fold -t<Enter>";
          "m" = ":menu -dc \"fzf\" -t \"Move to :\" :move<Enter>";
          "a" = ":archive flat<Enter>";
          "A" = ":unmark -a<Enter>:mark -T<Enter>:archive flat<Enter>"; # archive thread
          "s" = ":split<Enter>";
          "S" = ":vsplit<Enter>";

          "<C-r>" = ":check-mail<Enter>";
          "d" = ":choose -o y 'Really delete this message' delete-message<Enter>";
          "<Enter>" = ":view<Enter>";
          "i" = ":compose<Enter>";
          "rr" = ":reply<Enter>";
          "rq" = ":reply -q<Enter>";
          "Rr" = ":reply -a<Enter>";
          "Rq" = ":reply -aq<Enter>";
        };
        "messages:folder=Drafts" = {
          "<Enter>" = ":recall<Enter>";
        };
        "view" = {
          "<C-k>" = ":prev-part<Enter>";
          "<C-j>" = ":next-part<Enter>";
          "J" = ":next<Enter>";
          "K" = ":prev<Enter>";

          "q" = ":close<Enter>";
          "o" = ":open -d<Enter>";
          "S" = ":save<Space>";
          "|" = ":pipe<Space>";
          "D" = ":delete<Enter>";
          "A" = ":archive flat<Enter>";

          "<C-y>" = ":copy-link<Space>";
          "<C-l>" = ":open-link<Space>";

          "f" = ":forward<Enter>";
          "rr" = ":reply<Enter>";
          "rq" = ":reply -q<Enter>";
          "Rr" = ":reply -a<Enter>";
          "Rq" = ":reply -aq<Enter>";

          "H" = ":toggle-headers<Enter>";
        };
        "view::passthrough" = {
          "$noinherit" = "true";
          "$ex" = "<C-x>";
          "<Esc>" = ":toggle-key-passthrough<Enter>";
        };
        "compose" = {
          # Keybindings used when the embedded terminal is not selected in the compose view
          "$noinherit" = "true";
          "$ex" = "<C-x>";
          "$complete" = "<C-o>";
          "<C-k>" = ":prev-field<Enter>";
          "<C-j>" = ":next-field<Enter>";
          "<A-p>" = ":switch-account -p<Enter>";
          "<A-n>" = ":switch-account -n<Enter>";
          "<C-p>" = ":prev-tab<Enter>";
          "<C-n>" = ":next-tab<Enter>";
        };
        "compose::editor" = {
          # Keybindings used when the embedded terminal is selected in the compose view
          "$noinherit" = "true";
          "$ex" = "<C-x>";
          "<C-k>" = ":prev-field<Enter>";
          "<C-j>" = ":next-field<Enter>";
          "<C-p>" = ":prev-tab<Enter>";
          "<C-n>" = ":next-tab<Enter>";
        };
        "compose::review" = {
          "y" = ":send<Enter> # Send";
          "n" = ":abort<Enter> # Abort (discard message, no confirmation)";
          "s" = ":sign<Enter> # Toggle signing";
          "x" = ":encrypt<Enter> # Toggle encryption to all recipients";
          "v" = ":preview<Enter> # Preview message";
          "p" = ":postpone<Enter> # Postpone";
          "q" = ":choose -o d discard abort -o p postpone postpone<Enter> # Abort or postpone";
          "e" = ":edit<Enter> # Edit (body and headers)";
          "a" = ":menu -c \"yazi --chooser-file=%f\" -t \"Add Attachment\" :attach<Enter> # Add attachment";
          "d" = ":detach<Space> # Remove attachment";
        };
        "terminal" = {
          "$noinherit" = "true";
          "$ex" = "<C-x>";
          "<C-p>" = ":prev-tab<Enter>";
          "<C-n>" = ":next-tab<Enter>";
        };
      };
      extraConfig = {
        general = {
          "unsafe-accounts-conf" = false;
        };
        ui = {
          "reverse-thread-order" = "false";
          "threading-enabled" = "true";
          "fuzzy-complete" = "true";
          "icon-attachment" = "󰁦";
          "icon-new" = "";
          "icon-old" = "󱍢";
          "icon-replied" = "";
          "icon-forwarded" = "";
          "icon-flagged" = "󰈻";
          "icon-marked" = "󰄲";
          "icon-deleted" = "";
        };
        viewer = {
          "header-layout" = "From,To,Cc,Bcc,Date,Subject";
          "alternatives" = "text/html,text/plain";
        };
        compose = {
          "header-layout" = "From,To,Cc,Subject";
          "empty-subject-warning" = "true";
          "address-book-cmd" = "${config.sops.templates."emailbook".path} \"%s\"";
        };
        filters = {
          "text/plain" = "colorize";
          "text/calendar" = "calendar";
          "message/delivery-status" = "colorize";
          "message/rfc822" = "colorize";
          "text/html" = "w3m -T text/html -dump -o display_link_number=1 | colorize";
          ".headers" = "colorize";
          "image/*" = "chafa -f symbols -s $(tput cols)x$(tput lines) -";
        };
      };
    };

    sops =
      let
        var_placeholder = config.sops.placeholder;

        numberize = cfg: if cfg > 0 then map toString (lib.range 1 cfg) else [ ];
        all_vfemail_nb = numberize config.my.aerc.accounts.total_vfemails;

        one_vfemail_secret = nb: {
          "mails/vfemail_${nb}/mail" = { };
          "mails/vfemail_${nb}/mailUrlEncoded" = { };
          "mails/vfemail_${nb}/password" = { };
        };

        map_concat = one_m: all_m_nb: lib.strings.concatStringsSep "\n" (map one_m all_m_nb);
        one_vfemail = nb: ''
          [${var_placeholder."mails/vfemail_${nb}/mail"}]
          source        = maildir://${config.my.aerc.isync.maildir.path}/${
            var_placeholder."mails/vfemail_${nb}/mail"
          }
          outgoing      = smtps://${var_placeholder."mails/vfemail_${nb}/mailUrlEncoded"}:${
            var_placeholder."mails/vfemail_${nb}/password"
          }@smtp.vfemail.net:465
          from          = ${user} <${var_placeholder."mails/vfemail_${nb}/mail"}>
          check-mail-cmd = ${config.sops.templates."mbsyncscript".path} ${
            var_placeholder."mails/vfemail_${nb}/mail"
          }
          check-mail-timeout = 30s
          check-mail         = 30s
          default            = INBOX
          folders-sort       = INBOX
          postpone           = Drafts
          copy-to            = Sent
        '';

        one_mbsync = nb: ''
          IMAPAccount ${var_placeholder."mails/vfemail_${nb}/mail"}
          Host imap.vfemail.net
          Port 993
          User ${var_placeholder."mails/vfemail_${nb}/mail"}
          Pass ${var_placeholder."mails/vfemail_${nb}/password"}
          TLSType IMAPS

          IMAPStore ${var_placeholder."mails/vfemail_${nb}/mail"}-remote
          Account ${var_placeholder."mails/vfemail_${nb}/mail"}

          MaildirStore ${var_placeholder."mails/vfemail_${nb}/mail"}-local
          Path ${config.my.aerc.isync.maildir.path}/${var_placeholder."mails/vfemail_${nb}/mail"}/
          INBOX ${config.my.aerc.isync.maildir.path}/${var_placeholder."mails/vfemail_${nb}/mail"}/INBOX
          Trash ${config.my.aerc.isync.maildir.path}/${var_placeholder."mails/vfemail_${nb}/mail"}/Trash
          SubFolders Verbatim

          Channel ${var_placeholder."mails/vfemail_${nb}/mail"}
          Far :${var_placeholder."mails/vfemail_${nb}/mail"}-remote:
          Near :${var_placeholder."mails/vfemail_${nb}/mail"}-local:
          Patterns *
          Create Both
          Expunge Both
          SyncState *
        '';
        one_mbsync_script = nb: ''
          mkdir -m 700 -p ${config.my.aerc.isync.maildir.path}/${var_placeholder."mails/vfemail_${nb}/mail"}
          mbsync -c ${config.my.aerc.isync.home.path}/mbsyncrc ${var_placeholder."mails/vfemail_${nb}/mail"}
        '';

        all_secrets = lib.mergeAttrsList (
          [
            {
              "mails/emailbook" = { };
            }
          ]
          ++ (map one_vfemail_secret all_vfemail_nb)
        );
        all_emails = lib.concatStringsSep "\n" [
          (map_concat one_vfemail all_vfemail_nb)
        ];
        all_mbsync = lib.concatStringsSep "\n" [
          (map_concat one_mbsync all_vfemail_nb)
        ];
        all_mbsync_script = lib.concatStringsSep "\n" [
          (map_concat one_mbsync_script all_vfemail_nb)
        ];

      in
      {
        secrets = all_secrets;
        templates = {
          "accounts.conf" = {
            content = all_emails;
            path = config.my.aerc.accounts.path;
            mode = "400";
          };
          "mbsyncrc" = {
            content = all_mbsync;
            path = config.my.aerc.isync.home.path + "/mbsyncrc";
            mode = "400";
          };
          "mbsyncscript" = {
            content = ''
              #!/usr/bin/env bash

            ''
            + all_mbsync_script;
            mode = "500";
          };
          "emailbook" = {
            content = ''
              #!/usr/bin/env sh
              # NOTE: using > https://git.sr.ht/~maxgyver83/emailbook/tree/main/item/emailbook

              searchall() {
                 # show entries with matching alias first
                 searchbyalias "$*"
                 searchbyvalueonly "$*"
              }
              searchbyalias() {
                 grep -i -E "$* :" "$filename" | sed -E 's/^[^:]+:\s*//'
              }
              searchbyvalueonly() {
                 # exclude matches found by searchbyalias
                 grep -i -E -v "$* :" "$filename" | sed -E 's/^[^:]+:\s*//' | grep -i -E "$*"
              }

              filename=${config.sops.secrets."mails/emailbook".path}

              searchall "$*"
            '';
            mode = "500";
          };
        };
      };
  };
}
