# Monitor Mount

## Overview

A VESA-compatible mounting base plate with an extending arm and USB monitor mount. This design features a 110mm square base with rounded vertical edges, four M5 mounting holes in the standard VESA 100x100 pattern, a horizontal arm extending from the right side, a USB mount platform with LCD mounting slots, and zip tie holes for cable management.

## Dimensions

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Global** | | |
| vesa_hole_spacing_mm | 100 | VESA 100x100 standard spacing |
| m5_hole_diameter_mm | 5.5 | M5 screw clearance hole |
| **base_plate** | | |
| base_plate_width_mm | 110 | Width of the base plate (X) |
| base_plate_depth_mm | 110 | Depth of the base plate (Y) |
| base_plate_height_mm | 15 | Height of the base plate (Z) |
| base_plate_edge_radius_mm | 2 | Radius of curved vertical edges |
| **arm** | | |
| arm_length_mm | 130 | Length of the arm (X) |
| arm_width_mm | 80 | Width of the arm (Y) |
| arm_height_mm | 5 | Height of the arm (Z) |
| arm_edge_radius_mm | 2 | Radius of curved edges (front, back, right only) |
| arm_y_offset_mm | 15 | Y offset from base origin (centers arm on base) |
| **usb_mount** | | |
| usb_mount_length_mm | 50 | Length of USB mount (X) |
| usb_mount_width_mm | 110 | Width of USB mount (Y) |
| usb_mount_height_mm | 5 | Height of USB mount (Z) |
| usb_mount_edge_radius_mm | 2 | Radius of curved edges |
| **lcd_mount_hole** | | |
| lcd_mount_hole_length_mm | 30 | Length of slot cutout (X) |
| lcd_mount_hole_width_mm | 5 | Width of slot cutout (Y) |
| lcd_mount_hole_corner_radius_mm | 2 | Inside corner radius |
| lcd_mount_hole_spacing_mm | 100 | Distance between hole centers (Y) |
| **zip_tie_hole** | | |
| zip_tie_hole_length_mm | 2 | Length of slot (X) |
| zip_tie_hole_width_mm | 4 | Width of slot (Y) |
| zip_tie_hole_spacing_mm | 60 | Distance between hole centers (Y) |
| zip_tie_hole_start_x_mm | 130 | First hole X position |
| zip_tie_hole_repeat_mm | 10 | Repeat interval in X |
| zip_tie_hole_end_margin_mm | 20 | Stop distance from end of USB mount |

## Component Diagram

### Top View (looking down, -Z)

```
                                              +Y (back)
                                                 ^
                                                 |
  +--+-------------------+---+--:--:--:--:--:--:-+---:--:--:--[====]----+--+
 /   |                   |   |  :  :  :  :  :  : |   :  :  :           |   \
|    |                   |   |  :  :  :  :  :  : |   :  :  :           |    |
|    o                   o   |  :  :  :  :  :  : |   :  :  :           |    |  y=85
|    |                   |   |                   |   |                  |    |
|    |                   |   |                   |   |                  |    |
|    |         *         |   |       ARM         |   |    USB MOUNT     |    |
|    |                   |   |    (130 x 80)     |   |    (50 x 110)    |    |
|    |                   |   |                   |   |                  |    |
|    o                   o   |  :  :  :  :  :  : |   :  :  :           |    |  y=25
|    |                   |   |  :  :  :  :  :  : |   :  :  :           |    |
 \   |                   |   |  :  :  :  :  :  : |   :  :  :  [====]   |   /
  +--+-------------------+---+--:--:--:--:--:--:-+---:--:--:------------+--+  --> +X (right)
 /                       110 130                 240  |                290
Origin [0,0]                                          270

BASE PLATE: 110 x 110, all corners have 2mm radius
ARM: 130 x 80, starts at x=110, centered in Y (y=15 to y=95)
USB MOUNT: 50 x 110, starts at x=240, full width (y=0 to y=110)
[====] = LCD mount holes (30mm x 5mm slots with 2mm rounded corners)
:  :  = Zip tie holes (2mm x 4mm, every 10mm from x=130 to x=270)
```

### Front View (looking from front, -Y)

```
        +Z (up)
           ^
           |
    15 +---+--+-------------+--+---+
       |  /                    \  |
       | |      BASE PLATE      | |
       | |                      | |
     5 | +----------------------+-+---------------------------+------------------+--+
       | |                      |            ARM              |    USB MOUNT     |   \
     0 +-+----------------------+-----------------------------+------------------+----+-> +X
       0  2                   108 110                        238 240            288  290

  Note: Base plate is 15mm tall, arm and USB mount are 5mm tall at z=0
```

### Side View (looking from right, -X)

