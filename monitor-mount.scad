/**
 * Monitor Mount Base Plate
 *
 * A VESA-compatible mounting base for monitor attachment.
 *
 * Coordinate System:
 *   X = Width  (positive = right)
 *   Y = Depth  (positive = back/away from viewer)
 *   Z = Height (positive = up)
 *
 * Origin: Front-left corner of base plate, at ground level
 */

// ===========================================
// DIMENSIONS (all values in millimeters)
// ===========================================

// --- Global / Shared Dimensions ---
vesa_hole_spacing_mm   = 100;   // VESA 100x100 standard
m5_hole_diameter_mm    = 5.5;   // M5 screw clearance hole

// --- base_plate dimensions ---
base_plate_width_mm    = 110;   // X dimension
base_plate_depth_mm    = 110;   // Y dimension
base_plate_height_mm   = 15;    // Z dimension
base_plate_edge_radius_mm = 2;  // Radius of curved edges on sides

// --- arm dimensions ---
arm_length_mm          = 130;   // X dimension (extends right from base)
arm_width_mm           = 80;    // Y dimension
arm_height_mm          = 5;     // Z dimension
arm_edge_radius_mm     = 2;     // Radius of curved edges (front, back, right only)
arm_y_offset_mm        = (base_plate_depth_mm - arm_width_mm) / 2;  // Centers arm on base (15mm)

// --- usb_mount dimensions ---
usb_mount_length_mm    = 50;    // X dimension (extends right from arm)
usb_mount_width_mm     = 110;   // Y dimension (same as base plate)
usb_mount_height_mm    = 5;     // Z dimension
usb_mount_edge_radius_mm = 2;   // Radius of curved edges

// --- lcd_mount_hole dimensions ---
lcd_mount_hole_length_mm    = 30;   // X dimension (slot length)
lcd_mount_hole_width_mm     = 5;    // Y dimension (slot width)
lcd_mount_hole_corner_radius_mm = 2;  // Inside corner radius
lcd_mount_hole_spacing_mm   = 100;  // Distance between hole centers in Y
lcd_mount_hole_y_offset_mm  = (usb_mount_width_mm - lcd_mount_hole_spacing_mm) / 2;  // 5mm from edges

// --- zip_tie_hole dimensions ---
zip_tie_hole_length_mm      = 2;    // X dimension (slot length)
zip_tie_hole_width_mm       = 4;    // Y dimension (slot width)
zip_tie_hole_spacing_mm     = 60;   // Distance between hole centers in Y
zip_tie_hole_start_x_mm     = 130;  // First hole X position (from origin)
zip_tie_hole_repeat_mm      = 10;   // Repeat interval in X
zip_tie_hole_end_margin_mm  = 20;   // Stop this far from end of usb_mount
zip_tie_hole_center_y_mm    = base_plate_depth_mm / 2;  // Center Y (55mm)

// ===========================================
// COMPONENT INDEX
// ===========================================
/**
 * | Component        | Origin [X,Y,Z]  | Size [W,D,H]      | Attaches To      |
 * |------------------|-----------------|-------------------|------------------|
 * | base_plate       | [0, 0, 0]       | [110, 110, 15]    | (ground/mount)   |
 * | arm              | [110, 15, 0]    | [130, 80, 5]      | base_plate right |
 * | usb_mount        | [240, 0, 0]     | [50, 110, 5]      | arm right        |
 * | zip_tie_holes    | [130, 25/85, 0] | [2, 4, 5] each    | arm, usb_mount   |
 *
 */

// ===========================================
// CONNECTION INTERFACES
// ===========================================

// Center point of the base plate (for VESA hole pattern)
function base_plate_center() = [
    base_plate_width_mm / 2,
    base_plate_depth_mm / 2,
    0
];

// VESA hole positions (centered on base plate)
function vesa_hole_positions() = [
    base_plate_center() + [-vesa_hole_spacing_mm/2, -vesa_hole_spacing_mm/2, 0],
    base_plate_center() + [ vesa_hole_spacing_mm/2, -vesa_hole_spacing_mm/2, 0],
    base_plate_center() + [-vesa_hole_spacing_mm/2,  vesa_hole_spacing_mm/2, 0],
    base_plate_center() + [ vesa_hole_spacing_mm/2,  vesa_hole_spacing_mm/2, 0]
];

// Arm attachment point (right edge of base plate, centered in Y)
function arm_attachment_point() = [
    base_plate_width_mm,
    arm_y_offset_mm,
    0
];

