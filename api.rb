require 'rubygems'
require 'mysql'
require "sinatra/base"
require 'pp'


def getconfigs(ip,con)
	tmphash = Hash.new
	puts "SELECT distinct file,setting,value,date  from pcheck_config where ip = \"#{ip}\" order by date desc"
	res = con.query "SELECT distinct file,setting,value,date  from pcheck_config where ip = \"#{ip}\" order by date desc"
	puts "Finished query"
	
	res.each_hash do |row|
		file = row['file']
		setting = row['setting']
		value = row['value']
		date = row['date']
		
		if tmphash[file] == nil
			tmphash[file] = Hash.new
		end
		if tmphash[file][setting] == nil
			tmphash[file][setting] = Array.new
		end
		if date != nil and value != nil
			tmphash[file][setting].push(date + "|" + value)
		end
	end
	return tmphash
end

def uploadconfig(oldconfig,config,insert_config,filename,ip,hostname,update_config) #,update_config)
	amount = 0
	datetime = Time.new.strftime("%Y-%m-%d %H:%M:%S")
	datenow = Time.new.strftime("%Y-%m-%d")
	puts "#{datetime} => Checking the configuration of #{filename} with #{config.length} elements"

	config.each do |hash| 
		hash.each do |key, value|
			checked = false
		  
			if oldconfig != nil and oldconfig[filename] != nil and oldconfig[filename][key] != nil

			  	oldconfig[filename][key].each do |turn|
				  	if turn.include?("|") and turn.split("|").length > 1
				  		thedate = turn.split("|")[0]
				  		thevalue = turn.split("|")[1..-1].join("|")
				  		if thevalue == value
				  			puts "#{Time.now}: No update for #{ip} and file #{filename} setting #{key} value #{thevalue} since it exists"
					  		update_config.execute datetime, ip, filename, key, thevalue, thedate
					  		checked = true
					  		break
			  			end
				  	end
				  end
			end

		            if checked == false
		            	if value != nil
					amount = amount + 1
			  		insert_config.execute ip, hostname, datetime, filename, key, value.strip, datenow
		  			puts "#{Time.now}: Uploading #{key} with value #{value} for filename #{filename}"
		  		end
	      	   	 end
		end
	end
	puts "Configuration for file #{filename} has been uploaded"
	return amount
end

#

def getuploaded(con,hostname,ip)

  date = ""
  all = Array.new

  resp = con.query("SELECT distinct date from pcheck_packages WHERE ip = \"#{ip}\" and hostname = \"#{hostname}\" order by date desc limit 1; ")
  resp.each_hash do |row|
          date = row['date']
          break
  end

  resp = con.query("SELECT package,parch from pcheck_packages where ip = \"#{ip}\" and hostname = \"#{hostname}\" and date = \"#{date}\" ; ")

  resp.each_hash do |row|
      tmphash = Hash.new
      tmphash['paquete'] = row['package']
      tmphash['parche'] = row['parch']
      all.push(tmphash)
  end

  return all
end

def keepalive(con)
	while(1)
		con.query("SELECT 1 from pcheck_packages limit 1")
		sleep 60
	end
end

def insert_packet(insert_patch,con,request,hash,hostname)
  begin
    insert_patch.execute request.ip, hash['paquete'], hash['parche'], Time.new.strftime("%Y-%m-%d %H"), hostname, Time.new.strftime("%Y-%m-%d %H:%M:%S")
    puts "Packet #{hash['paquete']} - Version #{hash['parche']} from #{request.ip} !"
  rescue
    puts "Packet already pushed #{hash['paquete']} - Version #{hash['parche']} from #{request.ip}!"
  end
end

def get_sudoers(data)
	response = Array.new
	data.split("\n").each do |line|
		tmphash = Hash.new
		line = line.strip.gsub(/\s+/, " ")
		if line.start_with?("#") or line == " " or line == "" or line.length < 5
			next
		end

		if line.include?(" ") and !line.include?("\\")
			user = line.split(" ")[0].upcase
			tmphash[user] = line #.split(":")[1..-1].join(":")
		end

		if tmphash.length > 0
			response.push(tmphash)
		end
	end	
	return response
