#include <fontlibc.h>
#include "gameplayfont.h"

static const uint8_t gameplay_font_data[] = {
	#include "fonts/gameplayfont.inc"
};
const fontlib_font_t *gameplay_font = (fontlib_font_t *)gameplay_font_data;