import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout
import XMonad.Layout.NoBorders ( noBorders, smartBorders )
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Run(unsafeSpawn)
import XMonad.Util.EZConfig(additionalKeysP)
import System.IO
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ICCCMFocus

myManageHook = manageDocks <+> manageHook defaultConfig
myLayout = avoidStruts $ smartBorders tiled ||| smartBorders (Mirror tiled) ||| noBorders Full
    where
        tiled = Tall nmaster delta tiled_ratio
        nmaster = 1
        delta = 3/100
        tiled_ratio = 1/2

myStartupHook = setWMName "LG3D" -- deek

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/james/.xmobarrc"
    xmonad $ defaultConfig
        { terminal = "gnome-terminal"

        -- something about logging through xmobar
        -- , manageHook = manageDocks <+> manageHook defaultConfig
        , manageHook = myManageHook
        , layoutHook = avoidStruts $ layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "#2aa198" "" . shorten 50
                        , ppCurrent = \s -> xmobarColor "#b58900" "" ("("++s++")")
                        }
        -- something about fullscreen in chrome
        , handleEventHook = fullscreenEventHook

        -- colors
        , borderWidth        = 2
        , focusedBorderColor = "#586e75" -- base01
        , normalBorderColor  = "#002b36" -- base03
        }
        `additionalKeysP`
        [ ("<XF86MonBrightnessDown>" , spawn "xbacklight -10")
        , ("<XF86MonBrightnessUp>"   , spawn "xbacklight +10")
        , ("<XF86AudioRaiseVolume>"  , spawn "amixer -D pulse sset Master 5%+")
        , ("<XF86AudioLowerVolume>"  , spawn "amixer -D pulse sset Master 5%-")
        , ("<XF86AudioMute>"         , spawn "amixer -D pulse sset Master 0%")
        , ("<XF86AudioPlay>"         , spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause && sleep .5" )
        , ( "<XF86AudioNext>"        , spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next && sleep .5" )
        , ( "<XF86AudioPrev>"        , spawn "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous && sleep .5" )

        , ("<Print>"                 , spawn "sleep 0.2; take-screenshot.sh")

        , ("M-b", sendMessage ToggleStruts)
        , ("M-p", spawn "dmenu_run -nb '#93a1a1' -nf '#002b36' -sb '#002b36' -sf '#93a1a1'")

        -- app launchers
        , ("<XF86Search>"            , spawn "chromium-browser")
        , ("<F7>"                    , spawn "spotify")
        ]
