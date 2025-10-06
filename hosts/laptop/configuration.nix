# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    extraEntries = ''
            menuentry 'Windows Boot Manager (on /dev/nvme0n1p1)' --class windows --class os $menuentry_id_option 'osprober-efi-A0B0-385E' {
        	insmod part_gpt
      	insmod fat
      	search --no-floppy --fs-uuid --set=root A0B0-385E
      	chainloader /EFI/Microsoft/Boot/bootmgfw.efi
            }
            menuentry 'Arch Linux (on /dev/nvme0n1p4)' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-simple-ec68d035-92e0-4077-90eb-77946737b4a4' {
      	insmod part_gpt
      	insmod ext2
      	search --no-floppy --fs-uuid --set=root ec68d035-92e0-4077-90eb-77946737b4a4
      	linux /boot/vmlinuz-linux root=UUID=ec68d035-92e0-4077-90eb-77946737b4a4 rw loglevel=3 quiet
      	initrd /boot/initramfs-linux.img
            }
            submenu 'Advanced options for Arch Linux (on /dev/nvme0n1p4)' $menuentry_id_option 'osprober-gnulinux-advanced-ec68d035-92e0-4077-90eb-77946737b4a4' {
      	menuentry 'Arch Linux (on /dev/nvme0n1p4)' --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-/boot/vmlinuz-linux--ec68d035-92e0-4077-90eb-77946737b4a4' {
      	  insmod part_gpt
      	  insmod ext2
      	  search --no-floppy --fs-uuid --set=root ec68d035-92e0-4077-90eb-77946737b4a4
      	  linux /boot/vmlinuz-linux root=UUID=ec68d035-92e0-4077-90eb-77946737b4a4 rw loglevel=3 quiet
      	  initrd /boot/initramfs-linux.img
      	}
      	menuentry 'Arch Linux, with Linux linux (on /dev/nvme0n1p4)' --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-/boot/vmlinuz-linux--ec68d035-92e0-4077-90eb-77946737b4a4' {
      	  insmod part_gpt
      	  insmod ext2
      	  search --no-floppy --fs-uuid --set=root ec68d035-92e0-4077-90eb-77946737b4a4
      	  linux /boot/vmlinuz-linux root=UUID=ec68d035-92e0-4077-90eb-77946737b4a4 rw loglevel=3 quiet
      	  initrd /boot/initramfs-linux.img
      	}
      	menuentry 'Arch Linux, with Linux linux (fallback initramfs) (on /dev/nvme0n1p4)' --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-/boot/vmlinuz-linux--ec68d035-92e0-4077-90eb-77946737b4a4' {
      	  insmod part_gpt
      	  insmod ext2
      	  search --no-floppy --fs-uuid --set=root ec68d035-92e0-4077-90eb-77946737b4a4
      	  linux /boot/vmlinuz-linux root=UUID=ec68d035-92e0-4077-90eb-77946737b4a4 rw loglevel=3 quiet
      	  initrd /boot/initramfs-linux-fallback.img
      	}
            }
    '';
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "dimitri"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # networking.nameservers = [ "1.1.1.1" ];
  # networking.resolvconf.enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "ctrl:nocaps";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dimitri = {
    isNormalUser = true;
    description = "dimitri";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "docker" "wheel" ];
    packages = with pkgs; [ ];
  };

  programs.firefox.enable = true;
  programs.thunderbird.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.theme = "edvardm";
  };

  programs.git = { enable = true; };

  programs.npm = { enable = true; };

  virtualisation.docker = { enable = true; };

  environment.systemPackages = with pkgs; [
    kitty
    mpv
    brave
    gnomeExtensions.forge
    rustup
    gcc
    unzip
    joplin-desktop
    fzf
    nnn
    btop
    ripgrep
    vscodium
    openssl
    libreoffice
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
