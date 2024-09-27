<div align="center">

![](build/out/image/ayame-128.png)

# Ayame

</div>

A dark theme inspired by the nightly bright colors of cyber-neon anime. [Get it for your tool](#deployments).

## Contents

- [Ayame](#ayame)
  - [Contents](#contents)
  - [Color Palette](#color-palette)
  - [Deployments](#deployments)
  - [Building](#building)
    - [Tools Required](#tools-required)
    - [Procedure](#procedure)
  - [Templates](#templates)
    - [Example](#example)

## Color Palette

![](build/out/image/ayame-palette-graphic.png)
![](build/out/image/ayame-palette.png)

| Hex ____________ | ID | Uses |
| --- | --- | --- |
| ![](build/out/icon/background.svg) `#17131e` | `background`, `bg`, `bg900` | Background |
| ![](build/out/icon/foreground.svg) `#cbbade` | `foreground`, `fg`, `fg200`, `variable`, `identifier` | Foreground, Variables, Identifiers |
| ![](build/out/icon/red.svg) `#ff577e` | `red`, `deleted`, `breakpoint`, `stop`, `this`, `bold`, `red500` | Terminal Bright Red, Git deleted, Breakpoints, Stop, Language variables, Markdown bold |
| ![](build/out/icon/orange.svg) `#ff965c` | `orange`, `warning`, `constant`, `orange500` | Terminal Yellow, Warnings, Constants |
| ![](build/out/icon/yellow.svg) `#f5cb40` | `yellow`, `character`, `yellow500` | Terminal Bright Yellow, Characters, HTML attributes, CSS classes, Markdown alt text, Markdown link anchors |
| ![](build/out/icon/green.svg) `#96e474` | `green`, `added`, `debug`, `string`, `green500` | Terminal Bright Green, Git added, Debug, Strings |
| ![](build/out/icon/teal.svg) `#5df8a6` | `teal`, `todo`, `teal500` | TODO comments |
| ![](build/out/icon/cyan.svg) `#54e7f8` | `cyan`, `match`, `control`, `regex`, `escape`, `italics`, `cyan500`, `linkhover` | Terminal Bright Cyan, Find matches, Hyperlink hover, Control keywords, RegEx literals, Escape characters, Markdown italics |
| ![](build/out/icon/blue.svg) `#44a3f5` | `blue`, `primary`, `progress`, `modified`, `hyperlink`, `keyword`, `type`, `blue500` | Terminal Bright Blue, Progress bars, Git modified, Hyperlinks, Keywords, Type |
| ![](build/out/icon/purple.svg) `#9768f8` | `purple`, `darkmagenta`, `secondary`, `function`, `fun`, `attribute`, `code`, `purple500` | Terminal Magenta, Debug token keys, Functions, Attributes, Markdown plain code blocks |
| ![](build/out/icon/magenta.svg) `#f76ef1` | `magenta`, `pink`, `tertiary`, `focus`, `operator`, `magenta500`, `value` | Terminal Bright Magenta, Debug token values, Focus accents, Operator keywords |
| ![](build/out/icon/red900.svg) `#662332` | `red900`, `error2` | Error background |
| ![](build/out/icon/red700.svg) `#cc4665` | `red700`, `darkred`, `error`, `invalid`, `tag` | Terminal Red, Error, Invalid, Tags |
| ![](build/out/icon/red300.svg) `#ff7998` | `red300` |  |
| ![](build/out/icon/red100.svg) `#ffbccb` | `red100` |  |
| ![](build/out/icon/orange900.svg) `#663c25` | `orange900` |  |
| ![](build/out/icon/orange700.svg) `#cc784a` | `orange700` |  |
| ![](build/out/icon/orange300.svg) `#ffab7d` | `orange300` |  |
| ![](build/out/icon/orange100.svg) `#ffd5be` | `orange100` |  |
| ![](build/out/icon/yellow900.svg) `#62511a` | `yellow900` |  |
| ![](build/out/icon/yellow700.svg) `#c4a233` | `yellow700` |  |
| ![](build/out/icon/yellow300.svg) `#f7d566` | `yellow300` |  |
| ![](build/out/icon/yellow100.svg) `#fbeab3` | `yellow100` |  |
| ![](build/out/icon/green900.svg) `#3c5b2e` | `green900` |  |
| ![](build/out/icon/green700.svg) `#78b65d` | `green700`, `darkgreen`, `info` | Terminal Green, Info, String quotation marks |
| ![](build/out/icon/green300.svg) `#abe990` | `green300` |  |
| ![](build/out/icon/green100.svg) `#d5f4c7` | `green100` |  |
| ![](build/out/icon/teal900.svg) `#256342` | `teal900` |  |
| ![](build/out/icon/teal700.svg) `#4ac685` | `teal700` |  |
| ![](build/out/icon/teal300.svg) `#7df9b8` | `teal300` |  |
| ![](build/out/icon/teal100.svg) `#befcdb` | `teal100` |  |
| ![](build/out/icon/cyan900.svg) `#225c63` | `cyan900` |  |
| ![](build/out/icon/cyan700.svg) `#43b9c6` | `cyan700`, `darkcyan`, `class` | Terminal Cyan, Classes |
| ![](build/out/icon/cyan300.svg) `#76ecf9` | `cyan300` |  |
| ![](build/out/icon/cyan100.svg) `#bbf5fc` | `cyan100` |  |
| ![](build/out/icon/blue900.svg) `#1b4162` | `blue900` |  |
| ![](build/out/icon/blue700.svg) `#3682c4` | `blue700`, `darkblue`, `activitybadge`, `bookmark`, `blue2` | Terminal Blue, Bookmarks, VS Code activity badge |
| ![](build/out/icon/blue300.svg) `#69b5f7` | `blue300` |  |
| ![](build/out/icon/blue100.svg) `#b4dafb` | `blue100` |  |
| ![](build/out/icon/purple900.svg) `#3c2a63` | `purple900` |  |
| ![](build/out/icon/purple700.svg) `#7953c6` | `purple700` |  |
| ![](build/out/icon/purple300.svg) `#ac86f9` | `purple300` |  |
| ![](build/out/icon/purple100.svg) `#d5c3fc` | `purple100` |  |
| ![](build/out/icon/magenta900.svg) `#632c60` | `magenta900` |  |
| ![](build/out/icon/magenta700.svg) `#c658c1` | `magenta700` |  |
| ![](build/out/icon/magenta300.svg) `#f98bf4` | `magenta300` |  |
| ![](build/out/icon/magenta100.svg) `#fcc5f9` | `magenta100` |  |
| ![](build/out/icon/bg800.svg) `#1a1528` | `bg800`, `border2` | Secondary borders |
| ![](build/out/icon/bg700.svg) `#221c35` | `bg700`, `modal`, `menu`, `toolbar`, `checkbox`, `input` | Modal background, Checkbox background, Input background |
| ![](build/out/icon/bg600.svg) `#2b2343` | `bg600`, `subheader`, `tabline`, `hover`, `highlight` | Subheader background, Line highlight, UI hover highlight |
| ![](build/out/icon/bg500.svg) `#342950` | `bg500`, `black`, `gutter`, `border`, `rule`, `button`, `altrow` | Terminal Black, Buttons, Borders, Rules and guides, Line numbers, Alternate row background, Alternate modal background |
| ![](build/out/icon/bg400.svg) `#3c305d` | `bg400` |  |
| ![](build/out/icon/bg300.svg) `#45376a` | `bg300` |  |
| ![](build/out/icon/bg200.svg) `#4d3e78` | `bg200` |  |
| ![](build/out/icon/bg100.svg) `#564585` | `bg100`, `gray`, `comment`, `blockquote`, `folded`, `darkgray` | Terminal Bright Black, Comments, Markdown block quotes, Folded code blocks |
| ![](build/out/icon/fg900.svg) `#191023` | `fg900` |  |
| ![](build/out/icon/fg800.svg) `#322145` | `fg800`, `focusborder`, `highlightborder`, `modalhighlight`, `highlight2` | Highlight and focus border, Highlights in UI and modals |
| ![](build/out/icon/fg700.svg) `#4a3168` | `fg700`, `selection` | Selection background |
| ![](build/out/icon/fg600.svg) `#63428a` | `fg600` |  |
| ![](build/out/icon/fg500.svg) `#7c52ad` | `fg500`, `underline` | Markdown underline |
| ![](build/out/icon/fg400.svg) `#9675bd` | `fg400`, `cursor`, `activeborder`, `active` | Cursor, Active border, Active line number, Subheader foreground, Badge background, Minimap and scrollbar background, Markdown table text |
| ![](build/out/icon/fg300.svg) `#b097ce` | `fg300` |  |
| ![](build/out/icon/fg100.svg) `#e5dcef` | `fg100`, `white`, `object` | Terminal Bright White, Objects |
| ![](build/out/icon/bracket.svg) `#6c8db3` | `bracket` | Parentheses, Brackets, Braces |
| ![](build/out/icon/lightgray.svg) `#8a7d9b` | `lightgray`, `darkwhite`, `muted`, `punctuation`, `terminator` | Terminal White, Muted text, Punctuation |
| ![](build/out/icon/foreground2.svg) `#bbbbbb` | `foreground2` | Alternate foreground |
| ![](build/out/icon/purewhite.svg) `#ffffff` | `purewhite` | Extra white for lighter backgrounds, Badge foreground |
| ![](build/out/icon/header.svg) `#0b0911` | `header` | Modal header background |

## Deployments

Ayame is available for the following tools:

- [Visual Studio Code](https://github.com/AyameTheme/vscode)
- [Microsoft Office](build/out/office/README.md)

## Building

Color definitions are contained in `src/ayame-colors.json`. This file is the main 'editable' file used for modifying the color palette. This file is used to generate `build/out/ayame.json`, which is the main file used to place colors in template files. For example, this is the output definition for "background":

```json
"background": {
  "hex": "#17131e",
  "r": 23,
  "red": 23,
  "red_percent": 0.09019607843137255,
  "g": 19,
  "green": 19,
  "green_percent": 0.07450980392156863,
  "b": 30,
  "blue": 30,
  "blue_percent": 0.11764705882352941,
  "rgb": "rgb(23, 19, 30)",
  "h": 261.8181818181818,
  "hue": 261.8181818181818,
  "s": 0.22448979591836737,
  "saturation": 0.22448979591836737,
  "l": 0.09607843137254901,
  "lightness": 0.09607843137254901,
  "hsl": "hsl(262, 22%, 10%)"
}
```

`ayame.json` is verbose and robust. There are complete color definitions for every ID in the color palette table, even if the same color has more than one ID. For example, `background` and `bg` have identical yet separate definitions in `ayame.json`, so referencing `ayame.json:colors.background.hex` is identical to `ayame.json:colors.bg.hex` since their IDs are associated with the same color in `ayame-colors.json`.

There are multiple benefits to this model. Firstly, templates referencing colors can use contextual IDs so the template reads less confusing and IDs themselves can be changed to different colors easily. For example:

1. One template contains `[[ayame:colors.red.hex]]`, which will be replaced with `#ff6394` by the build script. The developer used this variable to style some bold text.
2. The developer decides to be more specific and uses `[[ayame:colors.bold.hex]]` instead.
3. The developer wishes to change the bold color, so he changes the hex code in `ayame-colors.json` for ID `bold` to `#76b5c5`. Not only will this change affect all instances when the ID `bold` is referenced, but IDs (`red`, `deleted`, `this`, etc.) previously grouped with ID `bold` are not affected, and will remain red.

### Tools Required

The build script uses the following tools:

- [PowerShell v7+](https://github.com/PowerShell/PowerShell) (cross-platform), available as the shell used in your terminal, or as `pwsh` in PATH. Check version with `pwsh --version`.
- [Inkscape v1+](https://github.com/inkscape/inkscape), available in as `inkscape` in PATH. Used to generate the palette graphic. Check version with `inkscape --version`.
- [Victor Mono](https://github.com/rubjo/victor-mono). Used in the palette graphic.

### Procedure

To build the project:

1. Clone (or download zip and extract) this repository.
2. Open a terminal in the cloned directory. Execute the following command:

    ```powershell
    # In PowerShell
    & .\build.ps1
    ```

    Or in a non-PowerShell terminal:

    ```bash
    pwsh -NoProfile -ExecutionPolicy Bypass -File ./build.ps1
    ```

## Templates

You can create templates and the build script will replace 'variables' with values from `ayame.json`. The build script will navigate through the JSON tree and replace the key with the appropriate value. Here is the format:

```
[[ayame:key.sub_key.sub_sub_key]]
```

A template file recognized by the build script contains `.ayame-template` anywhere in the file name in the `src` directory. It will place the product in `out`, removing `.ayame-template` from the file name, and following a subdirectory structure if relevant.

```
src/subdir/myfile.ayame-template.md
-> out/subdir/myfile.md

src/graphic.ayame-template.svg
-> out/graphic.svg
```

### Example

The build script finds a file named `custom.ayame-template.md` in the `src` directory. In this file:

```markdown
How much red is in orange? This much: [[ayame:colors.orange.r]]
```

It finds the following string and recognizes it as a variable to be replaced:

```
[[ayame:colors.orange.r]]
```

...will be replaced with:

```
231
```

...since `colors.orange.r` is a valid key to a value in `ayame.json`:

```json
{
  "colors": {
    "orange": {
      "r": 231,
      // ...
    },
    // ...
  },
  // ...
}
```

...resulting in `custom.md` in the `out` directory with the following contents:

```markdown
How much red is in orange? This much: 231
```
