-- http://xmonad.org/xmonad-docs/xmonad-contrib/src/XMonad-Hooks-DynamicLog.html#xmobarPP
-- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Hooks-DynamicLog.html#g:6
-- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-Loggers.html
-- http://ethanschoonover.com/solarized
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout
import XMonad.Layout.NoBorders ( noBorders, smartBorders )
import XMonad.Util.Loggers
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
    xmproc <- spawnPipe "/usr/bin/xmobar /home/j/.xmobarrc"
    xmonad $ defaultConfig
        { terminal = "gnome-terminal"

        -- something about logging through xmobar
        -- , manageHook = manageDocks <+> manageHook defaultConfig
        , manageHook = myManageHook
        , layoutHook = avoidStruts $ layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "#2aa198" "" . shorten 50
                        --, ppCurrent = \s -> xmobarColor "#b58900" "" ("("++s++")")
                        , ppCurrent = \s -> xmobarColor "#b58900" "" s
                        , ppLayout = xmobarColor "#93a1a1" "" .
                            (\ x -> case x of
                                      "Tall"          -> "[]="
                                      "Mirror Tall"   -> "|||"
                                      "Full"          -> "[ ]"
                                      _               -> x
                            )
                        , ppSep =  xmobarColor "#586e75" "" " | "
                        , ppWsSep = " "
                        , ppExtras = 
                          [
                            wrapL "vol: " "%" $ 
                            xmobarColorL "#cb4b16" "" $ 
                            logCmd "amixer -D pulse sget Master | tail -n 1 | mawk '{ print(substr($5,2,index($5,\"%\")-2) ) }' "
                          , wrapL "bri: " "%" $ 
                            xmobarColorL "#dc322f" "" $ 
                            logCmd "xbacklight -get | mawk '{print(substr($1,1,length($1)-7) )}'"
                          ]
                        , ppOrder = \(ws:l:t:x) -> [ws,l]++x++[t]
                        }
        -- something about fullscreen in chrome
        , handleEventHook = handleEventHook def <+> docksEventHook <+> fullscreenEventHook

        -- colors
        , borderWidth        = 1
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
        , ("<XF86Search>"            , spawn "google-chrome-stable")
        , ("<F7>"                    , spawn "spotify")
        ]
