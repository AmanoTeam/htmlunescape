# Package

version       = "0.1"
author        = "SnwMds"
description   = "Port of Python's html.escape and html.unescape to Nim"
license       = "LGPL-3.0"
srcDir        = "src"


# Dependencies

requires "nim >= 1.4.8"

task test, "Runs the test suite":
  exec "nim compile --run tests/test_*.nim"