end


def get_chkconfig(data)
	lines = data.split("\n")
	response = Array.new
	lines.each do |line|
		tmphash = Hash.new
		line = line.strip.gsub(/\s+/, " ")
		if line.start_with?("#") or line == " " or line == "" or line.length < 5
			next
		end

		if line.include?(" ")
			app = line.split(" ")[0].upcase
			tmphash[app] = line #.split(":")[1..-1].join(":")
		end

		if tmphash.length > 0
			response.push(tmphash)
		end
	end
	
	#puts "Termino de revisar chkconfig"
	return response
end

def get_mount_file(data)
	response = Array.new
	
	data.split("\n").each do |line|
		tmphash = Hash.new
		line = line.strip.gsub(/\s+/, " ")
		if line.start_with?("#") or line == " " or line == "" or line.length < 5
			next
		end
		tmphash["MOUNT"] = line
		if tmphash.length > 0
			response.push(tmphash)
		end
	end
	return response
end

def get_packets(rawdata)
  packages = Array.new

  rawdata.split("\n").each do |line|
          if line[0].chr == "i"
            line = line.split(" ")
            paquete = line[1]
            parche = line[2]
            tmphash = Hash.new
            tmphash['paquete'] = paquete
            tmphash['parche'] = parche
            packages.push(tmphash)
          end
  end
  return packages
end

def connectlocal()
  begin
      con = Mysql.new 'localhost', 'root' , 'root' , 'check_config' 
      puts "Conecto a mysql!"
      rs = con.query 'SELECT VERSION()'
  rescue Mysql::Error => e
      puts e.errno
      puts e.error
      abort ("Error connecting to the database")
  ensure
      #con.close if con
  end

  return con
end


class MyApp < Sinatra::Base

con = connectlocal()

insert_patch = con.prepare "INSERT INTO check_packages(ip,package,parch,date,hostname,datetime) VALUES(?,?,?,?,?,?)"
insert_config = con.prepare "INSERT INTO check_config(ip,host,datetime,file,setting,value,date) VALUES(?,?,?,?,?,?,?)"
update_config = con.prepare "UPDATE check_config set updatedate = ? where ip = ? and file = ? and setting = ? and value = ? and date = ?"

puts "Starting API"

Thread.new {
	keepalive(con)
}

post '/pcheck/upload' do
     puts Time.now.strftime("%Y-%m-%d %H:%M:%S") +  "=>APPStart "

     #ip = request.ip
     ip = @env['HTTP_X_FORWARDED_FOR']
     hostname = "myhost"
     filename = params['data'][:filename]
     oldconfig = getconfigs(ip,con)
     
     cantidad = 0
     
     if filename == "dpkg.tmp"
	     data = params['data'][:tempfile].read

	     received_packets = get_packets(data)
	     stored = getuploaded(con,hostname,ip)
			
	     req = 0
	     diff = received_packets - old
	
	     diff.each do |hash|
	           req = req + 1
	           insert_packet(insert_patch,con,request,hash,hostname)
	     end
	
	      puts "DPKG Processed"
	elsif filename == "sudoers"
		data = params['data'][:tempfile].read
		config = get_sudoers(data)
		cantidad = uploadconfig(oldconfig,config,insert_config,filename,ip,hostname,update_config)
		puts Time.now.strftime("%Y-%m-%d %H:%M:%S") + " => Subi #{cantidad} elementos para #{filename}"
	elsif filename == "chkconfig.tmp"
		data = params['data'][:tempfile].read
		config = get_chkconfig(data)
		cantidad = uploadconfig(oldconfig,config,insert_config,filename,ip,hostname,update_config)
		puts Time.now.strftime("%Y-%m-%d %H:%M:%S") + " => Subi #{cantidad} elementos para #{filename}"
	end
	
	if config != nil
		return "#{cantidad} elements were uploaded for #{filename}\n"
	else
		return "File #{filename} was uploaded\n"
	end
end

	if ARGV[0] == "debug"
		run!
	end

end
