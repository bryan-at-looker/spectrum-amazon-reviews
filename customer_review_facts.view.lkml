view: customer_facts {
  extends: [customer_facts_dimensions, customer_review_facts_base]
}

view: customer_review_facts_base {
  extension: required
  derived_table: {
    distribution_style: even
    sortkeys: ["customer_id","min_review_date"]
    datagroup_trigger: everyday
    explore_source: reviews {
      column: customer_id {}
      column: product_count {}
      column: average_stars {}
      column: review_count {}
      column: verified_purchase_review_count {}
      column: min_review_date {}
      column: max_review_date {}
      filters: {
        field: reviews.review_date
        value: "-NULL"
      }
    }
  }
}

view: customer_facts_dimensions {
  extension: required
  dimension: customer_id {  }
  dimension: product_count {
    type: number
  }
  dimension: average_stars {
    type: number
  }
  dimension: review_count {
    type: number
  }
  dimension: verified_purchase_review_count {
    type: number
  }
  dimension_group: min_review_date {
    type: time
  }
  dimension_group: max_review_date {
    type: time
  }
  dimension_group: since_first_review {
    type: duration
    intervals: [month]
    sql_start: ${min_review_date_raw} ;;
    sql_end: ${reviews.review_raw} ;;
  }
}
