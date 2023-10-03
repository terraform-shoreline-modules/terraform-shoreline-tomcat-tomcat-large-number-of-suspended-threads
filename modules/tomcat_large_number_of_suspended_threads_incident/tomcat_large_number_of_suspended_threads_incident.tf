resource "shoreline_notebook" "tomcat_large_number_of_suspended_threads_incident" {
  name       = "tomcat_large_number_of_suspended_threads_incident"
  data       = file("${path.module}/data/tomcat_large_number_of_suspended_threads_incident.json")
  depends_on = [shoreline_action.invoke_set_thread_pool_settings]
}

resource "shoreline_file" "set_thread_pool_settings" {
  name             = "set_thread_pool_settings"
  input_file       = "${path.module}/data/set_thread_pool_settings.sh"
  md5              = filemd5("${path.module}/data/set_thread_pool_settings.sh")
  description      = "Tune the thread pool settings in Tomcat to prevent the creation of too many threads and limit the amount of time a thread is allowed to remain suspended."
  destination_path = "/agent/scripts/set_thread_pool_settings.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_set_thread_pool_settings" {
  name        = "invoke_set_thread_pool_settings"
  description = "Tune the thread pool settings in Tomcat to prevent the creation of too many threads and limit the amount of time a thread is allowed to remain suspended."
  command     = "`chmod +x /agent/scripts/set_thread_pool_settings.sh && /agent/scripts/set_thread_pool_settings.sh`"
  params      = ["MAX_IDLE_TIME","MAX_THREADS"]
  file_deps   = ["set_thread_pool_settings"]
  enabled     = true
  depends_on  = [shoreline_file.set_thread_pool_settings]
}

