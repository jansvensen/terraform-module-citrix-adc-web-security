#####
# Add Rewrite Actions
#####

resource "citrixadc_rewriteaction" "rw_action_insert" {
  count             = length(var.adc-rw-action-insert.name)
  name              = element(var.adc-rw-action-insert["name"],count.index)
  target            = element(var.adc-rw-action-insert["target"],count.index)
  type              = element(var.adc-rw-action-insert["type"],count.index)
  stringbuilderexpr = element(var.adc-rw-action-insert["stringbuilderexpr"],count.index)
}

resource "citrixadc_rewriteaction" "rw_action_delete" {
  count             = length(var.adc-rw-action-delete.name)
  name              = element(var.adc-rw-action-delete["name"],count.index)
  target            = element(var.adc-rw-action-delete["target"],count.index)
  type              = element(var.adc-rw-action-delete["type"],count.index)
}

#####
# Add Rewrite Policies
#####

resource "citrixadc_rewritepolicy" "rw_policy" {
  count  = length(var.adc-rw-policy.name)
  name   = element(var.adc-rw-policy["name"],count.index)
  action = element(var.adc-rw-policy["action"],count.index)
  rule   = element(var.adc-rw-policy["rule"],count.index)
}

#####
# Add Rewrite Policylabels
#####

resource "citrixadc_rewritepolicylabel" "rw_policylabel" {
  count  = length(var.adc-rw-policylabel.labelname)
  labelname   = element(var.adc-rw-policylabel["labelname"],count.index)
  transform = element(var.adc-rw-policylabel["transform"],count.index)
  comment   = element(var.adc-rw-policylabel["comment"],count.index)
}

#####
# Add Rewrite Policylabel Bindings
#####

resource "citrixadc_rewritepolicylabel_rewritepolicy_binding" "rw_policylabel_rw_policy_binding" {
  count                  = length(var.adc-rw-policylabel-binding.labelname)
  labelname              = element(var.adc-rw-policylabel-binding["labelname"],count.index)
  policyname             = element(var.adc-rw-policylabel-binding["policyname"],count.index)
  gotopriorityexpression = element(var.adc-rw-policylabel-binding["gotopriorityexpression"],count.index)
  priority               = element(var.adc-rw-policylabel-binding["priority"],count.index)
}

#####
# Save config
#####

resource "citrixadc_nsconfig_save" "web_sec_save" {    
    all       = true
    timestamp = timestamp()

  depends_on = [
    citrixadc_rewritepolicylabel_rewritepolicy_binding.rw_policylabel_rw_policy_binding
  ]
}