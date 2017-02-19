--Start By @Tele_Sudo
local function run(msg, matches)

if matches[1] == 'kickme' then
local hash = 'kick:'..msg.chat_id_..':'..msg.sender_user_id_
     redis:set(hash, "waite")
      return '👤کاربر عزیز🔖\nشما درخواست اخراج خود از گروه را ارسال کردید\nاگر با این درخواست موافقت دارید عبارت yes را ارسال کنید،در غیر این صورت عبارت no را ارسال کنید✅'
    end
msg.text = msg.content_.text_
    if msg.text then
	local hash = 'kick:'..msg.chat_id_..':'..msg.sender_user_id_
     if msg.text:match("^yes$") and redis:get(hash) == "waite" then
	  redis:set(hash, "ok")
	elseif msg.text:match("^no$") and redis:get(hash) == "waite" then
	tdcli.sendMessage(msg.chat_id_, 0, 1, 'مرض داری؟😕', 1, 'md')
	  redis:del(hash, true)
      end
    end
	local hash = 'kick:'..msg.chat_id_..':'..msg.sender_user_id_
	 if redis:get(hash) then
        if redis:get(hash) == "ok" then
		     kick_user(msg.sender_user_id_,msg.chat_id_) 
         return '❌کاربر مورد نظر بنابر در خواست خود از گروه اخراج شد🚫'
        end
      end
    end

return {
  patterns = {
 "[+�$*]([Kk][Ii][Cc][Kk][Mm][Ee])",
 "kickme",
  "^yes$",
  "^no$"
  },
  run = run,
}
--End By @Tele_Sudo
--Channel @LuaError