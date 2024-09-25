<div align="center">

![](build/out/ayame-128.png)

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

![](build/out/ayame-palette-graphic.png)

| Hex ____________ | ID | Uses |
| --- | --- | --- |
| ![](build/out/icon/background.svg) `#17131e` | `background`, `bg` | Background |
| ![](build/out/icon/foreground.svg) `#bab4d2` | `foreground`, `fg` | Foreground |
| ![](build/out/icon/red.svg) `#ff6394` | `red`, `deleted`, `breakpoint`, `stop`, `this`, `bold` | Terminal Bright Red, Git deleted, Breakpoints, Stop, Language variables, Markdown bold |
| ![](build/out/icon/darkred.svg) `#d74368` | `darkred`, `error`, `invalid` | Terminal Red, Error, Invalid |
| ![](build/out/icon/yellow.svg) `#f5cb40` | `yellow`, `character` | Terminal Bright Yellow, Characters, HTML attributes, CSS classes, Markdown alt text, Markdown link anchors |
| ![](build/out/icon/orange.svg) `#e78d5b` | `orange`, `darkyellow`, `warning`, `constant` | Terminal Yellow, Warnings, Constants |
| ![](build/out/icon/green.svg) `#98d57e` | `green`, `added`, `debug`, `string` | Terminal Bright Green, Git added, Debug, Strings |
| ![](build/out/icon/darkgreen.svg) `#63ae5d` | `darkgreen`, `info` | Terminal Green, Info, String quotation marks |
| ![](build/out/icon/cyan.svg) `#63dcea` | `cyan`, `match`, `control`, `regex`, `escape`, `italics` | Terminal Bright Cyan, Find matches, Hyperlink hover, Control keywords, RegEx literals, Escape characters, Markdown italics |
| ![](build/out/icon/darkcyan.svg) `#64a9cc` | `darkcyan`, `class`, `identifier`, `variable` | Terminal Cyan, Classes, Identifiers, Variables |
| ![](build/out/icon/blue.svg) `#51a2e8` | `blue`, `primary`, `progress`, `modified`, `hyperlink`, `keyword`, `type` | Terminal Bright Blue, Progress bars, Git modified, Hyperlinks, Keywords, Type |
| ![](build/out/icon/darkblue.svg) `#5984e7` | `darkblue`, `bookmark` | Terminal Blue, Bookmarks |
| ![](build/out/icon/pink.svg) `#eb68e5` | `pink`, `magenta`, `tertiary`, `focus`, `operator` | Terminal Bright Magenta, Debug token values, Focus accents, Operator keywords |
| ![](build/out/icon/purple.svg) `#966cec` | `purple`, `darkmagenta`, `secondary`, `function`, `fun`, `attribute`, `code` | Terminal Magenta, Debug token keys, Functions, Attributes, Markdown plain code blocks |
| ![](build/out/icon/white.svg) `#d1c9f4` | `white`, `object` | Terminal Bright White, Objects |
| ![](build/out/icon/lightgray.svg) `#8a7d9b` | `lightgray`, `darkwhite`, `muted`, `punctuation`, `terminator` | Terminal White, Muted text, Punctuation |
| ![](build/out/icon/gray.svg) `#37355a` | `gray`, `gutter`, `border`, `rule`, `button` | Terminal Bright Black, Buttons, Borders, Rules and guides, Line numbers |
| ![](build/out/icon/black.svg) `#2b284a` | `black`, `subheader`, `tabline` | Terminal Black, Subheader background |
| ![](build/out/icon/border2.svg) `#0b0911` | `border2`, `header` | Secondary borders |
| ![](build/out/icon/modal.svg) `#211d2b` | `modal`, `menu`, `toolbar` | Modal background |
| ![](build/out/icon/hover.svg) `#2d203c` | `hover`, `highlight` | Line highlight, UI hover highlight |
| ![](build/out/icon/altrow.svg) `#2b253c` | `altrow` | Alternate row background, Alternate modal background |
| ![](build/out/icon/focusborder.svg) `#3d2a54` | `focusborder`, `highlightborder` | Highlight and focus border |
| ![](build/out/icon/modalhighlight.svg) `#3e2e4c` | `modalhighlight`, `highlight2` | Highlights in UI and modals |
| ![](build/out/icon/selection.svg) `#3c376f` | `selection` | Selection background |
| ![](build/out/icon/comment.svg) `#5953a7` | `comment` | Comments, Markdown block quotes, Folded code blocks |
| ![](build/out/icon/cursor.svg) `#857abc` | `cursor` | Cursor, Active line number, Subheader foreground, Badge background, Minimap and scrollbar background, Markdown table text |
| ![](build/out/icon/activitybadge.svg) `#007acc` | `activitybadge` | VS Code activity badge |
| ![](build/out/icon/blue2.svg) `#4984e7` | `blue2` | Alternate blue |
| ![](build/out/icon/bracket.svg) `#6c8db3` | `bracket` | Parentheses, Brackets, Braces |
| ![](build/out/icon/error2.svg) `#6a1d31` | `error2` | Error background |
| ![](build/out/icon/tag.svg) `#f07178` | `tag` | Tags |
| ![](build/out/icon/foreground2.svg) `#bbbbbb` | `foreground2` | Alternate foreground |
| ![](build/out/icon/purewhite.svg) `#ffffff` | `purewhite` | Extra white for lighter backgrounds, Badge foreground |
| ![](build/out/icon/teal.svg) `#5ee59d` | `teal`, `todo` | TODO comments |

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
