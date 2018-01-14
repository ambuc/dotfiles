-- reload with mod-q
-- http://xmonad.org/xmonad-docs/xmonad-contrib/src/XMonad-Hooks-DynamicLog.html#xmobarPP
-- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-DynamicLog.html#g:6
-- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-Loggers.html
-- http://ethanschoonover.com/solarized

import           System.IO
import           XMonad
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ICCCMFocus
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.SetWMName
import           XMonad.Layout
import           XMonad.Layout.NoBorders   (noBorders, smartBorders)
import           XMonad.Util.EZConfig      (additionalKeys, additionalKeysP)
import           XMonad.Util.Loggers
import           XMonad.Util.Run           (spawnPipe, unsafeSpawn)

solBase03  = "#002b36"
solBase02  = "#073642"
solBase01  = "#586e75"
solBase00  = "#657b83"
solBase0   = "#839496"
solBase1   = "#93a1a1"
solBase2   = "#eee8d5"
solBase3   = "#fdf6e3"
solYellow  = "#b58900"
solOrange  = "#cb4b16"
solRed     = "#dc322f"
solMagenta = "#d33682"
solViolet  = "#6c71c4"
solBlue    = "#268bd2"
solCyan    = "#2aa198"
solGreen   = "#859900"

myManageHook = manageDocks <+> manageHook def
myStartupHook = setWMName "LG3D" -- deek

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/j/.xmobarrc"
    xmonad $ def
        { terminal           = "gnome-terminal"
        , manageHook         = myManageHook
        , layoutHook         = avoidStruts $ layoutHook def
        , handleEventHook    = handleEventHook def <+> docksEventHook <+> fullscreenEventHook -- something about fullscreen in chrome
        , borderWidth        = 5
        , focusedBorderColor = solBase01
        , normalBorderColor  = solBase03
        , logHook            = dynamicLogWithPP xmobarPP
            { ppOutput  = hPutStrLn xmproc
            , ppTitle   = xmobarColor solCyan   "" . shorten 50
            , ppCurrent = xmobarColor solYellow ""
            , ppLayout  = xmobarColor solBase1  "" .
                (\ x -> case x of
                          "Tall"        -> "[]="
                          "Mirror Tall" -> "|||"
                          "Full"        -> "[ ]"
                          _             -> x
                )
            , ppSep     = xmobarColor solBase01 "" " | "
            , ppWsSep   = " "
            , ppOrder   = \(ws:l:t:x) -> [ws,l]++x++[t]
            }
        }

        `additionalKeysP`
        
        -- brightness
        [ ("<XF86MonBrightnessDown>" , spawn "xbacklight -10")
        , ("<XF86MonBrightnessUp>"   , spawn "xbacklight +10")
        -- music
        , ("<XF86AudioPlay>" , spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause && sleep .5" )
        , ("<XF86AudioNext>" , spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next      && sleep .5" )
        , ("<XF86AudioPrev>" , spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous  && sleep .5" )
        -- volume
        , ("<XF86AudioRaiseVolume>" , spawn "amixer -D pulse sset Master 5%+")
        , ("<XF86AudioLowerVolume>" , spawn "amixer -D pulse sset Master 5%-")
        , ("<XF86AudioMute>"        , spawn "amixer -D pulse sset Master 0% ")
        -- xmonad launchers
        , ("M-b" , sendMessage ToggleStruts)
        , ("M-p" , spawn "dmenu_run -nf '#93a1a1' -nb '#002b36' -sf '#002b36' -sb '#93a1a1'")
        , ("M-i" , spawn "wicd-gtk -n")
        , ("M-x" , spawn "xautolock -locknow")
        -- app launchers
        , ( "<XF86Search>"     , spawn "google-chrome-stable")
        , ( "<XF86HomePage>"   , spawn "google-chrome-stable")
        , ( "<F7>"             , spawn "spotify")
        , ( "<XF86Calculator>" , spawn "spotify")
        ]

-- MICROSOFT SCULPT KEYBOARD KEYBINDINGS
-- F1         XF86HomePage
-- F2                   Mod4 + Super_L
-- F3         Control + Mod4 + Control_L
-- F4         Control + Mod4 + Control_L
-- F5         Shift   + Mod4 + Shift_L
-- F6         Alt     + Mod4 + Alt_L
-- F7         Control + Mod4 + Control_L
-- F8                   Mod4 + Super_L
-- ScrLk      Scroll Lock
-- Pause      Pause
-- Calculator XF86Calculator
