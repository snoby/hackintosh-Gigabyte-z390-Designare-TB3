
RELEASE_PATH:=$(CURDIR)/releaseFiles
OUTPUT:=$(CURDIR)/output

OC_ZIP:=OpenCore-0.5.6-RELEASE.zip
SRC_TO_DECOMPRESS:=${RELEASE_PATH}/${OC_ZIP}
PATCH_DIR = $(CURDIR)/src/config_patches
PATCH_FILES = $(PATCH_DIR)/ACPI_config_z390-Designare.patch $(PATCH_DIR)/booter_config_z390-Designare.patch

CONFIG_PLIST:=${OUTPUT}/EFI/OC/config.plist

decompress:
	@echo "Decompressing Original src"
	@cd ${OUTPUT} && unzip -qo ${SRC_TO_DECOMPRESS}
	@echo "Copying Sample.plist to config.plist"
	@cp -rf ${OUTPUT}/Docs/Sample.plist ${OUTPUT}/EFI/OC/config.plist

board_reference_files:
	@echo "Copying reference files to output"
	cp -rf src/ACPI/* ${OUTPUT}/EFI/OC/ACPI/


$(CONFIG_PLIST): decompress

patches: $(CONFIG_PLIST)
	@echo "Applying patches"
	patch $(CONFIG_PLIST) < $(PATCH_DIR)/ACPI_config_z390-Designare.patch
	patch $(CONFIG_PLIST) < $(PATCH_DIR)/booter_config_z390-Designare.patch
	patch $(CONFIG_PLIST) < $(PATCH_DIR)/DeviceProperties_config_z390-Designare.patch




all: patches

clean:
	-@rm -rf output/*

