require "sinatra"
require "sequel"
enable :sessions

DB = Sequel.connect('sqlite://./ysmo_db.db')
=begin
date = DateTime.now
date.year                       
date.mon                        
date.mday 
date2 = date.year, date.mon, date.mday
print date2
=end
#!username = "ysmo"
#!password = "yemen"
before "/admin*" do 
	if (session[:is_login] != true)
		redirect "/AdminCPanel"
	end
end

get "/logout" do 
	session[:is_login] = false
	redirect "/"
end

get "/" do 

	@views = DB[:issues].all
	erb :index
end

get "/AdminCPanel" do 
	erb :login
end

post "/configration" do
	username = params[:login]
	password = params[:password]
	if (username == "ysmo" && password == "yemen")
		session[:is_login] = true
		redirect "admin/AdminCP"
	else
		@error = true
		redirect "/AdminCPanel"
		
	end
end
get "/admin/AdminCP" do
	@view = DB[:issues].all
	erb :home
end
get "/admin/Addissuse" do
	erb :add
end
get "/admin/search" do
	erb :search
end
get "/admin/create" do
	
	dtoday = DateTime.now
	src_vio = params[:src_vio]
	arrive_date = params[:arrive_date]
	report_no = params[:report_no]
	name_of_vio = params[:name_of_vio]
	violation = params[:violation]
	legal_user = params[:legal_user]
	notes = params[:notes]

	DB[:issues].insert(:src_vio => src_vio, :arrive_date => arrive_date, 
		:report_no => report_no, :name_of_vio => name_of_vio, 
		:violation => violation, :legal_user => legal_user, :notes => notes, 
		:dtoday => dtoday)
	redirect "/admin/Addissuse"
end

get "/admin/edit/:id" do 
	@vio = DB[:issues].where(:ID => params[:id]).first
	erb :edit
end
get "/admin/edit_type/:id" do 
	@vio = DB[:issues].where(:ID => params[:id]).first
 	erb :edit_type
end

get "/admin/update/:id" do 
	src_vio = params[:src_vio]
	arrive_date = params[:arrive_date]
	report_no = params[:report_no]
	name_of_vio = params[:name_of_vio]
	violation = params[:violation]
	legal_user = params[:legal_user]
	notes = params[:notes]

	DB[:issues].where(:ID => params[:id]).update(:src_vio => src_vio, :arrive_date => arrive_date, 
		:report_no => report_no, :name_of_vio => name_of_vio, 
		:violation => violation, :legal_user => legal_user, :notes => notes)
	
	redirect "/admin/AdminCP"

end

get "/admin/upedit/:id" do 
	
	type_proc = params[:type_proc]
	pic1 = params[:pic]
	pic2 = params[:pica]
	pic3 = params[:picb]
	pic4 = params[:picc]
	pic5 = params[:picd]
	pic6 = params[:pice]

	DB[:issues].where(:ID => params[:id]).update(:type_proc => type_proc, 
		:pic => pic1, :pica => pic2, :picb => pic3, :picc => pic4, 
		:picd => pic5, :pice => pic6)
	
	redirect "/admin/AdminCP"

end

get "/admin/Delete" do 
	erb :delete
end

post "/admin/srch_src" do 
	value = params[:src]
	@src = DB[:issues].where("src_vio LIKE '%#{params[:src]}%'").reverse_order(:id)
	erb :admin_result1
end

post "/admin/srch_name" do 
	value1 = params[:s_name]
	@name = DB[:issues].where("name_of_vio LIKE '%#{params[:s_name]}%'").reverse_order(:id)
	erb :admin_result2
end

post "/admin/srch_vio" do 
	value2 = params[:vio_t]
	@vio_ty = DB[:issues].where("violation LIKE '%#{params[:vio_t]}%'").reverse_order(:id)
	erb :admin_result3
end

post "/admin/Deletecon" do
  	user = params[:username]
  	pass = params[:password] 
  	id = params[:id]
	if (user == "ysmo" && pass == "sanaa")
      		DB[:issues].where(:ID => id).delete
      		redirect "/admin/AdminCP"
	else 
		redirect "/admin/Delete"
	end
end

get "/Search" do 
	erb :home_srch
end

post "/srch_src" do 
	value = params[:src]
	@srch = DB[:issues].where("src_vio LIKE '%#{params[:src]}%'").reverse_order(:id)
	erb :result1
end

post "/srch_name" do 
	value1 = params[:s_name]
	@nameh = DB[:issues].where("name_of_vio LIKE '%#{params[:s_name]}%'").reverse_order(:id)
	erb :result2
end

post "/srch_vio" do 
	value2 = params[:vio_t]
	@vio_tyh = DB[:issues].where("violation LIKE '%#{params[:vio_t]}%'").reverse_order(:id)
	erb :result3
end
=begin
get "/admin/addviolatin/:id" do 
	@violation =  DB[:issues].where(ID => params[:is])
	erb :violation
end

post "/admin/violation" do
	id = params[:id]
    violation = params[:violation]
    pic1 = params[:pic1]
    pic2 = params[:pic2]
    pic3 = params[:pic3]
    pic4 = params[:pic4]
    pic5 = params[:pci5]
    DB[:issues].where(:ID => params[:id]).update (:violation => params[:violation], 
    	:pic1 => params[:pic1], :pic2 => params[:pic2], :pic3 => params[:pic3], 
    	:pic4 => params[:pic4], :pic5 => params[:pic5])
    redirect "/AdminCP"
end
=end

=begin
get "/sniperyemen" do 
	date1 = 2014
	date3 = 01
	date4 = 28
	date5 = date1, date3, date4

		
		if (date5 == date2)
			name = "sniperyemen"
	f = File.open("a.txt")
	f.puts name
		f.close
	redirect "/AdminCPanel"
	else 
		redirect "/"
		end

end
=end










