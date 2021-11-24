import ../src/htmlunescape

doAssert escape(s = "'<script>\"&foo;\"</script>'") == "&#x27;&lt;script&gt;&quot;&amp;foo;&quot;&lt;/script&gt;&#x27;"
doAssert escape(s = "'<script>\"&foo;\"</script>'", quote = false) == "'&lt;script&gt;\"&amp;foo;\"&lt;/script&gt;'"
