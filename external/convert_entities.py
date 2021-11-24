import html
import platform

from utils import pprint_to_string

code = """\
##[
  General functions for HTML manipulation.
]##

# Everything below this line was auto-generated from the Python {} source files.

# maps the HTML5 named character references to the equivalent Unicode character(s)
const html5*: array[0..{}, (string, string)] = {}

# see http://www.w3.org/TR/html5/syntax.html#tokenizing-character-references
const invalidCharRefs*: array[0..{}, (int, int)] = {}

const invalidCodePoints*: array[0..{}, int] = {}
"""

parts = []

# html5
items = [
	(key, value) for key, value in html.entities.html5.items()
]

string = pprint_to_string(items)

parts += [
	len(items) - 1,
	string.replace("]\n", "\n]").replace("[", "[\n ").replace("'", '"').replace('"""', '"\\""').replace('"[\n "', '"]"')
]

# invalidCharRefs
items = [
	(hex(key), hex(ord(value))) for key, value in html._invalid_charrefs.items()
]

string = pprint_to_string(items)

parts += [
	len(items) - 1,
	string.replace("]\n", "\n]").replace("[", "[\n ").replace("'", "")
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
	file.write(code.format(platform.python_version(), *parts))