// USB mount attachment point (right edge of arm, aligned with base Y origin)
function usb_mount_attachment_point() = [
    base_plate_width_mm + arm_length_mm,
    0,
    0
];

// LCD mount hole positions (centered on USB mount in X, spaced in Y)
function lcd_mount_hole_positions() = [
    [usb_mount_length_mm / 2, lcd_mount_hole_y_offset_mm, 0],
    [usb_mount_length_mm / 2, usb_mount_width_mm - lcd_mount_hole_y_offset_mm, 0]
];

// Zip tie hole end X position
zip_tie_hole_end_x_mm = base_plate_width_mm + arm_length_mm + usb_mount_length_mm - zip_tie_hole_end_margin_mm;

// Number of zip tie hole positions
zip_tie_hole_count = floor((zip_tie_hole_end_x_mm - zip_tie_hole_start_x_mm) / zip_tie_hole_repeat_mm) + 1;

// Zip tie hole Y positions (two holes per X position, 60mm apart centered on arm)
function zip_tie_hole_y_positions() = [
    zip_tie_hole_center_y_mm - zip_tie_hole_spacing_mm / 2,  // 25mm
    zip_tie_hole_center_y_mm + zip_tie_hole_spacing_mm / 2   // 85mm
];

// ===========================================
// MODULES
// ===========================================

/**
 * Base Plate Body (with rounded side edges)
 *
 * Creates the main body with 2mm radius curves on the four
 * vertical edges (sides), but flat top and bottom surfaces.
 *
 * POSITION:
 *   Origin: [0, 0, 0] (front-left-bottom corner)
 *
 * BOUNDING BOX:
 *   Min: [0, 0, 0]
 *   Max: [110, 110, 15]
 *   Size: [110, 110, 15]
 */
module base_plate_body() {
    // Use hull of four cylinders at corners to create rounded vertical edges
    // This gives us curved sides but flat top/bottom
    r = base_plate_edge_radius_mm;

    hull() {
        // Front-left corner
        translate([r, r, 0])
            cylinder(h = base_plate_height_mm, r = r, $fn = 32);

        // Front-right corner
        translate([base_plate_width_mm - r, r, 0])
            cylinder(h = base_plate_height_mm, r = r, $fn = 32);

        // Back-left corner
        translate([r, base_plate_depth_mm - r, 0])
            cylinder(h = base_plate_height_mm, r = r, $fn = 32);

        // Back-right corner
        translate([base_plate_width_mm - r, base_plate_depth_mm - r, 0])
            cylinder(h = base_plate_height_mm, r = r, $fn = 32);
    }
}

/**
 * VESA Mounting Holes
 *
 * Creates four M5 clearance holes in VESA 100x100 pattern,
 * centered on the base plate.
 */
module vesa_holes() {
    positions = vesa_hole_positions();

    for (pos = positions) {
        translate(pos)
            cylinder(h = base_plate_height_mm, d = m5_hole_diameter_mm, $fn = 32);
    }
}

/**
 * Base Plate
 *
 * Complete base plate with VESA mounting holes.
 *
 * POSITION:
 *   Origin: [0, 0, 0] (front-left-bottom corner)
 *
 * BOUNDING BOX:
 *   Min: [0, 0, 0]
 *   Max: [110, 110, 15]
 *   Size: [110, 110, 15]
 *
 * ALIGNMENT:
 *   X: Starts at origin
 *   Y: Starts at origin
 *   Z: Sits on ground plane (z = 0)
 *
 * CONNECTS TO:
 *   - VESA mount: bottom surface with 4x M5 holes
 *   - arm: right edge at Y center
 */
module base_plate() {
    difference() {
        base_plate_body();
        vesa_holes();
    }
}

/**
 * Arm Body
 *
 * Creates the arm body with 2mm radius curves on front, back,
 * and right edges. Left edge is straight (attaches to base plate).
 *
 * Local origin at [0, 0, 0] - positioned by arm() module.
 */
module arm_body() {
    r = arm_edge_radius_mm;
    eps = 0.001;  // Small value for sharp corners

    hull() {
        // Left edge - sharp corners (no radius)
        // Front-left corner
        translate([0, 0, 0])
            cube([eps, eps, arm_height_mm]);

        // Back-left corner
        translate([0, arm_width_mm - eps, 0])
            cube([eps, eps, arm_height_mm]);

        // Right edge - rounded corners (2mm radius)
        // Front-right corner
        translate([arm_length_mm - r, r, 0])
            cylinder(h = arm_height_mm, r = r, $fn = 32);

        // Back-right corner
        translate([arm_length_mm - r, arm_width_mm - r, 0])
            cylinder(h = arm_height_mm, r = r, $fn = 32);
    }
}

