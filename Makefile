DUT = top_arty_edf

TOP_MODULE = tb_top_arty_edf 
# -t before each target
BENDER_TARGETS = -t edf 
BUILD_DIR       ?= $(realpath $(CURDIR))/build
VERIL_DIR       ?= $(realpath $(CURDIR))/verilator
VERIL_BUILD_DIR ?= $(BUILD_DIR)/verilator_build

VERIL_TOP        = $(VERIL_DIR)/$(TOP_MODULE).cpp

VERIL_WARN_SUPPRESS ?= \
  -Wno-WIDTHTRUNC      \
	-Wno-WIDTHEXPAND

VERIL_FLAGS ?= \
	$(VERIL_WARN_SUPPRESS) \
	-sv \
	--timing \
	--trace-fst \
	--trace-structs \
	--trace-params \
	--hierarchical \
	--cc \
	--build \
	--binary   \
	--top-module $(TOP_MODULE) \
	$(shell bender script flist $(BENDER_TARGETS)) \
	--Mdir $(VERIL_BUILD_DIR)/obj_dir \
	--build \
	-j `nproc`

.PHONY: init
init:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(VERIL_BUILD_DIR)

.PHONY: lint
lint:
	verilator 										\
	--lint-only 									\
	$(shell bender script flist $(BENDER_TARGETS)) 	\
	--top-module $(DUT)						\
	--timing                      \
	$(VERIL_WARN_SUPPRESS)

.PHONY: verilate
verilate: clean init 
	verilator \
	$(VERIL_FLAGS) \

.PHONY: simv
simv: init
	cd $(VERIL_BUILD_DIR) && \
	./obj_dir/V$(TOP_MODULE)

.PHONY: clean
clean:
	@rm -rf $(VERIL_BUILD_DIR)

.PHONY: wave
wave:
	gtkwave $(VERIL_BUILD_DIR)/top_arty.fst &
