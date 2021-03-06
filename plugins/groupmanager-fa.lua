local function modadd(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    if not is_admin(msg) then
   if not lang then
        return '_You are not bot admin_'
else
     return '_شما مدیر ربات نمیباشید_'
    end
end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.chat_id_)] then
if not lang then
   return '_Group is already added_'
else
return '_گروه در لیست گروه های مدیریتی ربات هم اکنون موجود است_'
  end
end
        -- create data array in moderation.json
      data[tostring(msg.chat_id_)] = {
              owners = {},
      mods ={},
      banned ={},
      is_silent_users ={},
      filterlist ={},
      settings = {
          lock_link = 'yes',
          lock_tag = 'yes',
		  lock_fosh = 'yes',
          lock_spam = 'no',
          lock_webpage = 'yes',
		  lock_arabic = 'no',
          lock_markdown = 'yes',
          flood = 'yes',
          lock_bots = 'yes',
          welcome = 'yes'
          },
   mutes = {
                  mute_forward = 'no',
                  mute_audio = 'no',
                  mute_video = 'no',
                  mute_contact = 'no',
                  mute_text = 'no',
                  mute_photos = 'no',
                  mute_gif = 'no',
                  mute_location = 'no',
                  mute_document = 'no',
                  mute_sticker = 'no',
                  mute_voice = 'no',
                  mute_all = 'no'
          }
      }
  save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.chat_id_)] = msg.chat_id_
      save_data(_config.moderation.data, data)
    if not lang then
  return '*Group has been added*'
else
  return '_گروه با موفقیت به لیست گروه های مدیریتی ربات افزوده شد_'
end
end

local function modrem(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
     if not lang then
        return '_You are not bot admin_'
   else
        return '_شما مدیر ربات نمیباشید_'
    end
   end
    local data = load_data(_config.moderation.data)
    local receiver = msg.chat_id_
  if not data[tostring(msg.chat_id_)] then
  if not lang then
    return '_Group is not added_'
else
    return '_گروه به لیست گروه های مدیریتی ربات اضافه نشده است_'
   end
  end

  data[tostring(msg.chat_id_)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.chat_id_)] = nil
      save_data(_config.moderation.data, data)
 if not lang then
  return '*Group has been removed*'
 else
  return '_گروه با موفیت از لیست گروه های مدیریتی ربات حذف شد_'
end
end

local function filter_word(msg, word)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
local data = load_data(_config.moderation.data)
  if not data[tostring(msg.chat_id_)]['filterlist'] then
    data[tostring(msg.chat_id_)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
if data[tostring(msg.chat_id_)]['filterlist'][(word)] then
   if not lang then
         return "_Word_ *"..word.."* _is already filtered_"
            else
         return "_کلمه_ *"..word.."* _از قبل فیلتر بود_"
    end
end
   data[tostring(msg.chat_id_)]['filterlist'][(word)] = true
     save_data(_config.moderation.data, data)
   if not lang then
         return "_Word_ *"..word.."* _added to filtered words list_"
            else
         return "_کلمه_ *"..word.."* _به لیست کلمات فیلتر شده اضافه شد_"
    end
end

local function unfilter_word(msg, word)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 local data = load_data(_config.moderation.data)
  if not data[tostring(msg.chat_id_)]['filterlist'] then
    data[tostring(msg.chat_id_)]['filterlist'] = {}
    save_data(_config.moderation.data, data)
    end
      if data[tostring(msg.chat_id_)]['filterlist'][word] then
      data[tostring(msg.chat_id_)]['filterlist'][(word)] = nil
       save_data(_config.moderation.data, data)
       if not lang then
         return "_Word_ *"..word.."* _removed from filtered words list_"
       elseif lang then
         return "_کلمه_ *"..word.."* _از لیست کلمات فیلتر شده حذف شد_"
     end
      else
       if not lang then
         return "_Word_ *"..word.."* _is not filtered_"
       elseif lang then
         return "_کلمه_ *"..word.."* _از قبل فیلتر نبود_"
      end
   end
end

local function modlist(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
  if not lang then
    return "_Group is not added_"
 else
    return "_گروه به لیست گروه های مدیریتی ربات اضافه نشده است_"
  end
 end
  -- determine if table is empty
  if next(data[tostring(msg.chat_id_)]['mods']) == nil then --fix way
  if not lang then
    return "_No_ *moderator* _in this group_"
else
   return "_در حال حاضر هیچ مدیری برای گروه انتخاب نشده است_"
  end
end
if not lang then
   message = '*List of moderators :*\n'
else
   message = '*لیست مدیران گروه :*\n'
end
  for k,v in pairs(data[tostring(msg.chat_id_)]['mods'])
do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function ownerlist(msg)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.chat_id_)] then
if not lang then
    return "_Group is not added_"
else
return "_گروه به لیست گروه های مدیریتی ربات اضافه نشده است_"
  end
end
  -- determine if table is empty
  if next(data[tostring(msg.chat_id_)]['owners']) == nil then --fix way
 if not lang then
    return "_No_ *owner* _in this group_"
else
    return "_در حال حاضر هیچ مالکی برای گروه انتخاب نشده است_"
  end
end
if not lang then
   message = '*List of moderators :*\n'
else
   message = '*لیست مدیران گروه :*\n'
end
  for k,v in pairs(data[tostring(msg.chat_id_)]['owners']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function action_by_reply(arg, data)
local hash = "gp_lang:"..data.chat_id_
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
if not tonumber(data.sender_user_id_) then return false end
    if data.sender_user_id_ then
  if not administration[tostring(data.chat_id_)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "_Group is not added_", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_گروه به لیست گروه های مدیریتی ربات اضافه نشده است_", 0, "md")
     end
  end
if cmd == "setowner" then
local function owner_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل صاحب گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is now the_ *group owner*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام صاحب گروه منتصب شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "promote" then
local function promote_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *moderator*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *promoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام مدیر گروه منتصب شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, promote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
     if cmd == "remowner" then
local function rem_owner_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *group owner*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* *از قبل صاحب گروه نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *group owner*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام صاحب گروه برکنار شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, rem_owner_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "demote" then
local function demote_cb(arg, data)
    local administration = load_data(_config.moderation.data)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *moderator*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر گروه نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *demoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام مدیر گروه برکنار شد*", 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, demote_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "id" then
local function id_cb(arg, data)
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, id_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
else
    if lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "_کاربر یافت نشد_", 0, "md")
   else
  return tdcli.sendMessage(data.chat_id_, "", 0, "*User Not Found*", 0, "md")
      end
   end
end

local function action_by_username(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "_Group is not added_", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_گروه به لیست گروه های مدیریتی ربات اضافه نشده است_", 0, "md")
     end
  end
if not arg.username then return false end
   if data.id_ then
if data.type_.user_.username_ then
user_name = '@'..check_markdown(data.type_.user_.username_)
else
user_name = check_markdown(data.title_)
end
if cmd == "setowner" then
if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل صاحب گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is now the_ *group owner*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام صاحب گروه منتصب شد*", 0, "md")
   end
end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *moderator*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *promoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام مدیر گروه منتصب شد*", 0, "md")
   end
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *group owner*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* *از قبل صاحب گروه نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *group owner*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام صاحب گروه برکنار شد*", 0, "md")
   end
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *moderator*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر گروه نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *demoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام مدیر گروه برکنار شد*", 0, "md")
   end
end
   if cmd == "id" then
    return tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
end
    if cmd == "res" then
    if not lang then
     text = "Result for [ ".. check_markdown(data.type_.user_.username_) .." ] :\n"
    .. "".. check_markdown(data.title_) .."\n"
    .. " [".. data.id_ .."]"
  else
     text = "اطلاعات برای [ ".. check_markdown(data.type_.user_.username_) .." ] :\n"
    .. "".. check_markdown(data.title_) .."\n"
    .. " [".. data.id_ .."]"
       return tdcli.sendMessage(arg.chat_id, 0, 1, text, 1, 'md')
      end
   end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر یافت نشد_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User Not Found*", 0, "md")
      end
   end
end

local function action_by_id(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
local cmd = arg.cmd
    local administration = load_data(_config.moderation.data)
  if not administration[tostring(arg.chat_id)] then
  if not lang then
    return tdcli.sendMessage(data.chat_id_, "", 0, "_Group is not added_", 0, "md")
else
    return tdcli.sendMessage(data.chat_id_, "", 0, "_گروه به لیست گروه های مدیریتی ربات اضافه نشده است_", 0, "md")
     end
  end
if not tonumber(arg.user_id) then return false end
   if data.id_ then
if data.first_name_ then
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
  if cmd == "setowner" then
  if administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *group owner*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل صاحب گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is now the_ *group owner*", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام صاحب گروه منتصب شد*", 0, "md")
   end
end
  if cmd == "promote" then
if administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is already a_ *moderator*", 0, "md")
else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر گروه بود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = user_name
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *promoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *به مقام مدیر گروه منتصب شد*", 0, "md")
   end
end
   if cmd == "remowner" then
if not administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] then
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *group owner*", 0, "md")
   else
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* *از قبل صاحب گروه نبود*", 0, "md")
      end
   end
administration[tostring(arg.chat_id)]['owners'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is no longer a_ *group owner*", 0, "md")
    else
return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام صاحب گروه برکنار شد*", 0, "md")
   end
end
   if cmd == "demote" then
if not administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] then
    if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _is not a_ *moderator*", 0, "md")
    else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از قبل مدیر گروه نبود*", 0, "md")
   end
  end
administration[tostring(arg.chat_id)]['mods'][tostring(data.id_)] = nil
    save_data(_config.moderation.data, administration)
   if not lang then
    return tdcli.sendMessage(arg.chat_id, "", 0, "_User_ "..user_name.." *"..data.id_.."* _has been_ *demoted*", 0, "md")
   else
    return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر_ "..user_name.." *"..data.id_.."* *از مقام مدیر گروه برکنار شد*", 0, "md")
   end
end
    if cmd == "whois" then
if data.username_ then
username = '@'..check_markdown(data.username_)
else
if not lang then
username = 'not found'
 else
username = 'ندارد'
  end
end
     if not lang then
       return tdcli.sendMessage(arg.chat_id, 0, 1, 'Info for [ '..data.id_..' ] :\nUserName : '..username..'\nName : '..data.first_name_, 1)
   else
       return tdcli.sendMessage(arg.chat_id, 0, 1, 'اطلاعات برای [ '..data.id_..' ] :\nیوزرنیم : '..username..'\nنام : '..data.first_name_, 1)
      end
   end
 else
    if not lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_User not founded_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر یافت نشد_", 0, "md")
    end
  end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_کاربر یافت نشد_", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User Not Found*", 0, "md")
      end
   end
