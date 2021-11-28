import html
import platform

from utils import pprint_to_string

code = """\
##[
  HTML character entity references.
]##

import unicode

# maps the HTML5 named character references to the equivalent Unicode character(s)
const html5*: array[0..{}, (string, string)] = {}

# see http://www.w3.org/TR/html5/syntax.html#tokenizing-character-references
const invalidCharRefs*: array[0..{}, (int, string)] = {}

const invalidCodePoints*: array[0..{}, int] = {}
"""

parts = []

# html5
items = []

for key, value in html.entities.html5.items():
	new_value = " & ".join("cast[Rune]({}).toUTF8()".format(hex(ord(char))) for char in value)
	items.append((key, new_value))

string = pprint_to_string(items)

parts += [
	len(items) - 1,
	string.replace("'", '"').replace('"""', '"\\""').replace('"[\n "', '"]"').replace('"cast', "cast").replace(')"', ")")
]

# invalidCharRefs
items = []

for key, value in html._invalid_charrefs.items():
	new_value = " & ".join("cast[Rune]({}).toUTF8()".format(hex(ord(char))) for char in value)
	items.append((hex(key), new_value))

string = pprint_to_string(items)

parts += [
	len(items) - 1,
	string.replace("'", "")
]

# invalidCodePoints
items = list(
	hex(code) for code in html._invalid_codepoints
)

string = pprint_to_string(items)

parts += [
	len(items) - 1,
	string.replace("]\n", "\n]").replace("[", "[\n ").replace("'", "")
]

with open(file = "./src/htmlunescape/entities.nim", mode = "w") as file:
	file.write(code.format(*parts))