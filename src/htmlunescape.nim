##[
  General functions for HTML manipulation.
]##

import std/strutils
import std/parseutils
import std/re
import std/unicode

import ./htmlunescape/entities

let charRef: Regex = re"&(?:#[0-9]+;?|#[xX][0-9a-fA-F]+;?|[^\t\n\f <&#;]{1,32};?)"

proc escape*(s: string, quote: bool = true): string =
    ## Replace special characters `&`, `<` and `>` to HTML-safe sequences.
    ## If the optional flag quote is `true` (the default), the quotation mark
    ## characters, both double quote (`"`) and single quote (`'`) characters are also
    ## translated.

    result = multiReplace(
        s = s,
        replacements = [
            ("&", "&amp;"),
            ("<", "&lt;"),
            (">", "&gt;")
        ]
    )

    if quote:
        result = multiReplace(
            s = result,
            replacements = [
                ("\"", "&quot;"),
                ("'", "&#x27;")
            ]
        )

proc getMatchingCharRef(match: string): string =
    var s: string = match
    s.removePrefix(c = '&')

    if s.startsWith(prefix = '#'):
        # numeric charref
        let isPercentEncoding: bool = s[1] in ['x', 'X']

        var hexString: string = if isPercentEncoding: s[2 .. ^1] else: s[1 .. ^1]
        hexString.removeSuffix(c = ';')

        var codePoint: BiggestInt
        if isPercentEncoding:
            codePoint = fromHex[BiggestInt](s = hexString)
        else:
            discard parseBiggestInt(s = hexString, number = codePoint)

        for (key, value) in invalidCharRefs:
            if codePoint == key:
                return cast[Rune](value).toUTF8()

        if (0xd800 <= codePoint and codePoint <= 0xdfff) or codePoint > 0x10ffff:
            return "\uFFFD"

        for invalidCodePoint in invalidCodePoints:
            if codePoint == invalidCodePoint:
                return

        result = cast[Rune](codePoint).toUTF8()
    else:
        # named charref
        for (key, value) in html5:
            if s == key:
                return value

        # find the longest matching name (as defined by the standard)
        for index in countdown(a = len(s) - 1, b = 2):
            var ncRef: string = s[0 ..< index]

            for (key, value) in html5:
                if ncRef == key:
                    return value & s[index .. ^1]

        result = '&' & s
    
    
proc unescape*(s: string): string =
    ## Convert all named and numeric character references (e.g. `&gt;`, `&#62;`,
    ## `&x3e;`) in the string `s` to the corresponding unicode characters.
    ## This function uses the rules defined by the HTML 5 standard
    ## for both valid and invalid character references, and the list of
    ## HTML 5 named character references defined in `html.entities.html5`.

    if "&" notin s:
        return s

    var replacements: seq[(string, string)] = newSeq[(string, string)]()

    for match in findAll(s = s, pattern = charRef):
        var matchingRef: string = getMatchingCharRef(match = match)
        replacements.add((match, matchingRef))

    result = multiReplace(
        s = s,
        replacements = replacements
    )
