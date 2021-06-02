# 
# Makefile for QR Code generator (C++)
# 
# Copyright (c) Project Nayuki. (MIT License)
# https://www.nayuki.io/page/qr-code-generator-library
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# - The above copyright notice and this permission notice shall be included in
#   all copies or substantial portions of the Software.
# - The Software is provided "as is", without warranty of any kind, express or
#   implied, including but not limited to the warranties of merchantability,
#   fitness for a particular purpose and noninfringement. In no event shall the
#   authors or copyright holders be liable for any claim, damages or other
#   liability, whether in an action of contract, tort or otherwise, arising from,
#   out of or in connection with the Software or the use or other dealings in the
#   Software.
# 


# ---- Configuration options ----

# External/implicit variables:
# - CXX: The C++ compiler, such as g++ or clang++.
# - CXXFLAGS: Any extra user-specified compiler flags (can be blank).

# Recommended compiler flags:
CXXFLAGS += -std=c++11 -O

# Extra flags for diagnostics:
# CXXFLAGS += -g -Wall -Wextra -Wpedantic -Wconversion -Wsign-conversion -fsanitize=undefined,address


# ---- Controlling make ----

# Clear default suffix rules
.SUFFIXES:

# Don't delete object files
.SECONDARY:

# Stuff concerning goals
.DEFAULT_GOAL = all
.PHONY: all clean


# ---- Targets to build ----

LIB = qrcodegen
LIBFILE = lib$(LIB).a
LIBOBJ = QrCode.o
MAINS = QrCodeGeneratorDemo QrCodeGeneratorWorker

# Build all binaries
all: $(LIBFILE) $(MAINS)

# Delete build output
clean:
	rm -f -- $(LIBOBJ) $(LIBFILE) $(MAINS:=.o) $(MAINS)
	rm -rf .deps

# Executable files
%: %.o $(LIBFILE)
	$(CXX) -fopenmp $(CXXFLAGS) $(LDFLAGS) -o $@ $< -L . -l $(LIB)

# The library
$(LIBFILE): $(LIBOBJ)
	$(AR) -crs $@ -- $^

# Object files
%.o: %.cpp .deps/timestamp
	$(CXX) -fopenmp $(CXXFLAGS) -c -o $@ -MMD -MF .deps/$*.d $<

# Have a place to store header dependencies automatically generated by compiler
.deps/timestamp:
	mkdir -p .deps
	touch .deps/timestamp

# Make use of said dependencies if available
-include .deps/*.d
