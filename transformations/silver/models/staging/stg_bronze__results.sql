with

source as (

      select * from {{ source('bronze', 'results') }}

),

renamed as (

    select

        -- ids
        {{ adapter.quote("resultId") }} as result_id,
        {{ adapter.quote("raceId") }} as race_id,
        {{ adapter.quote("driverId") }} as driver_id,
        {{ adapter.quote("constructorId") }} as constructor_id,
        {{ adapter.quote("statusId") }} as status_id,

        -- strings
        {{ adapter.quote("positionText") }} as position_text,
        {{ adapter.quote("time") }} as race_time,
        {{ adapter.quote("fastestLapTime") }} as fastest_lap_time,

        -- numerics
        {{ adapter.quote("number") }} as driver_number,
        {{ adapter.quote("grid") }} as grid_number,
        {{ adapter.quote("position") }} as position,
        {{ adapter.quote("positionOrder") }} as position_order,
        {{ adapter.quote("points") }} as points,
        {{ adapter.quote("laps") }} as laps,
        {{ adapter.quote("milliseconds") }} as race_milliseconds,
        {{ adapter.quote("fastestLap") }} as fastest_lap,
        {{ adapter.quote("rank") }} as fastest_lap_rank,
        {{ adapter.quote("fastestLapSpeed") }} as fastest_lap_speed

        -- booleans

        -- dates

        -- timestamps

    from source

)

select * from renamed
  