--Create By Xuezhou
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"
function guid()
		math.randomseed(os.time())
		local seed="ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
		local tb={}
		local inttmp=1
		for i=1,32 do
			inttmp=math.random(1,32)
			table.insert(tb,string.sub(seed,inttmp,inttmp))
		end
		local sid=table.concat(tb)
		return sid
   end

if (string.len(SYS.exec("uci get google-auth.config.seckey"))) <2 then
		local seckey = guid()
	    local x = luci.model.uci.cursor()
		x:set("google-auth","config","seckey",seckey)
		x:commit("google-auth")	
end
m = Map("google-auth")
m.title	= translate("二次验证设置")
m.description = translate("使用Google Authenticator二次验证")

s = m:section(TypedSection, "google-auth")
s.addremove = false
s.anonymous = true

enable = s:option(Flag, "enabled", "启用")
enable.rmempty = false
--recreat =s:option(Flag,"recreat","重置密钥")
--key = s:option(Value,"seckey","密钥","不要修改！！！")
--key:depends("recreat","1")
button_keycreat = s:option(Button,"_keycreat","重新生成：","重新生成后，请删除原来绑定，重新扫码绑定")
button_keycreat:depends("enabled","1")
button_keycreat.inputtitle = translate ( "重新生成密钥")
button_keycreat.inputstyle = "apply"
function button_keycreat.write (self, section, value)
	local seckey = guid()
	local x = luci.model.uci.cursor()
	x:set("google-auth","config","seckey",seckey)
	x:commit("google-auth")	
	HTTP.redirect(DISP.build_url("admin", "services", "google-auth"))
end 

m:section(SimpleSection).template  = "google-auth/google_auth"
    
    local apply = luci.http.formvalue("cbi.apply")
	if apply then
		--[[
			需要处理的代码
		]]--
	end
	
    
return m
