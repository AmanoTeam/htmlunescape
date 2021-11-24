# Package

version       = "0.1"
author        = "SnwMds"
description   = "Port of Python's html.escape and html.unescape to Nim"
license       = "LGPL-3.0"
srcDir        = "src"


# Dependencies

requires "nim >= 1.0.0"

task test, "Runs the test suite":
  exec "nim compile --run ./tests/test_escape.nim"
  exec "nim compile --run ./tests/test_unescape.nim"
