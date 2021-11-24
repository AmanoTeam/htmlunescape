import io
import pprint

def pprint_to_string(obj):
	
	with io.StringIO() as stream:
		pprint.pprint(object = obj, indent = 4, stream = stream)
		stream.seek(0)
		string = stream.read()
	
	return string
