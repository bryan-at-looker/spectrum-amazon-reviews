connection: "spectrum-amazon-reviews"
label: "Amazon Reviews (Prod)"

include: "prod_reviews.view.lkml"                       # include all views in this project
include: "customer_review_facts.view.lkml"
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

datagroup: every_hour {
  sql_trigger: SELECT EXTRACT(HOUR FROM SYSDATE) ;;
  max_cache_age: "24 hours"
}

explore: reviews {
  view_label: "1) Reviews"
  persist_for: "4 hours"
  conditionally_filter: {
    filters: { field: reviews.review_date value: "1 days" }
    unless: [reviews.previous_period_filter]
  }
  join: customer_facts {
    view_label: "3) Customer Facts"
    type: left_outer
    relationship: many_to_one
    sql_on: ${reviews.customer_id} = ${customer_facts.customer_id} ;;
  }
}
