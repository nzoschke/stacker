Vagrant::Config.run do |config|
  config.vm.box = "lucid64"
  config.vm.box_url = "http://files.vagrantup.com/lucid64.box"

  config.vm.provision :shell, :inline => <<-EOF
    (
      apt-get update
      apt-get install --yes python-software-properties
    ) > /dev/null
  EOF

  config.vm.share_folder("stacklets", "/tmp/stacklets", "stacklets/")
end