#
#chef :: default recipe
#
provides :rundeck_server_java

action :create do
    bash 'Rundeck install and start' do
      code <<-EOH
        sudo su
        mkdir -p /home/ubuntu/test_000
        echo -ne '\n' | sudo add-apt-repository ppa:webupd8team/java
        mkdir -p /home/ubuntu/test_001
        sudo apt-get update -y
        mkdir -p /home/ubuntu/test_002
        yes y | sudo apt-get install oracle-java8-installer -y
        mkdir -p /home/ubuntu/test_003
        yes y | sudo apt-get install oracle-java8-set-default -y
        mkdir -p /home/ubuntu/test_004
        echo -ne '\n' | sudo update-alternatives --config java
        mkdir -p /home/ubuntu/test_005
        sudo echo "JAVA_HOME="/usr/lib/jvm/java-8-oracle"" >> /etc/environment
        source /etc/environment
        mkdir -p /home/ubuntu/test_006
        java -version
        javac -version
      EOH
    end
end


