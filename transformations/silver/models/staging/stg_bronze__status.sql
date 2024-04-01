with

source as (

      select * from {{ source('bronze', 'status') }}

),

renamed as (

    select

        -- ids
        {{ adapter.quote("statusId") }} as status_id,

        -- strings
        {{ adapter.quote("status") }} as status_description

    from source

)

select * from renamed
  