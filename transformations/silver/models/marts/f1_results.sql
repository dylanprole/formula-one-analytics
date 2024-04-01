{{
  config(
    materialized = 'table',
    partition_by = {
      "field": "race_year",
      "data_type": "int64",
      "range": {
        "start": 1950,
        "end": 2024,
        "interval": 1
      }
    },
    cluster_by = ["season_round", "position"]
    )
}}

with

constructors as (

    select * from {{ ref('stg_bronze__constructors') }}

),

drivers as (

    select * from {{ ref('stg_bronze__drivers') }}

),

races as (

    select * from {{ ref('stg_bronze__races') }}

),

results as (

    select * from {{ ref('stg_bronze__results') }}

),

driver_status as (

    select * from {{ ref('stg_bronze__status') }}

),

results_denormalized as (

    select

        races.race_year,
        races.race_date,
        races.season_round,
        races.circuit_name,
        results.position,
        results.points,
        results.grid_number,
        concat(drivers.first_name, ' ', drivers.last_name) as driver_name,
        drivers.driver_nationality,
        drivers.driver_date_of_birth,
        constructors.constructor_name,
        constructors.constructor_nationality,
        driver_status.status_description,
        results.fastest_lap_rank,
        results.fastest_lap

    from results

    left join constructors
        on results.constructor_id = constructors.constructor_id

    left join drivers
        on results.driver_id = drivers.driver_id

    left join races
        on results.race_id = races.race_id

    left join driver_status
        on results.status_id = driver_status.status_id

)

select * from results_denormalized