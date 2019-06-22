connection: "spectrum-amazon-reviews"
label: "Amazon Reviews (Stage)"

include: "reviews_persist.view.lkml"                       # include all views in this project
include: "reviews_raw.view.lkml"
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

datagroup: everyday {
  sql_trigger: SELECT CURRENT_DATE ;;
  max_cache_age: "24 hours"
}

datagroup: build_once {
  sql_trigger: SELECT 1 ;;
  max_cache_age: "24 hours"
}


explore: reviews_raw {}
explore: reviews_persist {}
explore: reviews_view_creation {}
