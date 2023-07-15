# OpenWrt on any x86 device

## requirements

- GParted or Finnix OS (Live lightweight bootable image)
- Above 1GB Pen drive
- Utility software like (Rufus, Balena ecther)
- internet

## STEP 1 - Create the bootable USB device and boot from it

## STEP 2 - Get link from Gparted or another device

- Visit https://downloads.openwrt.org/
- Select the latest stable version
- Select x86 -> 64

## STEP 3 - Download required image

Select any of the image tagged with squashfs or squashfs and efi if you are
installing with uefi support.

### Run on Gparted or finnix (e.g)

```bash
## Do not forget to replace with you own url.
wget https://downloads.openwrt.org/releases/22.03.0/targets/x86/64/openwrt-22.03.0-x86-64-generic-squashfs-combined-efi.img.gz
```

## STEP 4 - Unzip image

```bash
gzip -d openwrt-*-generic-squashfs-combined-efi.img.gz
```

## STEP 5 - Write to disk

Check device disk name

```bash
lsblk

## You'd likely see couple of disk like sda,sdb but sda is likely your
## persistent disk that should be targeted.
```

Now write to disk with this command

```bash
dd if=openwrt-*-generic-squashfs-combined-efi.img of=/dev/sda


```

## Resize the main partition

On Gparted use GUI to resize the partition to remaining unallocated space.

### Using finnix OS

You can check your the size for partition 2 (contain writable file system)
on sda disk by running `lsblk`

```bash
fdisk /dev/sda

# Select p to print partition informations
# Take note of the partition 2 start value
# Select d to delete partion 2
# Select 2 to choose partition 2
# Select n to recreate partition 2
# Select 2 to choose partition 2
# Enter the initial start value for partition 2
# Press enter again to use remaining disk space
# Select n to keep squashfs signature
# select w to write changes to partition
```

## Sync change to filesystem

```bash
resize2fs /dev/sda
e2fsck -f /dev/sda
```

## Add root password

After the reboot

- Press Enter key
- inpute `passwd` to select new password

There's one more problem to resolve, the disk size is only 256M
which is probably not enough to store new packages and other stuff.
