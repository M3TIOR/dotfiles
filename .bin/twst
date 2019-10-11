#!/usr/bin/python3
#!/usr/bin/env python3

# The MIT License
#
# Copyright (c) 2018 Ruby Allison Rose
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#------------------------------------------------------------------------------
# M3TIOR 2017 & 2018
#
# When you're working with someone who likes to indent with spaces instead
# of tabs, here's a little twist to turn the tables in your favor.
#
# This is just a small script I made to help me work with an old friend
# who think's spaced indentation is better than tabbed indentation.
#
# TODO: maybe make this modular so I can upload it to the python3 pip database
# TODO: handle non-text files without throwing errors...


if __name__ != "__main__":
	print("This is a standalone app... it does nothing this way...")

import io, sys, os
import argparse
import tempfile

# --------- Main --------- #

parse_core = argparse.ArgumentParser(
	prog='twst',
	description="""
		This script is a meant to make working with
		people who indent their code with spaces rather
		than tabs easier to work with, and vice versa.
	"""
)

parse_core.add_argument(
	'PATH',
	help = "A file that we'll be indenting",
	nargs = '+'
)
parse_core.add_argument(
	'-t', '--tabs',
	help = "Sets indentation mode to tabs",
	action = "store_const",
	const = "tabs",
	dest = "mode"
)
parse_core.add_argument(
	'-s', '--spaces',
	help = "Sets indentation mode to spaces",
	action = "store_const",
	const = "spaces",
	dest = "mode"
)
parse_core.add_argument(
	'-c',
	metavar = "COUNT",
	help = "Set's the spaces per tab. ( default is 4 )",
	type = int,
	default = 4,
	dest = "count"
)
parse_core.add_argument(
	'-r', '--recursive',
	help = """
		if PATH as a directory, applies the twist to all files contained
		within the folder and it's subfolders.
	""",
	action = "store_true",
)
parse_core.add_argument(
	'-b', '--backup',
	help = """
		outputs the results of each twist to a new file
		while overwriting the original, and deletes it when done.
		(safer, but takes longer)
	""",
	action = "store_true"
)
parse_core.add_argument(
	'-v', '--verbose',
	help = """outputs all files affected by twists.""",
	action = "store_true"
)

ARGUMENTS = parse_core.parse_args()
if ARGUMENTS.mode == None:
	print("Must specify mode! try --help", stderr)
	sys.exit()

# allocate half a MB for buffering lol
buffer = tempfile.SpooledTemporaryFile(max_size=512*1024, mode="w+")

def twist(filename):
	"""
		Convert spaced code indentation to
		tabbed code indentation and vice versa.
	"""

	buf = buffer # for some reason python didn't like the direct global object.
	# NOTE:
	#	makes twist's buffer reusable for multiple files
	buf.seek(0)
	buf.truncate(0)

	# NOTE:
	#	gotta make sure nothing freaks out over relative paths.
	absolute_file		= os.path.abspath(filename)
	absolute_path		= os.path.dirname(absolute_file)
	absolute_filename	= os.path.basename(absolute_file)
	if os.path.isdir(absolute_file):
		return
	if os.path.islink(absolute_file):
		# TODO: maybe add symlink resolution option in the future
		return

	inp = open(absolute_file, mode="r+")
	if ARGUMENTS.backup:
		outfile = os.path.join(absolute_file, "".join("~",absolute_filename))
		buf = open(outfile, mode="w+")

	lines = 0
	while True:
		line=inp.readline()
		if line == '':
			break # readline returns empty on EOF, if EOF we close the loop
		lines += 1

		trimline = ('' + line).lstrip()
		tabs = 0
		spaces = 0
		for char in range(0, len(line)):
			if line[char] == ' ':
				spaces += 1
			elif line[char] == '\t':
				tabs += 1
			else:
				break

		if ARGUMENTS.mode == "tabs":
			buf.write(''.join([
				'\t' for tab in range(
					0, ((tabs*ARGUMENTS.count) + spaces) // ARGUMENTS.count
				)
			])+trimline)
		elif ARGUMENTS.mode == "spaces":
			buf.write(''.join([
				' ' for tab in range(
					0, ((tabs*ARGUMENTS.count) + spaces)
				)
			])+trimline)
		if trimline == '':
			buf.write('\n')

	if ARGUMENTS.backup:
		buf.seek(0)
		for line in range(0, lines):
			out.write(buf.readline()) # and write the twist to our input file

	# Make sure we're putting the buffer data where it should be.
	inp.seek(0)

	# Seek to the end of the file,
	buf.seek(0,2)
	# and make sure we resize our initial file to hold it's new data.
	inp.truncate(buf.tell())

	#Then we reset the output pointer.
	buf.seek(0)
	for line in range(0, lines):
		inp.write(buf.readline()) # and write the twist to our input file

	inp.close()
	if ARGUMENTS.backup:
		# don't close and delete our other file until the origin is safe
		out.close()
		os.remove(outfile)
	if ARGUMENTS.verbose:
		print(absolute_file)

def recursive_twist(directory):
	for container, dirs, files in os.walk(directory):
		for file in files:
			twist(os.path.join(container,file))
		for dir in dirs:
			recursive_twist(os.path.join(container,dir))

#if __name__ == "__main__": # Redundant
for path in ARGUMENTS.PATH:
	if ARGUMENTS.recursive and os.path.isdir(path):
		recursive_twist(path)
	else:
		twist(path)