/**
 * Arm
 *
 * Horizontal arm extending from the right side of the base plate.
 *
 * POSITION:
 *   Origin: [110, 15, 0] (front-left-bottom corner of arm)
 *
 * BOUNDING BOX:
 *   Min: [110, 15, 0]
 *   Max: [240, 95, 5]
 *   Size: [130, 80, 5]
 *
 * ALIGNMENT:
 *   X: Starts at right edge of base_plate (x = 110)
 *   Y: Centered on base_plate (15mm from front edge)
 *   Z: Sits on ground plane (z = 0)
 *
 * CONNECTS TO:
 *   - base_plate: left edge flush with base_plate right edge
 *   - usb_mount: right edge connects to usb_mount left edge
 *
 * FEATURES:
 *   - Zip tie holes every 10mm from x=130 to x=240
 */
module arm() {
    translate(arm_attachment_point())
        difference() {
            arm_body();
            zip_tie_holes_arm();
        }
}

/**
 * USB Mount Body
 *
 * Creates the USB mount body with 2mm radius curves on front, back,
 * and right edges. Left edge is straight (attaches to arm).
 *
 * Local origin at [0, 0, 0] - positioned by usb_mount() module.
 */
module usb_mount_body() {
    r = usb_mount_edge_radius_mm;
    eps = 0.001;  // Small value for sharp corners

    hull() {
        // Left edge - sharp corners (no radius)
        // Front-left corner
        translate([0, 0, 0])
            cube([eps, eps, usb_mount_height_mm]);

        // Back-left corner
        translate([0, usb_mount_width_mm - eps, 0])
            cube([eps, eps, usb_mount_height_mm]);

        // Right edge - rounded corners (2mm radius)
        // Front-right corner
        translate([usb_mount_length_mm - r, r, 0])
            cylinder(h = usb_mount_height_mm, r = r, $fn = 32);

        // Back-right corner
        translate([usb_mount_length_mm - r, usb_mount_width_mm - r, 0])
            cylinder(h = usb_mount_height_mm, r = r, $fn = 32);
    }
}

/**
 * LCD Mount Hole
 *
 * Creates a single slot cutout with rounded inside corners.
 * 30mm long (X) x 5mm wide (Y) with 2mm corner radius.
 *
 * Local origin at center of hole.
 */
module lcd_mount_hole() {
    r = lcd_mount_hole_corner_radius_mm;
    // Effective inner dimensions after accounting for corner radius
    inner_length = lcd_mount_hole_length_mm - 2 * r;
    inner_width = lcd_mount_hole_width_mm - 2 * r;

    // Use hull of 4 cylinders at corners for rounded rectangle
    hull() {
        // Front-left corner
        translate([-inner_length/2, -inner_width/2, 0])
            cylinder(h = usb_mount_height_mm, r = r, $fn = 32);

        // Front-right corner
        translate([inner_length/2, -inner_width/2, 0])
            cylinder(h = usb_mount_height_mm, r = r, $fn = 32);

        // Back-left corner
        translate([-inner_length/2, inner_width/2, 0])
            cylinder(h = usb_mount_height_mm, r = r, $fn = 32);

        // Back-right corner
        translate([inner_length/2, inner_width/2, 0])
            cylinder(h = usb_mount_height_mm, r = r, $fn = 32);
    }
}

/**
 * LCD Mount Holes
 *
 * Creates both LCD mount hole cutouts, positioned symmetrically
 * on the USB mount.
 */
module lcd_mount_holes() {
    positions = lcd_mount_hole_positions();

    for (pos = positions) {
        translate(pos)
            lcd_mount_hole();
    }
}

/**
 * Zip Tie Hole
 *
 * Creates a single rectangular slot for zip ties.
 * 2mm long (X) x 4mm wide (Y), through full material thickness.
 *
 * Local origin at center of hole.
 */
module zip_tie_hole(height) {
    translate([-zip_tie_hole_length_mm/2, -zip_tie_hole_width_mm/2, 0])
        cube([zip_tie_hole_length_mm, zip_tie_hole_width_mm, height]);
}

/**
 * Zip Tie Holes for Arm
 *
 * Creates all zip tie holes that fall within the arm's X range.
 * Holes are positioned in global coordinates, then translated
 * to arm's local coordinate system.
 *
 * X range on arm: 130 to 240 (local: 20 to 130)
 */
