#!/bin/bash -e

###
#
# Repackage a Windows .exe jdk as a portable .zip file, ready to run
#
# Soren A D <sorend@gmail.com>
#

if [ -z "$1" ]; then
    echo "Syntax: $0 <jdk-something.exe>"
    exit 100
fi

#
JDK_BASE=$(basename "$1" .exe)
JDK_DIR=$(readlink -f $(dirname "$1"))
JDK_ZIP="${JDK_BASE}.zip"
TEMP_DIR="/tmp/unpack-$$"
JDK_PATH="${TEMP_DIR}/${JDK_DIR}"

if [ -e "$JDK_DIR/$JDK_ZIP" ]; then
    echo "$JDK_ZIP: exists."
    exit 101
fi

# unpack installation
echo -n "Unpacking... "
mkdir -p "$TEMP_DIR/pack"
mkdir -p "$TEMP_DIR/JDK_BASE"
7z x -o"$TEMP_DIR/pack" "$1" >/dev/null

if [ -e "$TEMP_DIR/pack/tools.zip" ]; then
	7z x -o"$TEMP_DIR/$JDK_BASE" "$TEMP_DIR/pack/tools.zip" >/dev/null
elif [ -e "$TEMP_DIR/pack/.rsrc/1033/JAVA_CAB10/111" ]; then
	7z x -o"$TEMP_DIR/pack2" "$TEMP_DIR/pack/.rsrc/1033/JAVA_CAB10/111" >/dev/null
	7z x -o"$TEMP_DIR/$JDK_BASE" "$TEMP_DIR/pack2/tools.zip" >/dev/null
else
	echo "Could not find JDK within installer :-("
	exit 102
fi

if [ ! -e "$TEMP_DIR/$JDK_BASE/bin/java.exe" ]; then
	echo "Could not find java.exe after unpacking"
	exit 103
fi

# unpack .packs
find "$TEMP_DIR/$JDK_BASE" -type f -name "*.pack" | while read pf; do
    unpack200 "${pf}" "${pf/.pack/.jar}" && rm "${pf}"
done

# set proper mods
echo -n "Fixing up mods... "
find "$TEMP_DIR/$JDK_BASE" -type d -exec chmod 0775 {} \;
find "$TEMP_DIR/$JDK_BASE" -type f -exec chmod 0664 {} \;
find "$TEMP_DIR/$JDK_BASE" -type f \( -name "*.exe" -o -name "*.dll" \) -exec chmod 0775 {} \;

echo -n "Packing... "
( cd "$TEMP_DIR" && 7z a "$JDK_DIR/$JDK_ZIP" "$JDK_BASE" >/dev/null )
rm -rf "$TEMP_DIR"

echo "Done :-)"

echo "Created $JDK_ZIP"
