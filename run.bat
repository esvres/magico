@echo off
setlocal EnableDelayedExpansion

set geometry=160x160+41+15

set base=%~dp0base
set inputs=%~dp0inputs
set outputs=%~dp0outputs
set t=%~dp0temp
if not exist %outputs% mkdir %outputs%
if not exist %t% mkdir %t%

set 0=!base!\0.png
set 1=!base!\1.png

for %%i in (!inputs!\*) do (
    echo %%~nxi: converting...

    set x=!inputs!\%%~nxi
    set filenames=

    magick convert "!0!" "!x!" -gravity Center -geometry !geometry! -composite "!1!" -composite !t!\temp.png

    for %%r in (256 64 48 40 32 24 20) do (
        set res=%%rx%%r
        set filename=!t!\temp-%%r.png
        set filenames=!filenames! !filename!
        magick convert !t!\temp.png -scale !res! !filename!
    )
    set filename=!t!\temp-16.png
    set filenames=!filenames! !filename!
    magick convert !x! -scale 16x16 !filename!

    magick convert !filenames! !outputs!\%%~ni.ico
    del !t!\*.png

    echo %%~nxi: done.
)
explorer !outputs!