```
        +Z (up)
           ^
           |
    15 +---+--+-------------+--+---+
       |  /                    \  |
       | |      BASE PLATE      | |
       | |                      | |
     5 +-+--+---------------+---+-+-+--+
       |   |      ARM       |   | |  |
       |   |                |   | |  | USB MOUNT
     0 +---+-----------------+--+-+--+-+----> +Y (back)
       0   2  15           95 108 110

  Note: USB MOUNT extends full width (y=0 to y=110)
```

### LCD Mount Holes Detail

```
              50mm (usb_mount_length_mm)
        |<------------------------>|

        +--+-----------------------+--+  ---
       /   |        [====]         |   \  ^  y=5 (5mm from edge)
      |    |                       |    | |
      |    |                       |    | |
      |    |                       |    | |
      |    |                       |    | | 100mm spacing
      |    |                       |    | |
      |    |                       |    | |
      |    |                       |    | |
       \   |        [====]         |   /  v  y=105 (5mm from edge)
        +--+-----------------------+--+  ---
                                         110mm (usb_mount_width_mm)

    [====] = LCD mount hole
             30mm long (X) x 5mm wide (Y)
             2mm rounded inside corners
             Centered in X at x=265 (global) or x=25 (local to usb_mount)
             Positions in Y: y=5 and y=105 (global)
```

### VESA Hole Pattern Detail

```
          100mm
    |<------------->|

    o---------------o  ---
    |               |   ^
    |               |   |
    |       +       |  100mm
    |               |   |
    |               |   v
    o---------------o  ---

    + = center of base plate [55, 55, 0]
    o = M5 holes (5.5mm diameter)

    Hole positions (centered on 110x110 base):
      Front-left:  [5, 5, 0]
      Front-right: [105, 5, 0]
      Back-left:   [5, 105, 0]
      Back-right:  [105, 105, 0]
```

## Components

### base_plate

- **Purpose**: Foundation that attaches to VESA mount
- **Position**: Origin [0, 0, 0]
- **Bounding Box**: [0, 0, 0] to [110, 110, 15]
- **Features**:
  - 2mm radius curved vertical edges (all four corners)
  - Flat top and bottom surfaces
  - Four M5 clearance holes in VESA 100x100 pattern

### arm

- **Purpose**: Horizontal extension connecting base plate to USB mount
- **Position**: Origin [110, 15, 0]
- **Bounding Box**: [110, 15, 0] to [240, 95, 5]
- **Features**:
  - 2mm radius curved edges on front, back, and right sides
  - Sharp left edge (attaches flush to base plate)
  - Centered in Y on the base plate
  - Zip tie holes from x=130 to x=230

### usb_mount

- **Purpose**: Platform for mounting USB monitor
- **Position**: Origin [240, 0, 0]
- **Bounding Box**: [240, 0, 0] to [290, 110, 5]
- **Features**:
  - 2mm radius curved edges on front, back, and right sides
  - Sharp left edge (attaches flush to arm)
  - Two LCD mount hole cutouts for securing monitor
  - Zip tie holes from x=240 to x=270

### lcd_mount_holes

- **Purpose**: Slot cutouts for LCD/monitor mounting hardware
- **Quantity**: 2
- **Dimensions**: 30mm x 5mm each
- **Corner Radius**: 2mm (rounded inside corners)
- **Spacing**: 100mm on center
- **Positions** (center points, relative to usb_mount origin):
  - Front hole: [25, 5, 0]
  - Back hole: [25, 105, 0]

### zip_tie_holes

- **Purpose**: Slots for zip ties to secure cables
- **Dimensions**: 2mm (X) x 4mm (Y) each, through full thickness
- **Y Positions**: 60mm on center, at y=25 and y=85 (global)
- **X Range**: x=130 to x=270 (every 10mm)
- **Count**: 15 positions x 2 holes = 30 holes total
- **Distribution**:
  - On arm: x=130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230 (11 positions)
  - On USB mount: x=240, 250, 260, 270 (4 positions)

## Assembly Notes

- **Print orientation**: Bottom surface facing down
- **Recommended infill**: 20-40% depending on load requirements
- **Material**: PLA or PETG recommended
- **Supports**: Not required
- **Layer height**: 0.2mm recommended

## Hardware Required

| Qty | Item | Description |
|-----|------|-------------|
| 4 | M5 x 10mm | VESA mounting screws (length depends on mount) |
| 2 | LCD mounting hardware | For securing USB monitor through slots |

## Changelog

| Date | Change |
|------|--------|
| 2026-01-24 | Added zip tie holes on arm and USB mount (x=130 to x=270, every 10mm) |
| 2026-01-24 | Added USB mount with LCD mount hole cutouts |
| 2026-01-24 | Added arm extending from right side of base plate |
| 2026-01-24 | Initial design - base plate with VESA 100x100 pattern |
