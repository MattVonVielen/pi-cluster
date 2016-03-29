# -*- mode: ruby -*-
# vi: set ft=ruby :

## This VM needs USB to be able to write images to SD card.
## That requires the Virtualbox extension pack from http://virtualbox.org
##
## These settings are passed to Virtualbox to automatically capture your USB
## sdcard reader. You can find the right settings for your hardware by
## connecting it to your host and running `VBoxManage list usbhost`
##
## Internal SD card reader: MacBook Pro (Retina, 15-inch, Mid 2014)
macbook_sd = {vendor_id: "05AC", product_id: "8406"}
## Lexar included reader: http://www.amazon.com/dp/B00XWPAJ1U
lexar_usb3_usd = {vendor_id: "05DC", product_id: "B051"}
## Kingston included reader: http://www.amazon.com/dp/B004UG41YQ
kingston_usb2_usd = {vendor_id: "05E3", product_id: "0736"}
## Targus SD (old)
targus_usb2_sd = {vendor_id: "058F", product_id: "6331"}

USB_DEVICE = lexar_usb3_usd

## These CPU and memory settings are almost definitely overkill
## Feel free to reduce them to whatever you want (or remove them in favor
## of upstream box defaults).
CPUS = 2
MEMORY = 2048

Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-14.04"

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

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpus", CPUS]
    vb.customize ["modifyvm", :id, "--memory", MEMORY]
    # Enable virtual USB controller and automatic capture of selected device
    vb.customize ["modifyvm", :id, "--usbxhci", "on"] # Enable USB 3.0 and older
    vb.customize ["usbfilter", "add", "0", "--target", :id,
                  "--name", "MicroSD",
                  "--vendorid", USB_DEVICE[:vendor_id],
                  "--productid", USB_DEVICE[:product_id]]
  end

  config.vm.provider "vmware_fusion" do |vm|
    vm.vmx["numvcpus"] = CPUS
    vm.vmx["memsize"] = MEMORY
    # Enable virtual USB controller and automatic capture of selected device
    vm.vmx["usb.present"] = "TRUE"
    vm.vmx["usb_xhci.present"] = "TRUE"
    vm.vmx["usb.autoConnect.device0"] = "0x#{USB_DEVICE[:vendor_id]}:0x#{USB_DEVICE[:product_id]}"
  end

  config.vm.provision "shell", inline:<<-EOF
    apt-get -y install apt-cacher-ng
    echo 'Acquire::http { Proxy "http://127.0.0.1:3142"; };' > /etc/apt/apt.conf.d/00proxy
    apt-get update
    apt-get -y install bmap-tools debootstrap qemu-user-static ubuntu-keyring whois
  EOF
end
