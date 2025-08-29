# BinDiff & BinExport Installer for IDA Pro 9.x

This repository provides a Windows batch script to automatically build  
[BinExport](https://github.com/google/binexport) and  
[BinDiff](https://github.com/google/bindiff) with IDA Pro 9.x SDK support.

## Requirements

Before running the installer script, make sure the following tools are installed and available in `PATH`:

- [Git](https://git-scm.com/)
- [CMake](https://cmake.org/download/) (3.14 or higher)
- [Ninja](https://ninja-build.org/)
- [Visual Studio 2022](https://visualstudio.microsoft.com/) (Community Edition is enough)
- IDA SDK 9.x (unpacked inside `build/idasdk/`)

## Installation

1. Clone or download this repository.
2. Place your IDA SDK inside `build/idasdk/` so it looks like:
   ```
   build/
     idasdk/
       idasdk92/
         include/
         lib/
   ```
3. Run the script:

   ```cmd
   install_and_build.cmd
   ```

The script will:
- Set up the Visual Studio developer environment.
- Check for required tools.
- Clone **BinExport** and **BinDiff**.
- Build both projects with CMake and Ninja.
- Place the resulting plugins in `build/out/`.

## Output

After the build, the following files should exist:
- `build/out/binexport/ida/binexport64.dll`
- `build/out/bindiff/ida/bindiff8_ida64.dll`

Copy these DLLs to your IDA Pro `plugins` directory, for example:
```
C:\Users\<USER>\AppData\Roaming\Hex-Rays\IDA Pro\plugins
```

## Notes

- BinDiff requires BinExport to function properly.
- Building the Java GUI part of BinDiff requires a commercial yFiles license and is not included here.
- This script focuses on building the IDA Pro plugin components.
