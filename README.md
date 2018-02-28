# Gamecube ISO Organizer

I made this after I realized that a specific directory layout was required for USB Loader GX to recognize my Gamecube back ups.
It will cycle through all available game ISO's, read their unique ID, create the directory and rename/move the ISO.

## Getting Started

Create a 'games' folder in the same location of this binary. Drop all of your .iso files into 'games' and then run the CUI binary.

### Prerequisites

I never tried this on ISO's that have been shrunk, but as long as it keeps the first 6 bytes of data in the file, they will work.

### Installing

Download the latest release binary or compile using SciTE w/ AutoIT.

## Built With

* [SciTE](https://www.autoitscript.com/site/autoit-script-editor/downloads/) - Customised version of SciTE with lots of additional coding tools for AutoIt
* [AutoIT 3.3.14.2](https://www.autoitscript.com/) - Runtime & Build tools

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
