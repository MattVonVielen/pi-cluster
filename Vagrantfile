# -*- mode: ruby -*-
# vi: set ft=ruby :

## These IDs are for the internal SD card reader in a MacBook Pro (Retina, 15-inch, Mid 2014)
##
## Find the right settings for your hardware by connecting it to your host
## and running `VBoxManage list usbhost`
USB_VENDOR_ID = "05AC"
USB_PRODUCT_ID = "8406"

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.synced_folder ".", "/vagrant", type: "nfs"
  config.vm.network "private_network", type: "dhcp" # need this for nfs

  # OMG seriously, you want this plugin. Unless you miraculously get your build
  # right the very first time, this will save you a ton of downloading time on
  # subsequent builds.
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
    config.cache.synced_folder_opts = {
      type: :nfs,
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
  end

  ## This VM needs USB to be able to write images to SD card.
  ## That requires the Virtualbox extension pack from http://virtualbox.org
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--usbxhci", "on"] # Enable USB 3.0 and older
    # This VM, when running, will automatically attach USB devices matching
    # the filter before the host OS can. We use this for the microSD writer.
    vb.customize ["usbfilter", "add", "0", "--target", :id, "--name", "MicroSD",
        "--vendorid", USB_VENDOR_ID, "--productid", USB_PRODUCT_ID]
  end

  config.vm.provision "shell", inline:<<-EOF
    apt-get update
    apt-get -y install apt-cacher-ng bmap-tools debootstrap qemu-user-static ubuntu-keyring
  EOF
end
