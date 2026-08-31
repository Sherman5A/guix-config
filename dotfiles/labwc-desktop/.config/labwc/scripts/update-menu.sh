#!/bin/sh
#
# This is an example wrapper script for `labwc-menu-generator` which aims to
# demonstrate how a user can customize the menu with entries before/after the
# directories and to ignore certain applications.
#
# `labwc-menu-generator` does the hard work of parsing system application
# .desktop files and categorizing them into directories. Technically it would
# of course be possible to add options for further customisation such as what
# is achieved by this script, but that would mostly likely result in a couple
# of undesireable outcomes:
#
# 1. Significantly extend project scope to cater for unusual and obscure
#    requirements (including translations), thus making it harder to maintain
#    and less likely to survive in the long-run.
#
# 2. Make the user-interface disproportionately more complicated compared with
#    writing a simple wrapper script.
#

printf '%b\n' '<?xml version="1.0" encoding="UTF-8"?>
<openbox_menu>
<menu id="client-menu">
  <item label="Minimize">
    <action name="Iconify" />
  </item>
  <item label="Maximize">
    <action name="ToggleMaximize" />
  </item>
  <item label="Fullscreen">
    <action name="ToggleFullscreen" />
  </item>
  <item label="Decorations">
    <action name="ToggleDecorations" />
  </item>
  <item label="AlwaysOnTop">
    <action name="ToggleAlwaysOnTop" />
  </item>
  <!--
    Any menu with the id "workspaces" will be hidden
    if there is only a single workspace available.
  -->
  <menu id="workspaces" label="Workspace">
    <item label="Move left">
      <action name="SendToDesktop" to="left" />
      <action name="GoToDesktop" to="left" />
    </item>
    <item label="Move right">
      <action name="SendToDesktop" to="right" />
      <action name="GoToDesktop" to="right" />
    </item>
  </menu>
  <item label="Close">
    <action name="Close" />
  </item>
</menu>

<menu id="root-menu">
  <item label="Terminal">
    <action name="Execute" command="footclient" />
  </item>
  <item label="Firefox">
    <action name="Execute" command="firefox-bin" />
  </item>
  <!--
  <item label="File Manager">
    <action name="None">
  </item>
  -->
</menu>

<menu id="systemMenu" label="Control Menu">
  <menu id="goto" label="Go To">
    <item label="Workspace 1">
      <action name="GoToDesktop" to="1" />
    </item>
    <item label="Workspace 2">
      <action name="GoToDesktop" to="2" />
    </item>
    <item label="Workspace 3">
      <action name="GoToDesktop" to="3" />
    </item>
  </menu>
  <menu id="applications" label="Applications">
 ' 

# -b|--bare    Disables header and footer
# -i|--ignore  Excludes all .desktop files listed at the top of this file
labwc-menu-generator -b

printf '%b\n' '
  </menu>
  <item label="Reconfigure">
    <action name="Reconfigure" />
  </item>
  <item label="Quit">
    <action name="Exit" />
  </item>
  <item label="Suspend">
    <action name="Execute" command="loginctl suspend" />
  </item>
  <item label="Poweroff">
    <action name="Execute" command="loginctl poweroff" />
  </item>
</menu>
</openbox_menu>
'
