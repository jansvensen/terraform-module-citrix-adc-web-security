#####
# Variable for administrative connection to the ADC
#####
variable vm {}
variable adc-base {}

#####
# Variable - Rewrite Actions
#####

variable "adc-rw-action-insert" {
}

variable "adc-rw-action-delete" {
}

#-name RWA_RES_AutoSubmitCaptcha replace "HTTP.RES.BODY(20000).SUBSTR(\"enableFormsButton($loginButton);\").AFTER_STR(\";\")" q/"$loginButton.trigger(\"click\");"/
#-name RWA_REQ_InvalidateQuery delete HTTP.REQ.URL.QUERY
#-name RWA_RES_OverrideWith404 replace_http_res q{"HTTP/1.1 404 Not Found\r\nContent-Type: text/html\r\nStrict-Transport-Security: " + AEA_STSHeader_MaxAge + "\r\n\r\n<html><head><meta http-equiv=\"expires\" content=\"0\"><title>404</title></head>" + AEA_Style_Fonts + "<body><p>content not found</p></body></html>"}


#####
# Variable - Rewrite Policies
#####

variable "adc-rw-policy" {
}

#-name RWP_RES_AutoSubmitCaptcha "(HTTP.REQ.HOSTNAME.SERVER == AEA_FQDN_<#%%webappName%%#>) && HTTP.REQ.URL.PATH.EQ(\"/logon/LogonPoint/plugins/ns-gateway/ns-nfactor.js\") && HTTP.RES.BODY(20000).CONTAINS(\"enableFormsButton($loginButton);\")" RWA_RES_AutoSubmitCaptcha
#-name RWP_RES_AnonymizeServerDetails AEA_Feature_AnonymizeServerDetails_isEnabled NOREWRITE
#-name RWP_REQ_InvalidateQuery "AEA_Feature_LimitQueries_isEnabled && HTTP.REQ.URL.QUERY.LENGTH.GE(40)" RWA_REQ_InvalidateQuery -logAction SAMA_Protection_LargeQuery
#-name RWP_RES_Override4xx "AEA_Feature_Drop4xx_isEnabled && HTTP.RES.STATUS.BETWEEN(400,499)" RWA_RES_OverrideWith404
#-name RWP_RES_Drop5xx "AEA_Feature_Drop5xx_isEnabled && HTTP.RES.STATUS.BETWEEN(500,599)" DROP -logAction SAMA_Protection_Error5xxSuppressed

#####
# Variable - Rewrite Policylabels
#####

variable "adc-rw-policylabel" {
}

#####
# Variable - Rewrite Policylabel Bindings
#####

variable "adc-rw-policylabel-binding" {
}