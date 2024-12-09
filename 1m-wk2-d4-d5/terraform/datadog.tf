# resource "datadog_dashboard" "webserver_dashboard" {
#   title       = "Webserver Metrics"
#   description = "Dashboard for webserver metrics"
#   layout_type = "ordered"

#   widget {
#     timeseries_definition {
#       request {
#           q = "avg:aws.ec2.cpuutilization{host:web*}"
#           display_type = "line"
#           style {
#             palette = "warn"
#             line_type = "dashed"
#             line_width = "thin"
#           }
#       }
#     }
#   }
#   widget {
#     timeseries_definition {
#       request {
#           q = "avg:system.mem.used{host:web*}"
#           display_type = "line"
#           style {
#             palette = "dog_classic"
#             line_type = "solid"
#             line_width = "normal"
#           }
#       }
#     }
#   }
#   widget {
#     timeseries_definition {
#       request {
#           q = "avg:system.disk.used{host:web*}"
#           display_type = "line"
#           style {
#             palette = "dog_classic"
#             line_type = "solid"
#             line_width = "normal"
#           }
#       }
#     }
#   }

#   tags = ["webserver"]
# }
