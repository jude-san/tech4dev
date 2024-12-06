# resource "datadog_dashboard" "ubuntu_nginx_dashboard" {
#   title       = "Ubuntu Nginx Metrics and Traces"
#   layout_type = "ordered"

#   widget {
#     title = "CPU Utilization"
#     definition {
#       type = "timeseries"
#       requests {
#         q = "avg:aws.ec2.cpuutilization{host:nginx}"
#       }
#     }
#   }

#   widget {
#     title = "Memory Utilization"
#     definition {
#       type = "timeseries"
#       requests {
#         q = "avg:system.mem.used{host:nginx}"
#       }
#     }
#   }

#   widget {
#     title = "Nginx Access Logs"
#     definition {
#       type = "log_stream"
#       requests {
#         query = "service:nginx @host:nginx"
#       }
#     }
#   }

#   widget {
#     title = "Application Traces"
#     definition {
#       type = "trace_stream"
#       requests {
#         query_string = "env:production"
#         service      = "nginx-service"
#       }
#     }
#   }
# }
