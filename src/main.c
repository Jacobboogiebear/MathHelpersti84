#include <graphx.h>
#include <ti/getcsc.h>
#include "gfx/gfx.h"

int main()
{
    gfx_Begin();

    gfx_SetPalette(global_palette, sizeof_global_palette, 0);
    gfx_SetTransparentColor(1);
    gfx_TransparentSprite_NoClip(selector, 0, 0);
    
    while (!os_GetCSC());
    gfx_End();
    return 0;
}