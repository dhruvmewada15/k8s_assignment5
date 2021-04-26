Vagrant.configure("2") do |config|
  config.vm.define "master" do |master|
    master.vm.box_download_insecure = true    
    master.vm.box = "hashicorp/bionic64"
    master.vm.network "private_network", ip: "192.168.56.101"
    master.vm.hostname = "master"
    master.vm.provider "virtualbox" do |v|
      v.name = "master"
      v.memory = 2048
      v.cpus = 2
    end
    master.vm.provision "shell", path: "script.sh"
  end
  %w{worker1 worker2}.each_with_index do |name, i|
    config.vm.define name do |worker|
      worker.vm.box_download_insecure = true 
      worker.vm.box = "hashicorp/bionic64"
      worker.vm.network "private_network", ip: "192.168.56.#{i + 102}"
      worker.vm.hostname = name
      worker.vm.provider "virtualbox" do |v|
        v.name = name
        v.memory = 1024
        v.cpus = 1
      end
      worker.vm.provision "shell", path: "script.sh"
    end
  end
end