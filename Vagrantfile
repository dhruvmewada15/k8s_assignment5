Vagrant.configure("2") do |config|  
  config.vm.define :master do |master|
    master.vm.provider "virtualbox" do |master_system|
      master_system.cpus = 2
      master_system.memory = 2048
    end
    master.vm.box = "ubuntu/xenial64"
    master.vm.hostname = "master"
    master.vm.network :private_network, ip: "100.0.0.1"  
  config.vm.provision "shell", path: "script.sh"  
  end

  %w{worker1 worker2}.each_with_index do |name, i|
    config.vm.define name do |worker|
      worker.vm.provider "virtualbox" do |worker_system|
        worker_system.cpus = 1
        worker_system.memory = 1024
      end
      worker.vm.box = "ubuntu/xenial64"
      worker.vm.hostname = name
      worker.vm.network :private_network, ip: "100.0.0.#{i + 2}"
    config.vm.provision "shell", path: "script.sh"  
    end
  end
end



