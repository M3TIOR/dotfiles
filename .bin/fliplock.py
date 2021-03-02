#!/usr/bin/env python3
# Copyright (c) 2019 Ruby Allison Rose (aka M3TIOR)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from sh import acpi_listen, slock
from time import sleep

slock_lock = False

def unlock_slock():
	global slock_lock
	slock_lock = False

def run_slock_on_close(data_line):
	global slock_lock
	print(data_line)
	if "close" in data_line and not slock_lock:
		slock_lock=True
		slock(_bg=True, _done=unlock_slock)

# Make sure if ACIP isn't immediately available we keep trying on an interval.
while True:
	sleep(10)
	acpi = acpi_listen(_bg=True, _out=run_slock_on_close)
	acpi.wait()
