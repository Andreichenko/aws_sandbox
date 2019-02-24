Vagrant.configure("2") do |config|
    #Vagrant box deployment machine
    #Centos 7.5 official
    #20 GB HDD, nothing extra

   config.vm.box = "centos/7"
   config.vm.box_version = "1901.01"

  # config private network for VM
  config.vm.network :private_network, ip: "192.168.50.10"

  #Host name
  config.vm.hostname = "FInstance"

  #SSH configure
  config.ssh.insert_key = false

  #Provider configure
  config.vm.provider "virtualbox" do |vb|

    #Virual box name
    vb.name = "FInstance"

    #Customiztion CPU and memory
    # 2048 memmory CPU execution 30
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "30"]
    vb.memory = "2048"
  end
  #Docker, appc, nodejs install with use shell
  # also install jq curl wget
  config.vm.provision "shell", inline: <<-SHELL
  
  yum install -y yum-utils jq curl wget net-tools
  
  # actual Docker Installation
  yum-config-manager --add-repo \
      https://download.docker.com/linux/centos/docker-ce.repo
    yum-config-manager --enable docker-ce-edge
    yum install -y docker-ce

  # restart docker
  systemctl enable docker
  systemctl start docker
  usermod -aG docker vagrant

  # install epel release
  curl --silent --location https://rpm.nodesource.com/setup_10.x | sudo bash -
  yum install epel-release -y
  
  #install node js
  sudo yum install -y nodejs
  sudo yum install git awscli golang:1.8.3 -y
  
  #install appcelerator and appc 
  npm install appcelerator -g
  appc setup
  ln -s ".appcelerator/install/7.0.9/package/appc.json" ~/appc.json
  SHELL

    
end