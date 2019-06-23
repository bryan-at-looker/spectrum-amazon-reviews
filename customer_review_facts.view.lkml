view: customer_review_facts {
  derived_table: {
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
}
