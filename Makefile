################## SETUP  COMPILER ##################
CC          = sdcc
LD          = sdld
AR          = sdar
AS          = sdasstm8
OBJCOPY     = sdobjcopy
SIZE        = size
MAKE        = make

TARGET      = main
STDLIB      = STM8S_StdPeriph_Lib/Libraries/STM8S_StdPeriph_Driver
INCLUDEDIR  = $(STDLIB)/inc Inc
LIBSRCDIR   = $(STDLIB)/src
LIBSRC      = $(LIBSRCDIR)/stm8s_awu.c   $(LIBSRCDIR)/stm8s_tim4.c
LIBSRC     += $(LIBSRCDIR)/stm8s_beep.c  $(LIBSRCDIR)/stm8s_clk.c
LIBSRC     += $(LIBSRCDIR)/stm8s_gpio.c  $(LIBSRCDIR)/stm8s_i2c.c
LIBSRC     += $(LIBSRCDIR)/stm8s_itc.c   $(LIBSRCDIR)/stm8s_iwdg.c
LIBSRC     += $(SRCS)/*.c
LIBSRC     +=

SRCS        = Src
OBJS        = $(LIBSRC:.c=.rel)

MCU         = STM8S003
COMPILER    = __SDCC__
DEFINES     = -D$(COMPILER) -D$(MCU) -DUSE_STDPERIPH_DRIVER

CFLAGS      = -mstm8 --std-c99 $(DEFINES)
LDFLAGS     = $(addprefix -I ,$(INCLUDEDIR))

BUILD_DIR   = Build

IHX         = $(BUILD_DIR)/$(TARGET).ihx



################### BUILD PROCESS ###################
.PHONY: all build clean flash

all: clean build flash

build: $(OBJS) $(IHX)

$(OBJS):

%.rel: %.c
	mkdir -p $(BUILD_DIR)
	$(CC) -c $(CFLAGS) $(LDFLAGS) -o $(BUILD_DIR)/ $<

$(IHX): $(SRCS)/$(TARGET).c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(BUILD_DIR)/ $< $(BUILD_DIR)/stm8s_beep.rel \
	                                               $(BUILD_DIR)/stm8s_gpio.rel \
	                                               $(BUILD_DIR)/stm8s_it.rel
	$(SIZE) $@

clean:
	rm -rf $(BUILD_DIR)/*

flash: $(IHX)
	stm8flash -c stlinkv2 -p stm8s003f3 -s flash -w $<
