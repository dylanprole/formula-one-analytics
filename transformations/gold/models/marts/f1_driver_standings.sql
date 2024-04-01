{{
  config(
    materialized = 'table',
    partition_by = {
      "field": "race_season",
      "data_type": "int64",
      "range": {
        "start": 1950,
        "end": 2024,
        "interval": 1
      }
    }
    )
}}

with

f1_results as (

    select * from {{ ref('stg_silver__f1_results') }}

),

driver_points as (

    select

        -- groupings
        race_year as race_season,
        driver_name,

        -- aggregates
        sum(points) as total_points,

        sum(
            case
                when position = 1 then 1
                else 0
            end
        ) as total_race_wins,

        sum(
            case
                when position in (1, 2, 3) then 1
                else 0
            end
        ) as total_podiums,

        sum(
            case
                when fastest_lap_rank = 1 then 1
                else 0
            end
        ) as total_fastest_laps

    from f1_results

    group by 1, 2

),

driver_standings as (

    select

        race_season,

        row_number() over (
            partition by
                race_season
            order by
                total_points desc,
                total_race_wins desc,
                total_podiums desc
        ) as standing,

        driver_name,
        total_points,
        total_race_wins,
        total_podiums,
        total_fastest_laps
    
    from driver_points

)

select * from driver_standings