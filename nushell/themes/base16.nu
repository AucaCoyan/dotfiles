const base00 = "#181818" # Default Background
const base01 = "#282828" # Lighter Background (Used for status bars, line number and folding marks)
const base02 = "#383838" # Selection Background
const base03 = "#585858" # Comments, Invisibles, Line Highlighting
const base04 = "#b8b8b8" # Dark Foreground (Used for status bars)
const base05 = "#d8d8d8" # Default Foreground, Caret, Delimiters, Operators
const base06 = "#e8e8e8" # Light Foreground (Not often used)
const base07 = "#f8f8f8" # Light Background (Not often used)
const base08 = "#ab4642" # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
const base09 = "#dc9656" # Integers, Boolean, Constants, XML Attributes, Markup Link Url
const base0a = "#f7ca88" # Classes, Markup Bold, Search Text Background
const base0b = "#a1b56c" # Strings, Inherited Class, Markup Code, Diff Inserted
const base0c = "#86c1b9" # Support, Regular Expressions, Escape Characters, Markup Quotes
const base0d = "#7cafc2" # Functions, Methods, Attribute IDs, Headings
const base0e = "#ba8baf" # Keywords, Storage, Selector, Markup Italic, Diff Changed
const base0f = "#a16946" # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>

# we're creating a theme here that uses the colors we defined above.

export const base16_theme = {
    separator: $base03
    leading_trailing_space_bg: $base04
    header: $base0b
    date: $base0e
    filesize: $base0d
    row_index: $base0c
    bool: $base08
    int: $base0b
    duration: $base08
    range: $base08
    float: $base08
    string: $base04
    nothing: $base08
    binary: $base08
    cellpath: $base08
    hints: dark_gray

    # shape_garbage: { fg: $base07 bg: $base08 attr: b} # base16 white on red
    # but i like the regular white on red for parse errors
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
    shape_bool: $base0d
    shape_int: { fg: $base0e attr: b}
    shape_float: { fg: $base0e attr: b}
    shape_range: { fg: $base0a attr: b}
    shape_internalcall: { fg: $base0c attr: b}
    shape_external: $base0c
    shape_externalarg: { fg: $base0b attr: b}
    shape_literal: $base0d
    shape_operator: $base0a
    shape_signature: { fg: $base0b attr: b}
    shape_string: $base0b
    shape_filepath: $base0d
    shape_globpattern: { fg: $base0d attr: b}
    shape_variable: $base0e
    shape_flag: { fg: $base0d attr: b}
    shape_custom: {attr: b}
}