end


---------------Lock Link-------------------
local function lock_link(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
if not lang then
 return "*Link* _Posting Is Already Locked_"
elseif lang then
 return "_ارسال ✽لینک✽ در گروه هم اکنون ممنوع است_"
end
else
data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Link* _Posting Has Been Locked_"
else
 return "_ارسال ✽لینک✽ در گروه با موفقیت ممنوع شد! و از این پس پاک خواهد شد_"
end
end
end

local function unlock_link(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then
if not lang then
return "*Link* _Posting Is Not Locked_" 
elseif lang then
return "_ارسال ✽لینک✽ در گروه ممنوع نمیباشد_"
end
else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Link* _Posting Has Been Unlocked_" 
else
return "_ارسال ✽لینک✽ در گروه آزاد شد_"
end
end
end



---------------Lock fosh-------------------
local function lock_fosh(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local lock_fosh = data[tostring(target)]["settings"]["lock_fosh"] 
if lock_fosh == "yes" then
if not lang then
 return "*Fosh* _Posting Is Already Locked_"
elseif lang then
 return "_ارسال ✽فحش✽ در گروه هم اکنون ممنوع است_"
end
else
data[tostring(target)]["settings"]["lock_fosh"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Fosh* _ Has Been Locked_"
else
 return "_ارسال ✽فحش✽  در گروه با موفقیت ممنوع شد! و از این پس پاک خواهد شد_"
end
end
end

local function unlock_fosh(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local lock_fosh = data[tostring(target)]["settings"]["lock_fosh"]
 if lock_fosh == "no" then
if not lang then
return "*Fosh* _Is Not Locked_" 
elseif lang then
return "_قفل ✽فحش✽ در گروه غیر فعال میباشد_"
end
else 
data[tostring(target)]["settings"]["lock_fosh"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Fosh* _Has Been Unlocked_" 
else
return "_قفل ✽فحش✽ در گروه غیر فعال شد_"
end
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then
if not lang then
 return "*Tag* _Posting Is Already Locked_"
elseif lang then
 return "_ارسال ✽تگ✽ در گروه هم اکنون ممنوع است_"
end
else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Tag* _Posting Has Been Locked_"
else
 return "_ارسال ✽تگ✽ در گروه  با موفقیت ممنوع شد! و از این پس پاک خواهد شد_"
end
end
end

local function unlock_tag(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end 
end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then
if not lang then
return "*Tag* _Posting Is Not Locked_" 
elseif lang then
return "_ارسال ✽تگ✽ در گروه ممنوع نمیباشد_"
end
else 
data[tostring(target)]["settings"]["lock_tag"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Tag* _Posting Has Been Unlocked_" 
else
return "_ارسال ✽تگ✽ در گروه آزاد شد_"
end
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
 local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then
if not lang then
 return "*Mention* _Posting Is Already Locked_"
elseif lang then
 return "_ارسال ✽فراخوانی افراد✽ در گروه هم اکنون ممنوع است_"
end
else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data)
if not lang then 
 return "*Mention* _Posting Has Been Locked_"
else 
 return "_ارسال ✽فراخوانی افراد✽ در گروه  با موفقیت ممنوع شد! و از این پس پاک خواهد شد_"
end
end
end

local function unlock_mention(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then
if not lang then
return "*Mention* _Posting Is Not Locked_" 
elseif lang then
return "_ارسال ✽فراخوانی افراد✽ در گروه ممنوع نمیباشد_"
end
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Mention* _Posting Has Been Unlocked_" 
else
return "_ارسال ✽فراخوانی افراد✽ در گروه آزاد شد_"
end
end
end

---------------Lock Arabic--------------
local function lock_arabic(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic == "yes" then
if not lang then
 return "*Arabic/Persian* _Posting Is Already Locked_"
elseif lang then
 return "_ارسال ✽کلمات عربی/فارسی✽ در گروه هم اکنون ممنوع است_"
end
else
data[tostring(target)]["settings"]["lock_arabic"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Arabic/Persian* _Posting Has Been Locked_"
else
 return "_ارسال ✽کلمات عربی/فارسی✽ در گروه با موفقیت ممنوع شد! و از این پس پاک خواهد شد_"
end
end
end

local function unlock_arabic(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"]
 if lock_arabic == "no" then
if not lang then
return "*Arabic/Persian* _Posting Is Not Locked_" 
elseif lang then
return "_ارسال ✽کلمات عربی/فارسی✽ در گروه ممنوع نمیباشد_"
end
else 
data[tostring(target)]["settings"]["lock_arabic"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Arabic/Persian* _Posting Has Been Unlocked_" 
else
return "_ارسال ✽کلمات عربی/فارسی✽ در گروه آزاد شد_"
end
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then
if not lang then
 return "*Editing* _Is Already Locked_"
elseif lang then
 return "_✽ویرایش پیام✽ در گروه هم اکنون ممنوع است_"
end
else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Editing* _Has Been Locked_"
else
 return "_✽ویرایش پیام✽ در گروه با موفقیت ممنوع شد! و از این پس پاک خواهد شد_"
end
end
end

local function unlock_edit(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
if not lang then
return "*Editing* _Is Not Locked_" 
elseif lang then
return "_✽ویرایش پیام✽ در گروه ممنوع نمیباشد_"
end
else 
data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Editing* _Has Been Unlocked_" 
else
return "_✽ویرایش پیام✽ در گروه آزاد شد_"
end
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then
if not lang then
 return "*Spam* _Is Already Locked_"
elseif lang then
 return "_ارسال ✽هرزنامه✽ در گروه هم اکنون ممنوع است_"
end
else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Spam* _Has Been Locked_"
else
 return "_ارسال ✽هرزنامه✽ در گروه با موفقیت ممنوع شد! و از این پس پاک خواهد شد_"
end
end
end

local function unlock_spam(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then
if not lang then
return "*Spam* _Posting Is Not Locked_" 
elseif lang then
 return "_ارسال ✽هرزنامه✽ در گروه ممنوع نمیباشد_"
end
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" save_data(_config.moderation.data, data)
if not lang then 
return "*Spam* _Posting Has Been Unlocked_" 
else
 return "_ارسال ✽هرزنامه✽ در گروه آزاد شد_"
end
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local lock_flood = data[tostring(target)]["settings"]["flood"] 
if lock_flood == "yes" then
if not lang then
 return "*Flooding* _Is Already Locked_"
elseif lang then
 return "_ارسال ✽پیام مکرر✽ در گروه هم اکنون ممنوع است"
end
else
 data[tostring(target)]["settings"]["flood"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Flooding* _Has Been Locked_"
else
 return "_ارسال ✽پیام مکرر✽ در گروه با موفقیت ممنوع شد! و از این پس پاک خواهد شد_"
end
end
end

local function unlock_flood(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local lock_flood = data[tostring(target)]["settings"]["flood"]
 if lock_flood == "no" then
if not lang then
return "*Flooding* _Is Not Locked_" 
elseif lang then
return "_ارسال ✽پیام مکرر✽ در گروه ممنوع نمیباشد_"
end
else 
data[tostring(target)]["settings"]["flood"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Flooding* _Has Been Unlocked_" 
else
return "_ارسال ✽پیام مکرر✽ در گروه آزاد شد_"
end
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then
if not lang then
 return "*Bots* _Protection Is Already Enabled_"
elseif lang then
 return "_✽محافظت از گروه در برابر ربات ها✽ در گروه هم اکنون فعال است_"
end
else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Bots* _Protection Has Been Enabled_"
else
 return "_✽محافظت از گروه در برابر ربات ها✽ در گروه با موفقیت فعال شد!_"
end
end
end

local function unlock_bots(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end 
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then
if not lang then
return "*Bots* _Protection Is Not Enabled_" 
elseif lang then
return "_✽محافظت از گروه در برابر ربات ها✽ در گروه غیر فعال است_"
end
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Bots* _Protection Has Been Disabled_" 
else
return "_✽محافظت از گروه در برابر ربات ها✽ در گروه غیر فعال شد_"
end
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then
if not lang then 
 return "*Markdown* _Posting Is Already Locked_"
elseif lang then
 return "_ارسال ✽پیام های دارای فونت✽ در گروه هم اکنون ممنوع است_"
end
else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Markdown* _Posting Has Been Locked_"
else
 return "_ارسال ✽پیام های دارای فونت✽ در گروه با موفقیت ممنوع شد! و از این پس پاک خواهد شد_"
end
end
end

local function unlock_markdown(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end 
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then
if not lang then
return "*Markdown* _Posting Is Not Locked_"
elseif lang then
return "_ارسال ✽پیام های دارای فونت✽ در گروه ممنوع نمیباشد_"
end
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data) 
if not lang then
return "*Markdown* _Posting Has Been Unlocked_"
else
return "_ارسال ✽پیام های دارای فونت✽ در گروه آزاد شد_"
end
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then
if not lang then
 return "*Webpage* _Is Already Locked_"
elseif lang then
 return "_ارسال ✽صفحات وب✽ در گروه هم اکنون ممنوع است_"
end
else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 
if not lang then
 return "*Webpage* _Has Been Locked_"
else
 return "_ارسال ✽صفحات وب✽ در گروه با موفقیت ممنوع شد! و از این پس پاک خواهد شد_"
end
end
end

local function unlock_webpage(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end 
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then
if not lang then
return "*Webpage* _Is Not Locked_" 
elseif lang then
return "_ارسال ✽صفحات وب✽ در گروه ممنوع نمیباشد_"
end
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 
if not lang then
return "*Webpage* _Has Been Unlocked_" 
else
return "_ارسال ✽صفحات وب✽ در گروه آزاد شد_"
end
end
end

function group_settings(msg, target) 	
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 	return "_You're Not_ *Moderator*"
else
  return "_شما مدیر گروه نمیباشید_"
end
end
local data = load_data(_config.moderation.data)
local target = msg.chat_id_ 
if data[tostring(target)] then 	
if data[tostring(target)]["settings"]["num_msg_max"] then 	
NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['num_msg_max'])
	print('custom'..NUM_MSG_MAX) 	
else 	
NUM_MSG_MAX = 5
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_link"] then			
data[tostring(target)]["settings"]["lock_link"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_tag"] then			
data[tostring(target)]["settings"]["lock_tag"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_fosh"] then			
data[tostring(target)]["settings"]["lock_fosh"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_mention"] then			
data[tostring(target)]["settings"]["lock_mention"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_arabic"] then			
data[tostring(target)]["settings"]["lock_arabic"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_edit"] then			
data[tostring(target)]["settings"]["lock_edit"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_spam"] then			
data[tostring(target)]["settings"]["lock_spam"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_flood"] then			
data[tostring(target)]["settings"]["lock_flood"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_bots"] then			
data[tostring(target)]["settings"]["lock_bots"] = "yes"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_markdown"] then			
data[tostring(target)]["settings"]["lock_markdown"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["lock_webpage"] then			
data[tostring(target)]["settings"]["lock_webpage"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["welcome"] then			
data[tostring(target)]["settings"]["welcome"] = "no"		
end
end

if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_all"] then			
data[tostring(target)]["settings"]["mute_all"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_gif"] then			
data[tostring(target)]["settings"]["mute_gif"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_text"] then			
data[tostring(target)]["settings"]["mute_text"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_photo"] then			
data[tostring(target)]["settings"]["mute_photo"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_video"] then			
data[tostring(target)]["settings"]["mute_video"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_audio"] then			
data[tostring(target)]["settings"]["mute_audio"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_voice"] then			
data[tostring(target)]["settings"]["mute_voice"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_sticker"] then			
data[tostring(target)]["settings"]["mute_sticker"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_contact"] then			
data[tostring(target)]["settings"]["mute_contact"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_forward"] then			
data[tostring(target)]["settings"]["mute_forward"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_location"] then			
data[tostring(target)]["settings"]["mute_location"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_document"] then			
data[tostring(target)]["settings"]["mute_document"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_tgservice"] then			
data[tostring(target)]["settings"]["mute_tgservice"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_inline"] then			
data[tostring(target)]["settings"]["mute_inline"] = "no"		
end
end
if data[tostring(target)]["settings"] then		
if not data[tostring(target)]["settings"]["mute_game"] then			
data[tostring(target)]["settings"]["mute_game"] = "no"		
end
end


local expiretime = redis:hget('expiretime', msg.chat_id_)
    local expire = ''
  if not expiretime then
  expire = expire..'Unlimited'
  else
   local now = tonumber(os.time())
   expire =  expire..math.floor((tonumber(expiretime) - tonumber(now)) / 86400) + 1
 end



if not lang then
local settings = data[tostring(target)]["settings"] 
 text = "⛛*Group Settings*⛛\n\n✽》_Lock edit :_ *"..settings.lock_edit.."*\n✽》_Lock links :_ *"..settings.lock_link.."*\n✽》_Lock fosh :_ *"..settings.lock_fosh.."*\n✽》_Lock tags :_ *"..settings.lock_tag.."*\n✽》_Lock Persian :_ *"..settings.lock_arabic.."*\n✽》_Lock flood :_ *"..settings.flood.."*\n✽》_Lock spam :_ *"..settings.lock_spam.."*\n✽》_Lock mention :_ *"..settings.lock_mention.."*\n✽》_Lock webpage :_ *"..settings.lock_webpage.."*\n✽》_Lock markdown :_ *"..settings.lock_markdown.."*\n✽》_Bots protection :_ *"..settings.lock_bots.."*\n✽》_Flood sensitivity :_ *"..NUM_MSG_MAX.."*\n✽》_welcome :_ *"..settings.welcome.."*\n\n *🔊Group Mute List* 🔊 \n\n✽》_Mute all : _ *"..settings.mute_all.."*\n✽》_Mute gif :_ *"..settings.mute_gif.."*\n✽》_Mute text :_ *"..settings.mute_text.."*\n✽》_Mute inline :_ *"..settings.mute_inline.."*\n✽》_Mute game :_ *"..settings.mute_game.."*\n✽》_Mute photo :_ *"..settings.mute_photo.."*\n✽》_Mute video :_ *"..settings.mute_video.."*\n✽》_Mute audio :_ *"..settings.mute_audio.."*\n✽》_Mute voice :_ *"..settings.mute_voice.."*\n✽》_Mute sticker :_ *"..settings.mute_sticker.."*\n✽》_Mute contact :_ *"..settings.mute_contact.."*\n✽》_Mute forward :_ *"..settings.mute_forward.."*\n✽》_Mute location :_ *"..settings.mute_location.."*\n✽》_Mute document :_ *"..settings.mute_document.."*\n✽》_Mute TgService :_ *"..settings.mute_tgservice.."*\n*__________________*\n✽》⏱_expire time :_ *"..expire.."*\n*____________________*\n✽》*Language* : *EN*"
else
local settings = data[tostring(target)]["settings"] 
 text = "⛛*تنظیمات گروه*⛛\n\n✽》_قفل ویرایش پیام :_ *"..settings.lock_edit.."*\n✽》_قفل لینک :_ *"..settings.lock_link.."*\n✽》_قفل فحش :_ *"..settings.lock_fosh.."*\n✽》_قفل تگ :_ *"..settings.lock_tag.."*\n✽》_قفل فارسی :_ *"..settings.lock_arabic.."*\n✽》_قفل پیام مکرر :_ *"..settings.flood.."*\n✽》_قفل هرزنامه :_ *"..settings.lock_spam.."*\n✽》_قفل فراخوانی :_ *"..settings.lock_mention.."*\n✽》_قفل صفحات وب :_ *"..settings.lock_webpage.."*\n✽》_قفل فونت :_ *"..settings.lock_markdown.."*\n✽》_محافظت در برابر ربات ها :_ *"..settings.lock_bots.."*\n✽》_حداکثر پیام مکرر :_ *"..NUM_MSG_MAX.."*\n✽》_پیام خوش آمد گویی :_ *"..settings.welcome.."*\n\n *🔊لیست بیصدا ها 🔊*  \n\n✽》_بیصدا همه : _ *"..settings.mute_all.."*\n✽》_بیصدا تصاویر متحرک :_ *"..settings.mute_gif.."*\n✽》_بیصدا متن :_ *"..settings.mute_text.."*\n✽》_بیصدا تبلیغات شیشه ای :_ *"..settings.mute_inline.."*\n✽》_بیصدا بازی  :_ *"..settings.mute_game.."*\n✽》_بیصدا عکس :_ *"..settings.mute_photo.."*\n✽》_بیصدا فیلم :_ *"..settings.mute_video.."*\n✽》_بیصدا آهنگ :_ *"..settings.mute_audio.."*\n✽》_بیصدا صدا :_ *"..settings.mute_voice.."*\n✽》_بیصدا استیکر :_ *"..settings.mute_sticker.."*\n✽》_بیصدا ارسال اطلاعات :_ *"..settings.mute_contact.."*\n✽》_بیصدا  فوروارد :_ *"..settings.mute_forward.."*\n✽》_بیصدا ارسال مکان :_ *"..settings.mute_location.."*\n✽》_بیصدا ارسال فایل :_ *"..settings.mute_document.."*\n✽》_بیصدا اعلانات :_ *"..settings.mute_tgservice.."*\n*__________________*\n✽》⏱_تاریخ انقضا :_ *"..expire.."*\n*____________________*\n✽》*زبان ربات* : *فارسی*"
end
return text
end
--------Mutes---------
--------Mute all------------------------
local function mute_all(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then 
if not lang then
return "_You're Not_ *Moderator*" 
else
return "_شما مدیر گروه نمیباشید_"
end
end

local mute_all = data[tostring(target)]["settings"]["mute_all"] 
if mute_all == "yes" then 
if not lang then
return "*Mute All* _Is Already Enabled_" 
elseif lang then
return "_گروه تا اطلاع ثانوی بسته شد لطفا پیامی نفرستید این دستور از جانب مدیر اصلی گروه بوده است_(:"
end
else 
data[tostring(target)]["settings"]["mute_all"] = "yes"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute All* _Has Been Enabled_" 
else
return "_گروه تا اطلاع ثانوی بسته شد لطفا پیامی نفرستید این دستور از جانب مدیر اصلی گروه بوده است_(:"
end
end
end

local function unmute_all(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then 
if not lang then
return "_You're Not_ *Moderator*" 
else
return "_شما مدیر گروه نمیباشید_"
end
end

local mute_all = data[tostring(target)]["settings"]["mute_all"] 
if mute_all == "no" then 
if not lang then
return "*Mute All* _Is Already Disabled_" 
elseif lang then
return "_گروه باز شد کاربران میتوانند پیام ارسال کنند_(:"
end
else 
data[tostring(target)]["settings"]["mute_all"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute All* _Has Been Disabled_" 
else
return "_گروه باز شد کاربران میتوانند پیام ارسال کنند_(:"
end 
end
end

---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local mute_gif = data[tostring(target)]["settings"]["mute_gif"] 
if mute_gif == "yes" then
if not lang then
 return "*Mute Gif* _Is Already Enabled_"
elseif lang then
 return "_بیصدا کردن ✽تصاویر متحرک✽ در گروه فعال است_"
end
else
 data[tostring(target)]["settings"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then 
 return "*Mute Gif* _Has Been Enabled_"
else
 return "_بیصدا کردن ✽تصاویر متحرک✽ در گروه فعال شد! و از این پس پاک خواهد شد_"
end
end
end

local function unmute_gif(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local mute_gif = data[tostring(target)]["settings"]["mute_gif"]
 if mute_gif == "no" then
if not lang then
return "*Mute Gif* _Is Already Disabled_" 
elseif lang then
return "_بیصدا کردن ✽تصاویر متحرک✽ در گروه غیر فعال است_"
end
else 
data[tostring(target)]["settings"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Gif* _Has Been Disabled_" 
else
return "_بیصدا کردن ✽تصاویر متحرک✽ در گروه غیر فعال شد_"
end
end
end
---------------Mute Game-------------------
local function mute_game(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local mute_game = data[tostring(target)]["settings"]["mute_game"] 
if mute_game == "yes" then
if not lang then
 return "*Mute Game* _Is Already Enabled_"
elseif lang then
 return "_بیصدا کردن ✽بازی های تحت وب✽ در گروه فعال است_"
end
else
 data[tostring(target)]["settings"]["mute_game"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Game* _Has Been Enabled_"
else
 return "_بیصدا کردن ✽بازی های تحت وب✽ در گروه فعال شد! و از این پس پاک خواهد شد_"
end
end
end

local function unmute_game(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end 
end

local mute_game = data[tostring(target)]["settings"]["mute_game"]
 if mute_game == "no" then
if not lang then
return "*Mute Game* _Is Already Disabled_" 
elseif lang then
return "_بیصدا کردن ✽بازی های تحت وب✽ در گروه غیر فعال است_"
end
else 
data[tostring(target)]["settings"]["mute_game"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Game* _Has Been Disabled_" 
else
return "_بیصدا کردن ✽بازی های تحت وب✽ در گروه غیر فعال شد_"
end
end
end
---------------Mute Inline-------------------
local function mute_inline(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local mute_inline = data[tostring(target)]["settings"]["mute_inline"] 
if mute_inline == "yes" then
if not lang then
 return "*Mute Inline* _Is Already Enabled_"
elseif lang then
 return "_بیصدا کردن ✽کیبورد شیشه ای✽ در گروه فعال است_"
end
else
 data[tostring(target)]["settings"]["mute_inline"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Inline* _Has Been Enabled_"
else
 return "_بیصدا کردن ✽کیبورد شیشه ای✽ در گروه فعال شد! و از این پس پاک خواهد شد_"
end
end
end

local function unmute_inline(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local mute_inline = data[tostring(target)]["settings"]["mute_inline"]
 if mute_inline == "no" then
if not lang then
return "*Mute Inline* _Is Already Disabled_" 
elseif lang then
return "_بیصدا کردن ✽کیبورد شیشه ای✽ در گروه غیر فعال است_"
end
else 
data[tostring(target)]["settings"]["mute_inline"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Inline* _Has Been Disabled_" 
else
return "_بیصدا کردن ✽کیبورد شیشه ای✽ در گروه غیر فعال شد_"
end
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local mute_text = data[tostring(target)]["settings"]["mute_text"] 
if mute_text == "yes" then
if not lang then
 return "*Mute Text* _Is Already Enabled_"
elseif lang then
 return "_بیصدا کردن ✽متن✽ در گروه فعال است_"
end
else
 data[tostring(target)]["settings"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Text* _Has Been Enabled_"
else
 return "_بیصدا کردن ✽متن✽ در گروه فعال شد! و از این پس پاک خواهد شد_"
end
end
end

local function unmute_text(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end 
end

local mute_text = data[tostring(target)]["settings"]["mute_text"]
 if mute_text == "no" then
if not lang then
return "*Mute Text* _Is Already Disabled_"
elseif lang then
return "_بیصدا کردن ✽متن✽ در گروه غیر فعال است_" 
end
else 
data[tostring(target)]["settings"]["mute_text"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Text* _Has Been Disabled_" 
else
return "_بیصدا کردن ✽متن✽ در گروه غیر فعال شد_"
end
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "🔇_You're Not_ *Moderator*🔇"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local mute_photo = data[tostring(target)]["settings"]["mute_photo"] 
if mute_photo == "yes" then
if not lang then
 return "*Mute Photo* _Is Already Enabled_"
elseif lang then
 return "_بیصدا کردن ✽عکس✽ در گروه فعال است_"
end
else
 data[tostring(target)]["settings"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Photo* _Has Been Enabled_"
else
 return "_بیصدا کردن ✽عکس✽ در گروه فعال شد! و از این پس پاک خواهد شد_"
end
end
end

local function unmute_photo(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end
 
local mute_photo = data[tostring(target)]["settings"]["mute_photo"]
 if mute_photo == "no" then
if not lang then
return "*Mute Photo* _Is Already Disabled_" 
elseif lang then
return "_بیصدا کردن ✽عکس✽ در گروه غیر فعال است_"
end
else 
data[tostring(target)]["settings"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Photo* _Has Been Disabled_" 
else
return "_بیصدا کردن ✽عکس✽ در گروه غیر فعال شد_"
end
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local mute_video = data[tostring(target)]["settings"]["mute_video"] 
if mute_video == "yes" then
if not lang then
 return "*Mute Video* _Is Already Enabled_"
elseif lang then
 return "_بیصدا کردن ✽فیلم✽ در گروه فعال است_"
end
else
 data[tostring(target)]["settings"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data)
if not lang then 
 return "*Mute Video* _Has Been Enabled_"
else
 return "_بیصدا کردن ✽فیلم✽ در گروه فعال شد! و از این پس پاک خواهد شد_"
end
end
end

local function unmute_video(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local mute_video = data[tostring(target)]["settings"]["mute_video"]
 if mute_video == "no" then
if not lang then
return "*Mute Video* _Is Already Disabled_" 
elseif lang then
return "_بیصدا کردن ✽فیلم✽ در گروه غیر فعال است_"
end
else 
data[tostring(target)]["settings"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Video* _Has Been Disabled_" 
else
return "_بیصدا کردن ✽فیلم✽ در گروه غیر فعال شد_"
end
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local mute_audio = data[tostring(target)]["settings"]["mute_audio"] 
if mute_audio == "yes" then
if not lang then
 return "*Mute Audio* _Is Already Enabled_"
elseif lang then
 return "_بیصدا کردن ✽آهنگ✽ در گروه فعال است_"
end
else
 data[tostring(target)]["settings"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Audio* _Has Been Enabled_"
else 
return "_بیصدا کردن ✽آهنگ✽ در گروه فعال شد! و از این پس پاک خواهد شد_"
end
end
end

local function unmute_audio(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local mute_audio = data[tostring(target)]["settings"]["mute_audio"]
 if mute_audio == "no" then
if not lang then
return "*Mute Audio* _Is Already Disabled_" 
elseif lang then
return "_بیصدا کردن ✽آهنگ✽ در گروه غیر فعال است_"
end
else 
data[tostring(target)]["settings"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Audio* _Has Been Disabled_"
else
return "_بیصدا کردن ✽آهنگ✽ در گروه غیر فعال شد_" 
end
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local mute_voice = data[tostring(target)]["settings"]["mute_voice"] 
if mute_voice == "yes" then
if not lang then
 return "*Mute Voice* _Is Already Enabled_"
elseif lang then
 return "_بیصدا کردن ✽صدا✽ در گروه فعال است_"
end
else
 data[tostring(target)]["settings"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Voice* _Has Been Enabled_"
else
 return "_بیصدا کردن ✽صدا✽ در گروه فعال شد! و از این پس پاک خواهد شد_"
end
end
end

local function unmute_voice(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local mute_voice = data[tostring(target)]["settings"]["mute_voice"]
 if mute_voice == "no" then
if not lang then
return "*Mute Voice* _Is Already Disabled_" 
elseif lang then
return "_بیصدا کردن ✽صدا✽ در گروه غیر فعال است_"
end
else 
data[tostring(target)]["settings"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Voice* _Has Been Disabled_" 
else
return "_بیصدا کردن ✽صدا✽ در گروه غیر فعال شد_"
end
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local mute_sticker = data[tostring(target)]["settings"]["mute_sticker"] 
if mute_sticker == "yes" then
if not lang then
 return "*Mute Sticker* _Is Already Enabled_"
elseif lang then
 return "_بیصدا کردن ✽برچسب✽ در گروه فعال است_"
end
else
 data[tostring(target)]["settings"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Sticker* _Has Been Enabled_"
else
 return "_بیصدا کردن ✽برچسب✽ در گروه فعال شد! و از این پس پاک خواهد شد_"
end
end
end

local function unmute_sticker(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end 
end

local mute_sticker = data[tostring(target)]["settings"]["mute_sticker"]
 if mute_sticker == "no" then
if not lang then
return "*Mute Sticker* _Is Already Disabled_" 
elseif lang then
return "_بیصدا کردن ✽برچسب✽ در گروه غیر فعال است_"
end
else 
data[tostring(target)]["settings"]["mute_sticker"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Sticker* _Has Been Disabled_"
else
return "_بیصدا کردن ✽برچسب✽ در گروه غیر فعال شد_"
end 
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local mute_contact = data[tostring(target)]["settings"]["mute_contact"] 
if mute_contact == "yes" then
if not lang then
 return "*Mute Contact* _Is Already Enabled_"
elseif lang then
 return "_بیصدا کردن ✽مخاطب✽ در گروه فعال است_"
end
else
 data[tostring(target)]["settings"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Contact* _Has Been Enabled_"
else
 return "_بیصدا کردن ✽مخاطب✽ در گروه فعال شد! و از این پس پاک خواهد شد_"
end
end
end

local function unmute_contact(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local mute_contact = data[tostring(target)]["settings"]["mute_contact"]
 if mute_contact == "no" then
if not lang then
return "*Mute Contact* _Is Already Disabled_" 
elseif lang then
return "_بیصدا کردن ✽مخاطب✽ در گروه غیر فعال است_"
end
else 
data[tostring(target)]["settings"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Contact* _Has Been Disabled_" 
else
return "_بیصدا کردن ✽مخاطب✽ در گروه غیر فعال شد_"
end
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local mute_forward = data[tostring(target)]["settings"]["mute_forward"] 
if mute_forward == "yes" then
if not lang then
 return "*Mute Forward* _Is Already Enabled_"
elseif lang then
 return "_بیصدا کردن ✽نقل قول✽ در گروه فعال است_"
end
else
 data[tostring(target)]["settings"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Forward* _Has Been Enabled_"
else
 return "_بیصدا کردن ✽نقل قول✽ در گروه فعال شد! و از این پس پاک خواهد شد_"
end
end
end

local function unmute_forward(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local mute_forward = data[tostring(target)]["settings"]["mute_forward"]
 if mute_forward == "no" then
if not lang then
return "*Mute Forward* _Is Already Disabled_"
elseif lang then
return "_بیصدا کردن ✽نقل قول✽ در گروه غیر فعال است_"
end 
else 
data[tostring(target)]["settings"]["mute_forward"] = "no"
 save_data(_config.moderation.data, data)
if not lang then 
return "*Mute Forward* _Has Been Disabled_" 
else
return "_بیصدا کردن ✽نقل قول✽ در گروه غیر فعال شد_"
end
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local mute_location = data[tostring(target)]["settings"]["mute_location"] 
if mute_location == "yes" then
if not lang then
 return "*Mute Location* _Is Already Enabled_"
elseif lang then
 return "_بیصدا کردن ✽موقعیت✽ در گروه فعال است_"
end
else
 data[tostring(target)]["settings"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data)
if not lang then
 return "*Mute Location* _Has Been Enabled_"
else
 return "_بیصدا کردن ✽موقعیت✽ در گروه فعال شد! و از این پس پاک خواهد شد_"
end
end
end

local function unmute_location(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local mute_location = data[tostring(target)]["settings"]["mute_location"]
 if mute_location == "no" then
if not lang then
return "*Mute Location* _Is Already Disabled_" 
elseif lang then
return "_بیصدا کردن ✽موقعیت✽ در گروه غیر فعال است_"
end
else 
data[tostring(target)]["settings"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Location* _Has Been Disabled_" 
else
return "_بیصدا کردن ✽موقعیت✽ در گروه غیر فعال شد_"
end
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end

local mute_document = data[tostring(target)]["settings"]["mute_document"] 
if mute_document == "yes" then
if not lang then
 return "*Mute Document* _Is Already Enabled_"
elseif lang then
 return "_بیصدا کردن ✽اسناد✽ در گروه فعال است_"
end
else
 data[tostring(target)]["settings"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute Document* _Has Been Enabled_"
else
 return "_بیصدا کردن ✽اسناد✽ در گروه فعال شد! و از این پس پاک خواهد شد_"
end
end
end

local function unmute_document(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نمیباشید_"
end
end 

local mute_document = data[tostring(target)]["settings"]["mute_document"]
 if mute_document == "no" then
if not lang then
return "*Mute Document* _Is Already Disabled_" 
elseif lang then
return "_بیصدا کردن ✽اسناد✽ در گروه غیر فعال است_"
end
else 
data[tostring(target)]["settings"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute Document* _Has Been Disabled_" 
else
return "_بیصدا کردن ✽اسناد✽ در گروه غیر فعال شد_"
end
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
if not is_mod(msg) then
if not lang then
 return "_You're Not_ *Moderator*"
else
 return "_شما مدیر گروه نمیباشید_"
end
end

local mute_tgservice = data[tostring(target)]["settings"]["mute_tgservice"] 
if mute_tgservice == "yes" then
if not lang then
 return "*Mute TgService* _Is Already Enabled_"
elseif lang then
 return "_بیصدا کردن ✽خدمات تلگرام✽ در گروه فعال است_"
end
else
 data[tostring(target)]["settings"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 
if not lang then
 return "*Mute TgService* _Has Been Enabled_"
else
return "_بیصدا کردن ✽خدمات تلگرام✽ در گروه فعال شد! و از این پس پاک خواهد شد_"
end
end
end

local function unmute_tgservice(msg, data, target)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 if not is_mod(msg) then
if not lang then
return "_You're Not_ *Moderator*"
else
return "_شما مدیر گروه نیستید_"
end 
end

local mute_tgservice = data[tostring(target)]["settings"]["mute_tgservice"]
 if mute_tgservice == "no" then
if not lang then
return "*Mute TgService* _Is Already Disabled_"
elseif lang then
return "_بیصدا کردن ✽خدمات تلگرام✽ در گروه غیر فعال است_"
end 
else 
data[tostring(target)]["settings"]["mute_tgservice"] = "no"
 save_data(_config.moderation.data, data) 
if not lang then
return "*Mute TgService* _Has Been Disabled_"
else
return "_بیصدا کردن ✽خدمات تلگرام✽ در گروه غیر فعال شد_"
end 
end
end


local function run(msg, matches)
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
    local data = load_data(_config.moderation.data)
   local chat = msg.chat_id_
   local user = msg.sender_user_id_
if matches[1] == "ایدی" then
if not matches[2] and tonumber(msg.reply_to_message_id_) == 0 then
   if not lang then
return "*Chat ID :* _"..chat.."_\n*User ID :* _"..user.."_"
   else
return "*شناسه گروه :* _"..chat.."_\n*شناسه شما :* _"..user.."_"
   end
end
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="id"})
  end
if matches[2] and tonumber(msg.reply_to_message_id_) == 0 then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="id"})
      end
   end
if matches[1] == "سنجاق کردن" and is_owner(msg) then
tdcli.pinChannelMessage(msg.chat_id_, msg.reply_to_message_id_, 1)
if not lang then
return "*Message Has Been Pinned*"
else
return "پیام سجاق شد"
end
end
if matches[1] == 'حذف سنجاق' and is_mod(msg) then
tdcli.unpinChannelMessage(msg.chat_id_)
if not lang then
return "*Pin message has been unpinned*"
else
return "پیام سنجاق شده پاک شد"
end
end
if matches[1] == "نصب" then
return modadd(msg)
end
if matches[1] == "حذف" then
return modrem(msg)
end
if matches[1] == "انتخاب مدیر" and is_admin(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="setowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="setowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="setowner"})
      end
   end
if matches[1] == "حذف مدیر" and is_admin(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="remowner"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="remowner"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="remowner"})
      end
   end
if matches[1] == "انتخاب ناظر" and is_owner(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="promote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="promote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="promote"})
      end
   end
if matches[1] == "حذف ناظر" and is_owner(msg) then
if not matches[2] and tonumber(msg.reply_to_message_id_) ~= 0 then
 tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.chat_id_,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.chat_id_,cmd="demote"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="demote"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="demote"})
      end
   end

if matches[1] == "قفل" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "لینک" then
return lock_link(msg, data, target)
end
if matches[2] == "فحش" then
return lock_fosh(msg, data, target)
end
if matches[2] == "تگ" then
return lock_tag(msg, data, target)
end
if matches[2] == "هایپرلینک" then
return lock_mention(msg, data, target)
end
if matches[2] == "عربی" then
return lock_arabic(msg, data, target)
end
if matches[2] == "ویرایش" then
return lock_edit(msg, data, target)
end
if matches[2] == "اسپم" then
return lock_spam(msg, data, target)
end
if matches[2] == "فلود" then
return lock_flood(msg, data, target)
end
if matches[2] == "ربات" then
return lock_bots(msg, data, target)
end
if matches[2] == "فونت" then
return lock_markdown(msg, data, target)
end
if matches[2] == "وبسایت" then
return lock_webpage(msg, data, target)
end
end

if matches[1] == "باز کردن" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "لینک" then
return unlock_link(msg, data, target)
end
if matches[2] == "فحش" then
return unlock_fosh(msg, data, target)
end
if matches[2] == "تگ" then
return unlock_tag(msg, data, target)
end
if matches[2] == "هایپرلینک" then
return unlock_mention(msg, data, target)
end
if matches[2] == "عربی" then
return unlock_arabic(msg, data, target)
end
if matches[2] == "ویرایش" then
return unlock_edit(msg, data, target)
end
if matches[2] == "اسپم" then
return unlock_spam(msg, data, target)
end
if matches[2] == "فلود" then
return unlock_flood(msg, data, target)
end
if matches[2] == "ربات" then
return unlock_bots(msg, data, target)
end
if matches[2] == "فونت" then
return unlock_markdown(msg, data, target)
end
if matches[2] == "وبسایت" then
return unlock_webpage(msg, data, target)
end
end
if matches[1] == "بیصدا" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "همه" then
return mute_all(msg, data, target)
end
if matches[2] == "گیف" then
return mute_gif(msg, data, target)
end
if matches[2] == "متن" then
return mute_text(msg ,data, target)
end
if matches[2] == "عکس" then
return mute_photo(msg ,data, target)
end
if matches[2] == "فیلم" then
return mute_video(msg ,data, target)
end
if matches[2] == "موزیک" then
return mute_audio(msg ,data, target)
end
if matches[2] == "صدا" then
return mute_voice(msg ,data, target)
end
if matches[2] == "استیکر" then
return mute_sticker(msg ,data, target)
end
if matches[2] == "اطلاعات تماس" then
return mute_contact(msg ,data, target)
end
if matches[2] == "فوروارد" then
return mute_forward(msg ,data, target)
end
if matches[2] == "مکان" then
return mute_location(msg ,data, target)
end
if matches[2] == "فایل" then
return mute_document(msg ,data, target)
end
if matches[2] == "اعلانات" then
return mute_tgservice(msg ,data, target)
end
if matches[2] == "اینلاین" then
return mute_inline(msg ,data, target)
end
if matches[2] == "بازی" then
return mute_game(msg ,data, target)
end
end

if matches[1] == "باصدا" and is_mod(msg) then
local target = msg.chat_id_
if matches[2] == "همه" then
return unmute_all(msg, data, target)
end
if matches[2] == "گیف" then
return unmute_gif(msg, data, target)
end
if matches[2] == "متن" then
return unmute_text(msg, data, target)
end
if matches[2] == "عکس" then
return unmute_photo(msg ,data, target)
end
if matches[2] == "فیلم" then
return unmute_video(msg ,data, target)
end
if matches[2] == "موزیک" then
return unmute_audio(msg ,data, target)
end
if matches[2] == "صدا" then
return unmute_voice(msg ,data, target)
end
if matches[2] == "استیکر" then
return unmute_sticker(msg ,data, target)
end
if matches[2] == "مخاطب" then
return unmute_contact(msg ,data, target)
end
if matches[2] == "فوروارد" then
return unmute_forward(msg ,data, target)
end
if matches[2] == "مکان" then
return unmute_location(msg ,data, target)
end
if matches[2] == "فایل" then
return unmute_document(msg ,data, target)
end
if matches[2] == "اعلانات" then
return unmute_tgservice(msg ,data, target)
end
if matches[2] == "اینلاین" then
return unmute_inline(msg ,data, target)
end
if matches[2] == "بازی" then
return unmute_game(msg ,data, target)
end
end
if matches[1] == "اطلاعات گروه" and is_mod(msg) and gp_type(msg.chat_id_) == "channel" then
local function group_info(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if not lang then
ginfo = "*Group Info :*\n👲_Admin Count :_ *"..data.administrator_count_.."*\n👥_Member Count :_ *"..data.member_count_.."*\n👿_Kicked Count :_ *"..data.kicked_count_.."*\n🆔_Group ID :_ *"..data.channel_.id_.."*"
print(serpent.block(data))
elseif lang then
ginfo = "*اطلاعات گروه *\n👲_تعداد مدیران :_ *"..data.administrator_count_.."*\n👥_تعداد اعضا :_ *"..data.member_count_.."*\n👿_تعداد اعضای حذف شده :_ *"..data.kicked_count_.."*\n🆔_شناسه گروه :_ *"..data.channel_.id_.."*"
print(serpent.block(data))
end
        tdcli.sendMessage(arg.chat_id, arg.msg_id, 1, ginfo, 1, 'md')
end
 tdcli.getChannelFull(msg.chat_id_, group_info, {chat_id=msg.chat_id_,msg_id=msg.id_})
end
		if matches[1] == 'تنظیم لینک' and is_owner(msg) then
			data[tostring(chat)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
      if not lang then
			return '_Please send the new group_ *link* _now_'
    else 
         return '_لطفا لینک گروه خود را ارسال کنید_'
       end
		end

		if msg.content_.text_ then
   local is_link = msg.content_.text_:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.content_.text_:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(chat)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(chat)]['settings']['linkgp'] = msg.content_.text_
				save_data(_config.moderation.data, data)
            if not lang then
				return "*Newlink* _has been set_"
           else
           return "_لینک جدید ذخیره شد_"
		 	end
       end
		end
    if matches[1] == 'لینک' and is_mod(msg) then
      local linkgp = data[tostring(chat)]['settings']['linkgp']
      if not linkgp then
      if not lang then
        return "_First set a link for group with using_ /setlink"
     else
        return "اول لینک گروه خود را ذخیره کنید با /setlink"
      end
      end
     if not lang then
       text = "<b>Group Link :</b>\n"..linkgp
     else
      text = "<b>لینک گروه :</b>\n"..linkgp
         end
        return tdcli.sendMessage(chat, msg.id_, 1, text, 1, 'html')
     end
  if matches[1] == "تنظیم قوانین" and matches[2] and is_mod(msg) then
    data[tostring(chat)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
     if not lang then
    return "*Group rules* _has been set_"
   else 
  return "_قوانین گروه ثبت شد_"
   end
  end
  if matches[1] == "قوانین" then
 if not data[tostring(chat)]['rules'] then
   if not lang then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n"
    elseif lang then
       rules = "ℹ️ قوانین پپیشفرض:\n1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n"
 end
        else
     rules = "*Group Rules :*\n"..data[tostring(chat)]['rules']
      end
    return rules
  end
if matches[1] == "رس" and matches[2] and is_mod(msg) then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.chat_id_,username=matches[2],cmd="res"})
  end
if matches[1] == "چه کسی" and matches[2] and is_mod(msg) then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.chat_id_,user_id=matches[2],cmd="whois"})
  end
  if matches[1] == 'تنظیم فلود' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
				return "_Wrong number, range is_ *[1-50]*"
      end
			local flood_max = matches[2]
			data[tostring(chat)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
    return "_Group_ *flood* _sensitivity has been set to :_ *[ "..matches[2].." ]*"
       end
		if matches[1]:lower() == 'پاک کردن' and is_owner(msg) then
			if matches[2] == 'mods' then
				if next(data[tostring(chat)]['mods']) == nil then
            if not lang then
					return "_No_ *moderators* _in this group_"
             else
                return "_هیچ مدیری برای گروه انتخاب نشده است_"
				end
            end
				for k,v in pairs(data[tostring(chat)]['mods']) do
					data[tostring(chat)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            if not lang then
				return "_All_ *moderators* _has been demoted_"
          else
            return "_تمام مدیران گروه تنزیل مقام شدند_"
			end
         end
			if matches[2] == 'لیست فیلترها' then
				if next(data[tostring(chat)]['filterlist']) == nil then
     if not lang then
					return "*Filtered words list* _is empty_"
         else
					return "_لیست کلمات فیلتر شده خالی است_"
             end
				end
				for k,v in pairs(data[tostring(chat)]['filterlist']) do
					data[tostring(chat)]['filterlist'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
       if not lang then
				return "*Filtered words list* _has been cleaned_"
           else
				return "_لیست کلمات فیلتر شده پاک شد_"
           end
			end
			if matches[2] == 'قوانین' then
				if not data[tostring(chat)]['rules'] then
            if not lang then
					return "_No_ *rules* _available_"
             else
               return "_قوانین برای گروه ثبت نشده است_"
             end
				end
					data[tostring(chat)]['rules'] = nil
					save_data(_config.moderation.data, data)
             if not lang then
				return "*Group rules* _has been cleaned_"
          else
            return "قوانین گروه پاک شد"
			end
       end
			if matches[2] == 'ولکام' then
				if not data[tostring(chat)]['setwelcome'] then
            if not lang then
					return "*Welcome Message not set*"
             else
               return "_پیام خوشآمد گویی ثبت نشده است_"
             end
				end
					data[tostring(chat)]['setwelcome'] = nil
					save_data(_config.moderation.data, data)
             if not lang then
				return "*Welcome message* _has been cleaned_"
          else
            return "_پیام خوشآمد گویی پاک شد_"
			end
       end
			if matches[2] == 'درباره' then
        if gp_type(chat) == "chat" then
				if not data[tostring(chat)]['about'] then
            if not lang then
					return "_No_ *description* _available_"
            else
              return "_پیامی مبنی بر درباره گروه ثبت نشده است_"
          end
				end
					data[tostring(chat)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif gp_type(chat) == "channel" then
   tdcli.changeChannelAbout(chat, "", dl_cb, nil)
             end
             if not lang then
				return "*Group description* _has been cleaned_"
           else
              return "_پیام مبنی بر درباره گروه پاک شد_"
             end
		   	end
        end
		if matches[1]:lower() == 'پاک کردن' and is_admin(msg) then
			if matches[2] == 'owners' then
				if next(data[tostring(chat)]['owners']) == nil then
             if not lang then
					return "_No_ *owners* _in this group_"
            else
                return "_مالکی برای گروه انتخاب نشده است_"
            end
				end
				for k,v in pairs(data[tostring(chat)]['owners']) do
					data[tostring(chat)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
            if not lang then
				return "_All_ *owners* _has been demoted_"
           else
            return "_تمامی مالکان گروه تنزیل مقام شدند_"
          end
			end
     end
if matches[1] == "تنظیم نام" and matches[2] and is_mod(msg) then
local gp_name = matches[2]
tdcli.changeChatTitle(chat, gp_name, dl_cb, nil)
end
  if matches[1] == "تنظیم درباره" and matches[2] and is_mod(msg) then
     if gp_type(chat) == "channel" then
   tdcli.changeChannelAbout(chat, matches[2], dl_cb, nil)
    elseif gp_type(chat) == "chat" then
    data[tostring(chat)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
     if not lang then
    return "*Group description* _has been set_"
    else
     return "_پیام مبنی بر درباره گروه ثبت شد_"
      end
  end
  if matches[1] == "درباره" and gp_type(chat) == "chat" then
 if not data[tostring(chat)]['about'] then
     if not lang then
     about = "_No_ *description* _available_"
      elseif lang then
      about = "_پیامی مبنی بر درباره گروه ثبت نشده است_"
       end
        else
     about = "*Group Description :*\n"..data[tostring(chat)]['about']
      end
    return about
  end
  if matches[1] == 'فیلتر' and is_mod(msg) then
    return filter_word(msg, matches[2])
  end
  if matches[1] == 'رفع فیلتر' and is_mod(msg) then
    return unfilter_word(msg, matches[2])
  end
  if matches[1] == 'لیست فیلتر' and is_mod(msg) then
    return filter_list(msg)
  end
if matches[1] == "تنظیمات" then
return group_settings(msg, target)
end
if matches[1] == "لیست بیصدا" then
return mutes(msg, target)
end
if matches[1] == "لیست ناظران" then
return modlist(msg)
end
if matches[1] == "لیست مدیران" and is_owner(msg) then
return ownerlist(msg)
end

if matches[1] == "setlang" and is_owner(msg) then
   if matches[2] == "en" then
local hash = "gp_lang:"..msg.chat_id_
local lang = redis:get(hash)
 redis:del(hash)
return "_Group Language Set To:_ EN"
  elseif matches[2] == "fa" then
redis:set(hash, true)
return "*زبان گروه تنظیم شد به : فارسی*"
end
end




if matches[1] == "راهنما" and is_mod(msg) then
if not lang then
text = [[
🔰*Bot Commands:*🔰

در حال حاضر زبان ربات انگلیسی میباشد برای تغییر زبان دستور زیر را ارسال کنید
*!setlang fa*

👑*!setowner* `[username|id|reply]` 
_Set Group Owner(Multi Owner)_

👑*!remowner* `[username|id|reply]` 
 _Remove User From Owner List_

🤖*!promote* `[username|id|reply]` 
_Promote User To Group Admin_

🤖*!demote* `[username|id|reply]` 
_Demote User From Group Admins List_

🗣*!setflood* `[1-50]`
_Set Flooding Number_

🔇*!silent* `[username|id|reply]` 
_Silent User From Group_

🔊*!unsilent* `[username|id|reply]` 
_Unsilent User From Group_

👽*!kick* `[username|id|reply]` 
_Kick User From Group_

👽*!ban* `[username|id|reply]` 
_Ban User From Group_

👽*!unban* `[username|id|reply]` 
_UnBan User From Group_

🔹*!res* `[username]`
_Show User ID_

🔹*!id* `[reply]`
_Show User ID_

🔹*!whois* `[id]`
_Show User's Username And Name_

🔒*!lock* `[link | tag | arabic | edit | fosh | webpage | bots | spam | flood | markdown | mention]`
_If This Actions Lock, Bot Check Actions And Delete Them_

🔓*!unlock* `[link | tag | arabic | edit | fosh | webpage | bots | spam | flood | markdown | mention]`
_If This Actions Unlock, Bot Not Delete Them_

🔕*!mute* `[gifs | photo | tgservice | document | sticker | video | text | forward | location | audio | voice | contact | all]`
_If This Actions Lock, Bot Check Actions And Delete Them_

🔔*!unmute* `[gif | photo | tgservice | document | sticker | video | tgservice | text | forward | inline | location | audio | voice | contact | all]`
_If This Actions Unlock, Bot Not Delete Them_

🔹*!set*`[rules | name | photo | link | about]`
_Bot Set Them_

🔹*!clean* `[bans | mods | bots | rules | about | silentlist]`   
_Bot Clean Them_

🔹*!pin* `[reply]`
_Pin Your Message_

🔹*!unpin* 
_Unpin Pinned Message_

🛡*!settings*
_Show Group Settings_


🔕*!silentlist*
_Show Silented Users List_

🔕*!banlist*
_Show Banned Users List_

👑*!ownerlist*
_Show Group Owners List_ 

🤖*!modlist* 
_Show Group Moderators List_

🎖*!rules*
_Show Group Rules_

⚜*!gpinfo*
_Show Group Information_

⚜*!link*
_Show Group Link_

🔇*!mt 0 1* (0h 1m)
🔊*!unmt*
_Mute All With Time_

🚫*!filter* 
🚫*!unfilter* 
_filter word_
🚫*!filterlist* 
_Show Filter List_
〰〰〰〰〰
♻️*!del* 1-100
_Delete Message_
〰〰〰〰〰
🎗*!setwelcome* متن پیام
➕*!welcome enable*
➖*!welcome disable*
_set welcome for group_
〰〰〰〰〰
_You Can Use_ *[!/#]* _To Run The Commands_
_Change the language to farsi : !setlang fa_
]]

elseif lang then
text = [[
تنظیمات
≫ نمایش تنظیمات گروه

لیست سایلنت
≫ نمایش لیست سایلنت شده ها

لیست مسدود
≫ نمایش لیست مسدود شده ها

لیست مدیران
≫ نمایش لیست مدیران

لیست ناظران
≫ نمایش لیست ناظران

اطلاعات گروه
≫ نمایش اطلاعات گروه

انتخاب مدیر [ایدی|ریپلای|یوزرنیم]
≫ تعیین مدیر اصلی گروه

حذف مدیر [ایدی|ریپلای|یوزرنیم]
≫ حذف مدیر اصلی

انتخاب ناظر [ایدی|ریپلای|یوزرنیم]
≫ تعیین ناظر گروه

حذف ناظر [ایدی|ریپلای|یوزرنیم]
≫ حذف ناظر گروه

تنظیم فلود [50-1]
≫ تعیین میزان مجاز پست های رگباری

تنظیم درباره [متن درباره]
≫تنظیم درباره گروه

تنظیم نام [نام]
≫تنظیم نام گروه
----------------------------------------
رس [یوزرنیم]
ایدی [رپلای]
≫ نمایش ایدی یوزر

چه کسی [ایدی]
≫ نمایش یوزر ایدی

سایلنت [ایدی|ریپلای|یوزرنیم]
رفع سایلنت [ایدی|ریپلای|یوزرنیم]
≫ ساکت کردن یک کاربر

اخراج [ایدی|ریپلای|یوزرنیم]
≫ اخراج کردن یک کاربر

مسدود کردن [ایدی|ریپلای|یوزرنیم]
رفع مسدودیت [ایدی|ریپلای|یوزرنیم]
≫ مسدود کردن یک کاربر

» تنظیم لینک
» لینک [نمایش لینک گروه]
» قوانین [نمایش قوانین گروه]
≫ ثبت لینک،قوانین و نمایش انها

پاک کردن قوانین
≫ پاک کردن قوانین گروه

پاک کردن لیست سایلنت
≫ پاک کردن لیست سایلنت شده ها

سنجاق کردن [ریپلای]
حذف سنجاق
≫ سنجاق کردن متن در گروه

فیلتر [کلمه]
≫ فیلتر کردن یک کلمه

رفع فیلتر [کلمه]
≫ حذف کلمه از فیلتر

لیست فیلتر
≫ نمایش لیست فیلتر

تنظیم ولکام [متن پیام]
ولکام نصب
ولکام حذف
≫ ست کردن و فعال و غیرفعال کردن خوشامد گویی

پاک کردن [عدد]
≫ حذف پیام های گروه حداکثر 100

قفل [  لینک | فحش | تگ | هایپرلینک | عربی | ویرایش | اسپم | فلود | ربات | فونت | وبسایت  ]
قفل موارد بالا

 باز کردن [ لینک | فحش | تگ | هایپرلینک | عربی | ویرایش | اسپم | فلود | ربات | فونت | وبسایت ]
باز کردن موارد بالا

بیصدا [ همه | گیف | متن | عکس | فیلم | موزیک | صدا | استیکر | اطلاعت تماس | فوروارد | مکان | فایل | اعلانات | اینلاین | بازی  ]
≫ بیصدا کردن موارد بالا

باصدا [ همه | گیف | متن | عکس | فیلم | موزیک | صدا | استیکر | اطلاعت تماس | فوروارد | مکان | فایل | اعلانات | اینلاین | بازی ]
≫ باصدا کردن موارد بالا

میوت تایم دار
≫ عدد اول ساعت و عدد دوم دقیقه
*!mt 0 1*
*!unmt*
 
!warn [ایدی|ریپلای|یوزرنیم]
≫ اخطار به یک کاربر

انلاینی
≫ آگاهی از انلاین بودن ربات

➖➖➖➖➖
≫ در حال حاضر زبان ربات فارسی میباشد برای تغییر زبان دستور زیر را ارسال کنید
*!setlang en*
]]
end
return text
end

if matches[1] == "قفل ها" and is_mod(msg) then
text2 = [[

🔐 لیست قفل ها 🔐


💬 قفل کردن لینک گروه ها
🔒*قفل لینک*
🔓*باز کردن لینک*
〰〰〰〰〰
💬 قفل کردن یوزرنیم
🔒*قفل تگ*
🔓*باز کردن تگ*
〰〰〰〰〰
💬 قفل کردن متن فارسی و عربی
🔒*قفل عربی*
🔓*باز کردن عربی*
〰〰〰〰〰
💬 قفل کردن لینک سایت ها
🔒*قفل وبسایت*
🔓*باز کردن وبسایت*
〰〰〰〰〰
💬 جلوگیری از ویرایش متن
🔒*قفل ویرایش*
🔓*باز کردن ویرایش*
〰〰〰〰〰
💬 جلوگیری از وارد کردن ربات
🔒*قفل ربات*
🔓*باز کردن ربات*
〰〰〰〰〰
💬 قفل پیام های طولانی
🔒*قفل اسپم*
🔓*باز کردن اسپم*
〰〰〰〰〰
💬 قفل پیام های رگباری
🔒*قفل فلود*
🔓*باز کردن فلود*
〰〰〰〰〰
💬 قفل بولد و ایتالیک متن
🔒*قفل فونت*
🔓*باز کردن فونت*
〰〰〰〰〰
💬 قفل هایپرلینک
🔒*قفل هایپرلینک*
🔓*باز کردن هایپرلینک*
〰〰〰〰〰
💬 قفل فحش
🔒*قفل فحش*
🔓*باز کردن فحش*
〰〰〰〰〰
در زدن دستورات به فاصله حروف دقت کنید
...
]]
return text2
end

if matches[1] == "ممنوع" and is_mod(msg) then
text3 = [[
🔕 لیست بیصدا ها 🔕


💬 ارسال گیف ممنوع
🔇*بیصدا گیف*
🔊*باصدا گیف*
〰〰〰〰〰
💬 ارسال عکس ممنوع
🔇*بیصدا عکس*
🔊*باصدا عکس*
〰〰〰〰〰
💬 ارسال فایل ممنوع
🔇*بیصدا فایل*
🔊*باصدا فایل*
〰〰〰〰〰
💬 ارسال استیکر ممنوع
🔇*بیصدا استیکر*
🔊*باصدا استیکر*
〰〰〰〰〰
💬 ارسال ویدیو ممنوع
🔇*بیصدا فیلم*
🔊*باصدا فیلم*
〰〰〰〰〰
💬 ارسال متن ممنوع
🔇*بیصدا متن*
🔊*باصدا متن*
〰〰〰〰〰
💬 ارسال فوروارد ممنوع
🔇*بیصدا فوروارد*
🔊*باصدا فوروارد*
〰〰〰〰〰
💬 ارسال بازی به گروه
🔇*بیصدا بازی*
🔊*باصدا بازی*
〰〰〰〰〰
💬 ارسال مکان ممنوع
🔇*بیصدا مکان*
🔊*رفع ممنوعیت مکان*
〰〰〰〰〰
💬 ارسال موزیک ممنوع
🔇*بیصدا موزیک*
🔊*باصدا موزیک*
〰〰〰〰〰
💬 ارسال فایل ضبط شده ممنوع
🔇*بیصدا صدا*
🔊*باصدا صدا*
〰〰〰〰〰
💬 ارسال اطلاعات تماس ممنوع
🔇*بیصدا اطلاعات تماس*
🔊*باصدا اطلاعات تماس*
〰〰〰〰〰
💬 اعلانات گروه ممنوع
🔇* بیصدا اعلانات*
🔊*باصدا اعلانات*
〰〰〰〰〰
💬 ارسال تبلیغات شیشه ای ممنوع
🔇*بیصدا اینلاین*
🔊*باصدا اینلاین*
〰〰〰〰〰
💬 همه چیز ممنوع
🔇*بیصدا همه چیز*
🔊*باصدا همه چیز*
〰〰〰〰〰
💬 میوت تایم دار
عدد اول ساعت عدد دوم دقیقه
🔇*!mt 0 1*
🔊*!unmt*
〰〰〰〰〰
در زدن دستورات به فاصله حروف دقت کنید
...
]]
return text3
end

if matches[1] == "راهنما" and is_mod(msg) then
text4 = [[

تنظیمات
≫ نمایش تنظیمات گروه

لیست سایلنت
≫ نمایش لیست سایلنت شده ها

لیست مسدود
≫ نمایش لیست مسدود شده ها

لیست مدیران
≫ نمایش لیست مدیران

لیست ناظران
≫ نمایش لیست ناظران

اطلاعات گروه
≫ نمایش اطلاعات گروه

انتخاب مدیر `[ایدی|ریپلای|یوزرنیم]`
≫ تعیین مدیر اصلی گروه

حذف مدیر `[ایدی|ریپلای|یوزرنیم]`
≫ حذف مدیر اصلی

انتخاب ناظر `[ایدی|ریپلای|یوزرنیم]`
≫ تعیین ناظر گروه

حذف ناظر `[ایدی|ریپلای|یوزرنیم]`
≫ حذف ناظر گروه

تنظیم فلود `[50-1]`
≫ تعیین میزان مجاز پست های رگباری

تنظیم درباره `[متن درباره]`
≫تنظیم درباره گروه

تنظیم نام `[نام]`
≫تنظیم نام گروه
----------------------------------------
رس `[یوزرنیم]`
ایدی `[رپلای]`
≫ نمایش ایدی یوزر

چه کسی `[ایدی]`
≫ نمایش یوزر ایدی

سایلنت `[ایدی|ریپلای|یوزرنیم]`
رفع سایلنت `[ایدی|ریپلای|یوزرنیم]`
≫ ساکت کردن یک کاربر

اخراج `[ایدی|ریپلای|یوزرنیم]`
≫ اخراج کردن یک کاربر

مسدود کردن `[ایدی|ریپلای|یوزرنیم]`
رفع مسدودیت `[ایدی|ریپلای|یوزرنیم]`
≫ مسدود کردن یک کاربر

» تنظیم لینک
» لینک `[نمایش لینک گروه]`
» قوانین `[نمایش قوانین گروه]`
≫ ثبت لینک،قوانین و نمایش انها

پاک کردن قوانین
≫ پاک کردن قوانین گروه

پاک کردن لیست سایلنت
≫ پاک کردن لیست سایلنت شده ها

سنجاق کردن `[ریپلای]`
حذف سنجاق
≫ سنجاق کردن متن در گروه

فیلتر `[کلمه]`
≫ فیلتر کردن یک کلمه

رفع فیلتر `[کلمه]`
≫ حذف کلمه از فیلتر

لیست فیلتر
≫ نمایش لیست فیلتر

تنظیم ولکام `[متن پیام]`
ولکام نصب
ولکام حذف
≫ ست کردن و فعال و غیرفعال کردن خوشامد گویی

پاک کردن `[عدد]`
≫ حذف پیام های گروه حداکثر 100

قفل `[  لینک | فحش | تگ | هایپرلینک | عربی | ویرایش | اسپم | فلود | ربات | فونت | وبسایت  ]`
قفل موارد بالا

 باز کردن `[ لینک | فحش | تگ | هایپرلینک | عربی | ویرایش | اسپم | فلود | ربات | فونت | وبسایت ]`
باز کردن موارد بالا

بیصدا `[ همه چیز | گیف | متن | عکس | فیلم | موزیک | صدا | استیکر | اطلاعت تماس | فوروارد | مکان | فایل | اعلانات | اینلاین | بازی  ]`
≫ بیصدا کردن موارد بالا

باصدا [ همه چیز | گیف | متن | عکس | فیلم | موزیک | صدا | استیکر | اطلاعت تماس | فوروارد | مکان | فایل | اعلانات | اینلاین | بازی ]`
≫ باصدا کردن موارد بالا

میوت تایم دار
≫ عدد اول ساعت و عدد دوم دقیقه
*!mt 0 1*
*!unmt*
 
!warn `[ایدی|ریپلای|یوزرنیم]`
≫ اخطار به یک کاربر

انلاینی
≫ آگاهی از انلاین بودن ربات

➖➖➖➖➖
≫ در حال حاضر زبان ربات فارسی میباشد برای تغییر زبان دستور زیر را ارسال کنید
*!setlang en*
]]
return text5 
end


--------------------- Welcome -----------------------
	if matches[1] == "ولکام" and is_mod(msg) then
		if matches[2] == "نصب" then
			welcome = data[tostring(chat)]['settings']['welcome']
			if welcome == "yes" then
       if not lang then
				return "_Group_ *welcome* _is already enabled_"
       elseif lang then
				return "_خوشآمد گویی از قبل فعال بود_"
           end
			else
		data[tostring(chat)]['settings']['welcome'] = "yes"
	    save_data(_config.moderation.data, data)
       if not lang then
				return "_Group_ *welcome* _has been enabled_"
       elseif lang then
				return "_خوشآمد گویی فعال شد_"
          end
			end
		end
		
		if matches[2] == "حذف" then
			welcome = data[tostring(chat)]['settings']['welcome']
			if welcome == "no" then
      if not lang then
				return "_Group_ *Welcome* _is already disabled_"
      elseif lang then
				return "_خوشآمد گویی از قبل فعال نبود_"
         end
			else
		data[tostring(chat)]['settings']['welcome'] = "no"
	    save_data(_config.moderation.data, data)
      if not lang then
				return "_Group_ *welcome* _has been disabled_"
      elseif lang then
				return "_خوشآمد گویی غیرفعال شد_"
          end
			end
		end
	end
	if matches[1] == "تنظیم ولکام" and matches[2] and is_mod(msg) then
		data[tostring(chat)]['setwelcome'] = matches[2]
	    save_data(_config.moderation.data, data)
       if not lang then
		return "_Welcome Message Has Been Set To :_\n*"..matches[2].."*\n\n*You can use :*\n_{rules} ➣ Show Group Rules_\n_{name} ➣ New Member First Name_\n_{username} ➣ New Member Username_"
       else
		return "_پیام خوشآمد گویی تنظیم شد به :_\n*"..matches[2].."*\n\n*شما میتوانید از*\n_{rules} ➣ نمایش قوانین گروه_\n_{name} ➣ نام کاربر جدید_\n_{username} ➣ نام کاربری کاربر جدید_\n_استفاده کنید_"
     end
	end
end
-----------------------------------------
local function pre_process(msg)
   local chat = msg.chat_id_
   local user = msg.sender_user_id_
 local data = load_data(_config.moderation.data)
	local function welcome_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
		administration = load_data(_config.moderation.data)
    if administration[arg.chat_id]['setwelcome'] then
     welcome = administration[arg.chat_id]['setwelcome']
      else
     if not lang then
     welcome = "*Welcome Dude*"
    elseif lang then
     welcome = "_خوش آمدید_"
        end
     end
 if administration[tostring(arg.chat_id)]['rules'] then
rules = administration[arg.chat_id]['rules']
else
   if not lang then
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n"
    elseif lang then
       rules = "ℹ️ قوانین پپیشفرض:\n1⃣ ارسال پیام مکرر ممنوع.\n2⃣ اسپم ممنوع.\n3⃣ تبلیغ ممنوع.\n4⃣ سعی کنید از موضوع خارج نشید.\n5⃣ هرنوع نژاد پرستی, شاخ بازی و پورنوگرافی ممنوع .\n➡️ از قوانین پیروی کنید, در صورت عدم رعایت قوانین اول اخطار و در صورت تکرار مسدود.\n"
 end
end
if data.username_ then
user_name = "@"..check_markdown(data.username_)
else
user_name = ""
end
		local welcome = welcome:gsub("{rules}", rules)
		local welcome = welcome:gsub("{name}", check_markdown(data.first_name_))
		local welcome = welcome:gsub("{username}", user_name)
		tdcli.sendMessage(arg.chat_id, arg.msg_id, 0, welcome, 0, "md")
	end
	if data[tostring(chat)] and data[tostring(chat)]['settings'] then
	if msg.adduser then
		welcome = data[tostring(msg.chat_id_)]['settings']['welcome']
		if welcome == "yes" then
			tdcli_function ({
	      ID = "GetUser",
      	user_id_ = msg.adduser
    	}, welcome_cb, {chat_id=chat,msg_id=msg.id_})
		else
			return false
		end
	end
	if msg.joinuser then
		welcome = data[tostring(msg.chat_id_)]['settings']['welcome']
		if welcome == "yes" then
			tdcli_function ({
	      ID = "GetUser",
      	user_id_ = msg.joinuser
    	}, welcome_cb, {chat_id=chat,msg_id=msg.id_})
		else
			return false
        end
		end
	end
 end
return {
patterns ={
"^(راهنما)$",
"^(انلاینی)$",
"^(hjkhjنتنhjااتا)$",
"^(ددتاذتhvhhhhhhhhhhhhللاojkojh)$",
"^(ایدی)$",
"^(ایدی) (.*)$",
"^(سنجاق کردن)$",
"^(حذف سنجاق)$",
"^(اطلاعات گروه)$",
"^(تست)$",
"^(نصب)$",
"^(حذف)$",
"^(انتخاب مدیر)$",
"^(انتخاب مدیر) (.*)$",
"^(حذف مدیر)$",
"^(حذف مدیر) (.*)$",
"^(انتخاب ناظر)$",
"^(انتخاب ناظر) (.*)$",
"^(حذف ناظر)$",
"^(حذف ناظر) (.*)$",
"^(لیست ناظران)$",
"^(لیست مدیران)$",
"^(قفل) (.*)$",
"^(باز کردن) (.*)$",
"^(تنظیمات)$",
"^(لیست بیصدا)$",
"^(بیصدا) (.*)$",
"^(باصدا) (.*)$",
"^(لینک)$",
"^(تنظیم لینک)$",
"^(قوانین)$",
"^(تنظیم قوانین) (.*)$",
"^(درباره)$",
"^(تنظیم درباره) (.*)$",
"^(تنظیم نام) (.*)$",
"^(پاک کردن) (.*)$",
"^(تنظیم فلود) (%d+)$",
"^(رس) (.*)$",
"^(چه کسی) (%d+)$",
"^(راهنما)$",
"^(setlang) (.*)$",
"^(فیلتر) (.*)$",
"^(رفع فیلتر) (.*)$",
"^(لیست فیلتر)$",
"^([https?://w]*.?t.me/joinchat/%S+)$",
"^([https?://w]*.?telegram.me/joinchat/%S+)$",
"^(تنظیم ولکام) (.*)",
"^(ولکام) (.*)$"


},
run=run,
pre_process = pre_process
}
