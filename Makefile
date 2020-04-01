
RELEASE_PATH:=$(CURDIR)/releaseFiles
OUTPUT:=output

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
	@cp -rf src/ACPI/* ${OUTPUT}/EFI/OC/ACPI/


$(CONFIG_PLIST): decompress

patches: $(CONFIG_PLIST)
	@echo "Applying patches"
	patch $(CONFIG_PLIST) < $(PATCH_DIR)/ACPI_config_z390-Designare.patch
	patch $(CONFIG_PLIST) < $(PATCH_DIR)/booter_config_z390-Designare.patch
	patch $(CONFIG_PLIST) < $(PATCH_DIR)/DeviceProperties_config_z390-Designare.patch
	patch $(CONFIG_PLIST) < $(PATCH_DIR)/Kernel_config_z390-Designare.patch
	patch $(CONFIG_PLIST) < $(PATCH_DIR)/Misc_config_z390-Designare.patch
	patch $(CONFIG_PLIST) < $(PATCH_DIR)/NVRAM_config_z390-Designare.patch
	patch $(CONFIG_PLIST) < $(PATCH_DIR)/PlatformInfo_config_z390-Designare.patch
	patch $(CONFIG_PLIST) < $(PATCH_DIR)/UEFI_config_z390-Designare.patch
	patch $(CONFIG_PLIST) < $(PATCH_DIR)/FixUP_config_z390-Designare.patch
	patch $(CONFIG_PLIST) < $(PATCH_DIR)/UEFI_INPUT_config_z390-Designare.patch
	patch $(CONFIG_PLIST) < $(PATCH_DIR)/ACPI_NO_BLOCK_config_z390-Designare.patch
	patch $(CONFIG_PLIST) < $(PATCH_DIR)/UEFI_Move_config_z390-Designare.patch
	rm -rf $(OUTPUT)/EFI/OC/config.plist.org


drivers:
	@echo "Applying Drivers"
	#todo setup tool to pull source and get releases of files from ocbuilder.
	@cp -rf src/Drivers/ApfsDriverLoader.efi $(OUTPUT)/EFI/OC/Drivers/
	@cp -rf src/Drivers/BootLiquor.efi $(OUTPUT)/EFI/OC/Drivers/
	@cp -rf src/Drivers/HfsPlus.efi $(OUTPUT)/EFI/OC/Drivers/
	@cp -rf src/Drivers/VBOXHfs.efi $(OUTPUT)/EFI/OC/Drivers/
	@rm -rf $(OUTPUT)/EFI/OC/Drivers/NvmExpressDxe.efi
	@rm -rf $(OUTPUT)/EFI/OC/Drivers/HiiDatabase.efi
	@rm -rf $(OUTPUT)/EFI/OC/Drivers/XhciDxe.efi

Kexts:
	@echo "Applying Kext"
	@cp -rf src/Kexts/* $(OUTPUT)/EFI/OC/Kexts/

Resources:
	@echo "Applying Resources"
	@cp -rf src/Resources $(OUTPUT)/EFI/OC/




.PHONY: install
install:
	sudo diskutil mount disk3s1
	rm -rf /Volumes/EFI/EFI/*
	cp -rf $(OUTPUT)/EFI /Volumes/EFI/
	rm -rf /Volumes/EFI/EFI/OC/config.plist.org
	sync
	sudo diskutil unmountDisk disk3




all: clean patches drivers board_reference_files drivers Kexts Resources

clean:
	-@rm -rf output/*

