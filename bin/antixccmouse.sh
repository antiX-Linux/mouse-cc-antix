#! /bin/bash

TEXTDOMAINDIR=/usr/share/locale 
TEXTDOMAIN=antixccmouse.sh

export DIALOG=$(cat <<End_of_Text 

<window title="`gettext $"Mouse Options"`" window-position="1">

<vbox>
  <frame>
    <frame `gettext $"Mouse Acceleration"`>
    <checkbox active="false">
      <label>"`gettext $"Change mouse motion"`"</label>
      <variable>MOTION</variable>
      <default>no</default>
      <action>if true enable:ACCEL</action>
      <action>if false disable:ACCEL</action>
      <action>if true enable:THRESH</action>
      <action>if false disable:THRESH</action>
    </checkbox>

    <text use-markup="true" width-chars="20">
	<label>"`gettext $"Acceleration (Multiplier)"`"</label>
	</text>
    <entry>
      <variable>ACCEL</variable>
      <visible>disabled</visible>
    </entry>

	<text use-markup="true" width-chars="20">
	<label>"`gettext $"Threshold (Pixels)"`"</label>
	</text>
    <entry>
      <variable>THRESH</variable>
      <visible>disabled</visible>
    </entry>

    <checkbox active="false">
      <label>"`gettext $"Restore default motion"`"</label>
      <variable>RESTMOTION</variable>
      <default>no</default>
    </checkbox>
    </frame>

    <frame `gettext $"Button Order"`>
    <combobox>
      <variable>HAND</variable>
      <item>`gettext $"No change"`</item>
      <item>`gettext $"Left hand layout"`</item>
      <item>`gettext $"Right hand layout"`</item>
    </combobox>
    </frame>

    <frame `gettext $"Cursor Size"`>
    <checkbox active="false">
      <label>"`gettext $"Change cursor size"`"</label>
      <variable>CURS</variable>
      <default>no</default>
      <action>if true enable:SIZE</action>
      <action>if false disable:SIZE</action>
    </checkbox>
    
    <text use-markup="true" width-chars="20">
	<label>"`gettext $"Size (in pixels)"`"</label>
	</text>
    <entry>
      <variable>SIZE</variable>
      <visible>disabled</visible>
    </entry>

    <checkbox active="false">
      <label>"`gettext $"Restore default size"`"</label>
      <variable>RESTSIZE</variable>
      <default>no</default>
    </checkbox>
    </frame>

    <frame `gettext $"Cursor Theme"`>
    <hbox>
	  <button>
	  <input file>"/usr/share/icons/gTangish-2.0a1/16x16/devices/input-mouse.png"</input>
	  <action>rxvt-unicode -tr -sh 65 -fg white -T "cursor theme" -e su -c "update-alternatives --config x-cursor-theme" &</action>
      <action>yad --title "Mouse Options" --text $"After choosing a new theme, please logout/login to see the changes." &</action>
	  </button>
	  <text use-markup="true" width-chars="20">
	  <label>"`gettext $"Change cursor theme"`"</label>
	  </text>
    </hbox>
    </frame>
  </frame>

  <hbox>
 	<button ok></button>
 	<button cancel></button>
  </hbox>
</vbox>

</window>
End_of_Text
)

I=$IFS; IFS=""
for STATEMENTS in  $(gtkdialog --program DIALOG); do
  eval $STATEMENTS
done
IFS=$I

if [ "$EXIT" = "OK" ] ; then
  if [ "$MOTION" = "true" ] ; then
    xset m $ACCEL $THRESH
    `/usr/local/bin/antixmousexset.pl "$ACCEL" "$THRESH"`
    yad --title $"Mouse Options" --text $"Mouse speed changed."
  fi

  if [ "$RESTMOTION" = "true" ] ; then
    xset m restore
    `/usr/local/bin/antixmousedefault.pl`
    yad --title $"Mouse Options" --text $"Using default mouse speed."
  fi

  if [ "$HAND" = $"Left hand layout" ] ; then
    xmodmap -e 'pointer = 3 2 1 4 5'
    `/usr/local/bin/antixmousexmodmap.pl "3 2 1 4 5"`
    yad --title $"Mouse Options" --text $"Now using left-hand layout."
  else if [ "$HAND" = $"Right hand layout" ] ; then
    xmodmap -e 'pointer = 1 2 3 4 5'
    `/usr/local/bin/antixmousexmodmap.pl "1 2 3 4 5"`
    yad --title $"Mouse Options" --text $"Now using right-hand layout."
  fi
  fi
  
  if [ "$CURS" = "true" ] ; then
    `/usr/local/bin/antixmousesize.pl "$SIZE"`
    yad --title $"Mouse Options" --text $"Cursor size changed. Please logout/login to see changes."
  fi

  if [ "$RESTSIZE" = "true" ] ; then
    `/usr/local/bin/antixmousedefaultsize.pl`
    yad --title $"Mouse Options" --text $"Default cursor size restored. Please logout/login to see changes."
  fi
fi
