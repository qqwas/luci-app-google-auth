-- Copyright 2019 Snow
-- Licensed to the public under the Apache License 2.0.
module("luci.controller.google-auth", package.seeall)
function index()
	if not nixio.fs.access("/etc/config/google-auth") then
		return
	end
	local page
	page = entry({"admin", "services", "google-auth"}, cbi("google-auth"), _("Google二次验证"), 100)
	page.dependent = true
end
