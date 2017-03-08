###############################################################################
#	makefile
#	 by Alex Chadwick
#
#	A makefile script for generation of raspberry pi kernel images.
###############################################################################

# The toolchain to use. arm-none-eabi works, but there does exist
# arm-bcm2708-linux-gnueabi.
ARMGNU ?= arm-none-eabi

# The directory in which source files are stored.
#SOURCE = $(SRC)

ifeq ($(SOURCE),)
SOURCE=source/
endif

# The name of the linker script to use.
LINKER = $(SOURCE)kernel.ld

# The intermediate directory for compiled object files.
BUILDROOT = build/
BUILD = $(BUILDROOT)$(SOURCE)

# The name of the output file to generate.
TARGET = $(BUILD)kernel.img

# The name of the assembler listing file to generate.
LIST = $(BUILD)kernel.list

# The name of the map file to generate.
MAP = $(BUILD)kernel.map

# The names of all object files that must be generated. Deduced from the
# assembly code files in source.
OBJECTS := $(patsubst $(SOURCE)%.s,$(BUILD)%.o,$(wildcard $(SOURCE)*.s))

# Rule to make everything.
all: $(TARGET) $(LIST)

# Rule to remake everything. Does not include clean.
rebuild: all

# Rule to make the listing file.
$(LIST) : $(BUILD)output.elf
	$(ARMGNU)-objdump -d $(BUILD)output.elf > $(LIST)

# Rule to make the image file.
$(TARGET) : $(BUILD)output.elf
	$(ARMGNU)-objcopy $(BUILD)output.elf -O binary $(TARGET)

# Rule to make the elf file.
$(BUILD)output.elf : $(OBJECTS) $(LINKER)
	$(ARMGNU)-ld --no-undefined $(OBJECTS) -Map $(MAP) -o $(BUILD)output.elf -T $(LINKER)

# Rule to make the object files.
$(BUILD)%.o: $(SOURCE)%.s $(BUILD)
	$(ARMGNU)-as -I $(SOURCE) $< -o $@

$(BUILD):
	mkdir -p $@

# Rule to clean files.
clean :
	-rm -rf $(BUILDROOT)
	#-rm -f $(TARGET)
	#-rm -f $(LIST)
	#-rm -f $(MAP)