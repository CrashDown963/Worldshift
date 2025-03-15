local Err_table = { 
  gs_servicenotavailable = TEXT{"gs_servicenotavailable"},
  gs_servicetemporarynotavailable = TEXT{"gs_servicetemporarynotavailable"},
  gs_invalidparams = TEXT{"gs_invalidparams"},
  gs_incorrectpassword = TEXT{"gs_incorrectpassword"},
  gs_invalidpassword = TEXT{"gs_invalidpassword"},
  gs_nickalreadyused = TEXT{"gs_nickalreadyused"},
  gs_invalidnick = TEXT{"gs_invalidnick"},
  gs_invalidemail = TEXT{"gs_invalidemail"},
  gs_invalidcdkey = TEXT{"gs_invalidcdkey"},
  gs_login = TEXT{"gs_login"},
  gs_loginincorrect = TEXT{"gs_loginincorrect"},
  gs_deleteaccount = TEXT{"gs_deleteaccount"},
  gs_unabletoconnect = TEXT{"gs_unabletoconnect"},
  gs_servererror = TEXT{"gs_servererror"},
  gs_accountalreadycreated = TEXT{"gs_accountalreadycreated"},

  gs_persistisinprogess = TEXT{"gs_persistisinprogess"},
  gs_persistsaveerr = TEXT{"gs_persistsaveerr"},
  gs_persistloaderr = TEXT{"gs_persistloaderr"},

  gs_qrsocket = TEXT{"gs_qrsocket"},
  gs_qrbind = TEXT{"gs_qrbind"},
  gs_qrdns = TEXT{"gs_qrdns"},
  gs_qrconn = TEXT{"gs_qrconn"},
  gs_qrnochallenge = TEXT{"gs_qrnochallenge"},
  
  gs_unknown = TEXT{"gs_unknown"},

  sl_invitationcanceled = TEXT{"sl_invitationcanceled"},
  sl_invitationtimedout = TEXT{"sl_invitationtimedout"},
  sl_invitationnotfound = TEXT{"sl_invitationnotfound"},
  sl_invitationrejected = TEXT{"sl_invitationrejected"},
  sl_invalidchannelname = TEXT{"sl_invalidchannelname"},

  cdkey_invalidkey = TEXT{"cdkey_invalidkey"},
}

function ErrText(key)
  return Err_table[key]
end

function ErrMessage(err, title, callback)
  local errtext = Err_table[err]
  if not errtext then  errtext = err end
  local tit = title or TEXT{"error"}
  MessageBox:Alert(errtext, tit, callback)
end
