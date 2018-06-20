require 'spec_helper'
require 'docker'
require 'serverspec'

    describe "test Dockerfile" do
      before(:all) do
	#Docker.authenticate!('username' => ENV['DOCKER_USERNAME'], 'password' => ENV['DOCKER_PASSWORD'])
        #@image = Docker::Image.build_from_dir('docker')
	#let(:image) { Docker::Image.build_from_dir('.') }
	#@imageid = %x( docker images | grep shaikimranashrafi/httpd | awk 'NR==1{print $3;exit}' )
	@image = Docker::Image.get('imageid')

        set :os, family: :RedHat
	#set :os, family: :Linux
        set :backend, :docker
        set :docker_image, @image.id

      @container = Docker::Container.create(
          'Image'      => @image.id,
        )
        @container.start
       end
     
    #describe 'Tomcat Daemon' do
     #it 'is listening on port 8080' do
      #expect(port(8080)).to be_listening
     #end
     #it 'has a running service of tomcat' do
     # expect(service('tomcat')).to be_running
     #end
   #end

    describe group('tomcat') do
     it { should exist }
    end

    describe user('tomcat') do
     it { should exist }
     it { should belong_to_group 'tomcat' }
    end

    describe file('/usr/local/tomcat') do
      it { should be_directory }
    end

     describe file('/usr/local/tomcat/conf/server.xml') do
      ## validate file exists in the container
      it { should exist }
      it { should be_owned_by 'tomcat' }
      it { should be_writable.by_user('tomcat') }
      it { should be_readable.by_user('tomcat') }
     end
    
     describe file('/usr/local/tomcat/bin/catalina.sh') do
        it { should be_owned_by 'tomcat' }
        it { should be_executable.by_user('tomcat') }
        it { should be_writable.by_user('tomcat') }
        it { should be_readable.by_user('tomcat') }
     end

     describe file('/usr/local/tomcat/webapps/ROOT/WEB-INF/imran.war') do
	it { should exist }
	it { should be_owned_by 'tomcat' }
     end

    after(:all) do
      @container.stop
      @container.kill
      @container.kill(:signal => "SIGHUP")
      @container.delete(:force => true)
      #sleep 5     
      #@image.remove(:force => true)
      #we can use image.remove(:force => true) let(:image) is define###
    end
 end
