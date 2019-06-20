view: reviews_persist {
  derived_table: {
    datagroup_trigger: build_once
    distribution: "review_date"
    sortkeys: ["review_time","marketplace","product_id"]
    explore_source: reviews_raw {
      column: customer_id { field: reviews_raw.customer_id }
      column: helpful_votes { field: reviews_raw.helpful_votes }
      column: marketplace { field: reviews_raw.marketplace }
      column: product_category { field: reviews_raw.product_category }
      column: product_id { field: reviews_raw.product_id }
      column: product_parent { field: reviews_raw.product_parent }
      column: product_title { field: reviews_raw.product_title }
      column: review_body { field: reviews_raw.review_body }
      column: review_time { field: reviews_raw.review_time_raw }
      column: review_date { field: reviews_raw.review_raw }
      column: review_headline { field: reviews_raw.review_headline }
      column: review_id { field: reviews_raw.review_id }
      column: star_rating { field: reviews_raw.star_rating }
      column: total_votes { field: reviews_raw.total_votes }
      column: verified_purchase { field: reviews_raw.verified_purchase }
      column: vine { field: reviews_raw.vine }
#       limit: 100
#       sort: { desc: yes field:reviews_raw.review_raw }
    }
  }
  dimension: customer_id {}
  dimension: helpful_votes {}
  dimension: marketplace {}
  dimension: product_category {}
  dimension: product_id {}
  dimension: product_parent {}
  dimension: product_title {}
  dimension: review_body {}
  dimension: review_time {
    type: date_time
  }
  dimension: review_date {}
  dimension: review_headline {}
  dimension: review_id {}
  dimension: star_rating {}
  dimension: total_votes {}
  dimension: verified_purchase {}
  dimension: vine {}
}

view: reviews_view_creation {
  derived_table: {
    datagroup_trigger: everyday
    create_process: {
      sql_step: DROP VIEW IF EXISTS prod.reviews ;; # drop view first
      sql_step: CREATE VIEW prod.reviews AS
      ( SELECT *
        FROM ${reviews_persist.SQL_TABLE_NAME}
        WHERE review_date <= current_date
          AND review_time <= current_timestamp
      ) ;; # create view of sql from NDT
    }
  }
  dimension: review_id {}
}
