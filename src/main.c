#include <graphx.h>
#include <fontlibc.h>
#include <ti/getcsc.h>
#include "gfx/gfx.h"
#include "gameplayfont.h"

int main()
{
    gfx_Begin();

    gfx_SetPalette(global_palette, sizeof_global_palette, 0);
    gfx_SetTransparentColor(2);
    fontlib_SetFont(gameplay_font, (fontlib_load_options_t)NULL);
    fontlib_ClearWindow();

    gfx_SetColor(0);
    gfx_FillRectangle(0, 0, 320, 30);

    fontlib_SetColors(1, 0);
    fontlib_SetWindow(94, 6, 160, 12);
    fontlib_SetCursorPosition(94, 6);
    fontlib_DrawString("Hello there!");
    gfx_TransparentSprite_NoClip(selector, 2, 0);

    while (!os_GetCSC());
    gfx_End();
    return 0;
}