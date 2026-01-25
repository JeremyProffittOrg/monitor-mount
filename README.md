# Monitor Mount

OpenSCAD designs for a VESA mount spacer with an upper bar and attachment points for a USB monitor. Designs are intended for 3D printing.

## Designs

### Monitor Mount Base Plate

| Front View | Rear View |
|------------|-----------|
| ![Front](https://github.com/JeremyProffitt/monitor-mount/releases/latest/download/monitor-mount_front.png) | ![Rear](https://github.com/JeremyProffitt/monitor-mount/releases/latest/download/monitor-mount_rear.png) |

A VESA-compatible mounting base plate (110mm x 110mm x 15mm) with four M5 mounting holes in the standard VESA 100x100 pattern. Features:
- Horizontal arm (130mm x 80mm x 5mm) extending from the right side
- USB mount platform (50mm x 110mm x 5mm) with two LCD mounting slots (30mm x 5mm, 100mm on center, 2mm rounded corners)
- Zip tie holes (2mm x 4mm) for cable management, repeating every 10mm from x=130 to x=270

**Documentation**: [monitor-mount.md](monitor-mount.md)

**Download STL**: [monitor-mount.stl](https://github.com/JeremyProffitt/monitor-mount/releases/latest/download/monitor-mount.stl)

## Building

### Prerequisites

- [OpenSCAD](https://openscad.org/) installed and available in PATH

### Generate STL and Images

**Linux/macOS:**
```bash
./build.sh
```

**Windows:**
```cmd
build.bat
```

Output files are generated in the `build/` directory.

## License

[Add license information here]
