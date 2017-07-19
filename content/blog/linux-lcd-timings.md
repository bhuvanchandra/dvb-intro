+++
date = "2016-02-02T11:55:43+08:00"
title = "Understanding Linux LCD display timings"

+++

### Mapping LCD/TFT display timings to Linux Kernel data structures###
***

_**Most of the LCD/TFT display datasheets provide the following timing information:**_

* **Horizontal Back Porch(HBP)**: Number of pixel clk pulses between HSYNC signal and the first valid pixel data.
* **Horizontal Front porch(HFP)**: Number of pixel clk pulses between the last valid pixel data in the line and the next hsync pulse.
* **Vertical back porch(VBP)**: Number of lines (HSYNC pulses) from a VSYNC signal to the first valid line.
* **Vertical Front Porch(VFP)**: Number of lines (HSYNC pulses) between the last valid line of the frame and the next VSYNC pulse.
* **VSYNC pulse width**: Number of HSYNC pulses when a VSYNC signal is active.
* **HSYNC pulse width**: Number of pixel clk pulses when a HSYNC signal is active.
* **Active frame width**: Horizontal resolution.
* **Active frame height**: Vertical resolution.
* **Screen width**: Number of pixel clk between the last HSYNC and the new HSYNC.
Screen width = Active frame width + HBP + HFP
* **Screen height**: Number of lines between VSYNC pulses.
Screen Height = Active frame height + VBP + VFP
* **VSYNC polarity**: Value of VSYNC to indicate the start of a new frame (active LOW or HIGH)
* **HSYNC polarity**: Value of HSYNC to indicate the start of a new line (active LOW or HIGH).

_**In some datasheets they may provide horizontal and vertical blanking period:**_
```
Horizontal Blanking Period: HSYNC + HFP + HBP
Vertical Blanking Period: VSYNC + VFP + VBP
```
e.g.
If Vertical blanking period was given with a typical value of 150, one can choose:
```
VSYNC:90
VFP:45
VBP:45
```
All the LCD/TFT display related timings information values obtained from display datasheet need to be passed/mapped to the respective driver in the kernel which is responsible for display.

_**Adding timings to kernel data structure:**_

If using _modedb_ for video modes one need to map the _fb_videomode_ data structure with appropriate LCD timing values obtained from datasheet.

```c
struct fb_videomode {
	const char *name;   // Descriptive name
	u32 refresh;        // Refresh rate in Hz
	u32 xres;           // resolution in x
	u32 yres;           // resolution in y
	u32 pixclock;       // Pixel clock in picoseconds
	u32 left_margin;    // Horizontal Back Porch
	u32 right_margin;   // Horizontal Front Porch
	u32 upper_margin;   // Vertical Back Porch
	u32 lower_margin;   // Vertical Front Porch
	u32 hsync_len;      // Hsync pulse width
	u32 vsync_len;      // Vsync pulse width
	u32 sync;           // Polarity on the Data Enable
	u32 vmode;          // Video Mode
	u32 flag;           // Usually 0
};
```

The naming convention in data structure and the data sheet timing values are slightly different.

_The following picture can be used as reference while converting:_

![lcd-timings](https://github.com/bhuvanchandra/images-repo/raw/master/images-linux-display-timings/101353-linux_lcd_timing.jpg)

* **xres**: Number of horizontal pixels, resolution in the x axis.
* **yres**: Number of vertical lines or pixels, resolution in the y axis.
* **pixclock**: Pixel clock, dot clock or just clock, usually in MHz. It needs to be entered in picoseconds (pixclock in ps= 10 ^(-12) / dot-clock in MHz)
* **left margin**: This is Horizontal Back Porch (HBP).
* **right margin**: This is Horizontal Front porch (HFP).
* **upper margin**: This is Vertical back porch (VBP).
* **lower margin**: This is Vertical Front Porch (VFP).
* **hsync length**: This is HSYNC pulse width.
* **vsync length**: This is VSYNC pulse width.
* **sync**: This refers to the clock polarity.
* **vmode**: This is the video mode. FB_VMODE_INTERLACED, FB_VMODE_NONINTERLACED etc.
* **flag**: Leave at FB_MODE_UNKNOWN or FB_MODE_IS_DETAILED.
