# Stock Mod Templates from Cities: Skylines II

This is a repo containing the two unpacked mod templates from the CS2 official modding tooclhain.

The purpose of this repository is to track changes in templates and tag versions of the game for each change.

- The `dotnet` directory contains a C# mod deployed using `dotnet new csiimod`.
- The `ui` directory contains a UI mod deployed using `npm x create-csii-ui-mod`.

To update the templates, you must have a valid installation of the modding toolchain and run `./update`.

Due to difficulties piping values via stdin to the interactive `npx create-csii-ui-mod`, answer the prompts manually
with mod name = "StockMod" and author = "AuthorName".