module zip_tie_holes_arm() {
    y_positions = zip_tie_hole_y_positions();
    arm_start_x = base_plate_width_mm;  // 110
    arm_end_x = base_plate_width_mm + arm_length_mm;  // 240

    for (i = [0 : zip_tie_hole_count - 1]) {
        x_global = zip_tie_hole_start_x_mm + i * zip_tie_hole_repeat_mm;

        // Only create holes within arm's X range
        if (x_global >= arm_start_x && x_global < arm_end_x) {
            x_local = x_global - arm_start_x;

            for (y_global = y_positions) {
                y_local = y_global - arm_y_offset_mm;

                translate([x_local, y_local, 0])
                    zip_tie_hole(arm_height_mm);
            }
        }
    }
}

/**
 * Zip Tie Holes for USB Mount
 *
 * Creates all zip tie holes that fall within the USB mount's X range.
 * Holes are positioned in global coordinates, then translated
 * to USB mount's local coordinate system.
 *
 * X range on usb_mount: 240 to 270 (local: 0 to 30)
 */
module zip_tie_holes_usb_mount() {
    y_positions = zip_tie_hole_y_positions();
    usb_start_x = base_plate_width_mm + arm_length_mm;  // 240

    for (i = [0 : zip_tie_hole_count - 1]) {
        x_global = zip_tie_hole_start_x_mm + i * zip_tie_hole_repeat_mm;

        // Only create holes within usb_mount's X range
        if (x_global >= usb_start_x && x_global <= zip_tie_hole_end_x_mm) {
            x_local = x_global - usb_start_x;

            for (y_global = y_positions) {
                // Y is in global coords for usb_mount (starts at y=0)
                translate([x_local, y_global, 0])
                    zip_tie_hole(usb_mount_height_mm);
            }
        }
    }
}

/**
 * USB Mount
 *
 * Mounting platform at the end of the arm for USB monitor attachment.
 * Includes two LCD mount hole cutouts and zip tie holes.
 *
 * POSITION:
 *   Origin: [240, 0, 0] (front-left-bottom corner of usb_mount)
 *
 * BOUNDING BOX:
 *   Min: [240, 0, 0]
 *   Max: [290, 110, 5]
 *   Size: [50, 110, 5]
 *
 * ALIGNMENT:
 *   X: Starts at right edge of arm (x = 240)
 *   Y: Aligned with base_plate (y = 0)
 *   Z: Sits on ground plane (z = 0)
 *
 * CONNECTS TO:
 *   - arm: left edge flush with arm right edge
 *
 * FEATURES:
 *   - Two LCD mount holes (30mm x 5mm with 2mm rounded corners)
 *   - Holes centered in X, spaced 100mm apart in Y
 *   - Zip tie holes every 10mm from x=240 to x=270
 */
module usb_mount() {
    translate(usb_mount_attachment_point())
        difference() {
            usb_mount_body();
            lcd_mount_holes();
            zip_tie_holes_usb_mount();
        }
}

// ===========================================
// DEBUG / VISUALIZATION
// ===========================================

// Render coordinate axes at origin (length = 50mm)
module debug_axes(length = 50) {
    color("red")   cylinder(h = length, r = 1, $fn = 16);           // Z-axis
    color("green") rotate([0, 90, 0]) cylinder(h = length, r = 1, $fn = 16);  // X-axis
    color("blue")  rotate([-90, 0, 0]) cylinder(h = length, r = 1, $fn = 16); // Y-axis
}

// Show bounding box for a component (transparent)
module debug_bounds(min_pt, max_pt) {
    color("yellow", 0.2)
        translate(min_pt)
            cube([max_pt[0] - min_pt[0], max_pt[1] - min_pt[1], max_pt[2] - min_pt[2]]);
}

// Color-coded assembly for visual debugging
module assembly_colored() {
    color("gray") base_plate();
    color("blue") arm();
    color("green") usb_mount();
}

// Exploded view - separates components along X axis
module assembly_exploded(separation = 30) {
    translate([0, 0, 0]) base_plate();
    translate([separation, 0, 0]) arm();
    translate([separation * 2, 0, 0]) usb_mount();
}

// ===========================================
// ASSEMBLY
// ===========================================

/**
 * Main Assembly
 *
 * Combines all components in their final positions.
 * Use assembly_colored() or assembly_exploded() for debugging.
 */
module assembly() {
    base_plate();
    arm();
    usb_mount();
}

// Default render
assembly();
