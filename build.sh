#!/bin/bash
#
# Build script for OpenSCAD designs
# Generates STL files and PNG images for all .scad files
#

set -e

# Configuration
BUILD_DIR="build"
OPENSCAD="openscad"
IMG_WIDTH=800
IMG_HEIGHT=600

# Camera settings for views (translate_x,y,z, rot_x,y,z, distance)
# Using --autocenter and --viewall to automatically fit entire model
# Front view: 55° elevation, 45° azimuth
CAMERA_FRONT="0,0,0,55,0,45,0"
# Rear view: 55° elevation, 225° azimuth (opposite side)
CAMERA_REAR="0,0,0,55,0,225,0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print colored status
info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if OpenSCAD is installed
check_openscad() {
    if ! command -v "$OPENSCAD" &> /dev/null; then
        # Try common installation paths
        if [[ -x "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD" ]]; then
            OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
        elif [[ -x "/usr/bin/openscad" ]]; then
            OPENSCAD="/usr/bin/openscad"
        else
            error "OpenSCAD not found. Please install OpenSCAD and ensure it's in your PATH."
            exit 1
        fi
    fi
    info "Using OpenSCAD: $OPENSCAD"
}

# Create build directory
setup_build_dir() {
    if [[ -d "$BUILD_DIR" ]]; then
        info "Cleaning build directory..."
        rm -rf "$BUILD_DIR"/*
    else
        info "Creating build directory..."
        mkdir -p "$BUILD_DIR"
    fi
}

# Generate STL from SCAD file
generate_stl() {
    local scad_file="$1"
    local base_name=$(basename "$scad_file" .scad)
    local stl_file="$BUILD_DIR/${base_name}.stl"

    info "Generating STL: $stl_file"
    "$OPENSCAD" -o "$stl_file" "$scad_file"
}

# Generate PNG images from SCAD file
generate_images() {
    local scad_file="$1"
    local base_name=$(basename "$scad_file" .scad)
    local front_img="$BUILD_DIR/${base_name}_front.png"
    local rear_img="$BUILD_DIR/${base_name}_rear.png"

    info "Generating front view: $front_img"
    "$OPENSCAD" -o "$front_img" \
        --autocenter --viewall \
        --camera="$CAMERA_FRONT" \
        --imgsize="$IMG_WIDTH,$IMG_HEIGHT" \
        --colorscheme="Tomorrow Night" \
        "$scad_file"

    info "Generating rear view: $rear_img"
    "$OPENSCAD" -o "$rear_img" \
        --autocenter --viewall \
        --camera="$CAMERA_REAR" \
        --imgsize="$IMG_WIDTH,$IMG_HEIGHT" \
        --colorscheme="Tomorrow Night" \
        "$scad_file"
}

# Main build process
main() {
    info "Starting build process..."

    check_openscad
    setup_build_dir

    # Find all .scad files (excluding libraries/includes if in subdirectories named 'lib' or 'include')
    local scad_files=$(find . -name "*.scad" -not -path "./lib/*" -not -path "./include/*" -not -path "./$BUILD_DIR/*")

    if [[ -z "$scad_files" ]]; then
        warn "No .scad files found in the current directory."
        exit 0
    fi

    local count=0
    while IFS= read -r scad_file; do
        info "Processing: $scad_file"
        generate_stl "$scad_file"
        generate_images "$scad_file"
        ((count++))
    done <<< "$scad_files"

    info "Build complete! Processed $count file(s)."
    info "Output directory: $BUILD_DIR/"

    # List generated files
    echo ""
    info "Generated files:"
    ls -la "$BUILD_DIR/"
}

# Run main function
main "$@"
